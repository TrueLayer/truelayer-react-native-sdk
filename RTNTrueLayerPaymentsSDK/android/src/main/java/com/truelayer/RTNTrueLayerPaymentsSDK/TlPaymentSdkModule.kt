package com.truelayer.RTNTrueLayerPaymentsSDK;

import android.app.Activity
import android.content.Intent
import android.util.Log
import android.util.SparseArray
import com.facebook.react.bridge.ActivityEventListener
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeMap
import com.truelayer.payments.core.domain.configuration.Environment
import com.truelayer.payments.core.domain.configuration.HttpConnectionConfiguration
import com.truelayer.payments.core.domain.configuration.HttpLoggingLevel
import com.truelayer.payments.ui.TrueLayerUI
import com.truelayer.payments.ui.screens.processor.ProcessorActivityContract
import com.truelayer.payments.ui.screens.processor.ProcessorContext
import com.truelayer.payments.ui.screens.processor.ProcessorResult
import com.truelayerpayments.NativeTrueLayerPaymentsSDKSpec

class TlPaymentSdkModule(reactContext: ReactApplicationContext):
    NativeTrueLayerPaymentsSDKSpec(reactContext), ActivityEventListener {


    val mPromises: SparseArray<Promise> = SparseArray()

    companion object {
        const val NAME = "RTNTrueLayerPaymentsSDK"
        private const val TAG = "TlPaymentSdkModule"
    }

    override fun getName(): String {
        return "RTNTrueLayerPaymentsSDK"
    }

    override fun initialize() {
        super.initialize()
        reactApplicationContext.addActivityEventListener(this)
    }

    override fun configureSDK(): String {
        Log.e(TAG, "configureSDK()")
        // we ignore the outcome in here for now
        TrueLayerUI.init(reactApplicationContext) {
            environment = Environment.SANDBOX
            httpConnection = HttpConnectionConfiguration(
                httpDebugLoggingLevel = HttpLoggingLevel.Body
            )
        }
        return "configuration successfull"
    }

    override fun processPayment(
        paymentContext: ReadableMap?,
        prefereces: ReadableMap?,
        promise: Promise?
    ) {

    }

    private fun extractMandateContext(map: ReadableMap?, prefereces: ReadableMap?): ProcessorContext.MandateContext? {
        val id = map?.getString("mandateId")
        val token = map?.getString("resourceToken")
        val redirectUri = map?.getString("redirectUri")
        val preferredCountryCode = prefereces?.getString("preferredCountryCode")

        return if (id != null && token != null && redirectUri != null) {
            ProcessorContext.MandateContext(
                id = id,
                resourceToken = token,
                redirectUri = redirectUri,
                preferences = ProcessorContext.MandatePreferences(
                    preferredCountryCode = preferredCountryCode
                )
            )
        } else {
            null
        }
    }

    override fun processMandate(
        mandateContext: ReadableMap?,
        prefereces: ReadableMap?,
        promise: Promise?
    ) {
        Log.i(TAG,"context: $mandateContext, preferences: $prefereces")

        val activity = reactApplicationContext.currentActivity
        val extractedContext = extractMandateContext(mandateContext, prefereces)
        if (extractedContext == null) {
            val map: WritableMap = WritableNativeMap()
            map.putString("type", "Failure")
            map.putString("reason", ProcessorResult.FailureReason.ProcessorContextNotAvailable.name)
            promise?.resolve(map)
            return
        }
        Log.i(TAG,"extractedContext: $extractedContext")
        activity?.let {
            val intent = ProcessorActivityContract().createIntent(
                it,
                extractedContext
            )
            it.startActivityForResult(intent, 0)
        }
        mPromises.put(0, promise)

    }

    override fun onNewIntent(p0: Intent?) {

    }

    override fun getConstants(): Map<String, Any> {
        val constants: HashMap<String, Any> = HashMap()
        constants["OK"] = Activity.RESULT_OK
        constants["CANCELED"] = Activity.RESULT_CANCELED
        return constants
    }

    fun startActivity(action: String?, data: ReadableMap?) {
        Log.e(TAG, "startActivity: $action, data $data")
        val activity = reactApplicationContext.currentActivity
        val intent = Intent(action)
        Arguments.toBundle(data)?.let { intent.putExtras(it) }
        activity!!.startActivity(intent)
    }

    @ReactMethod
    fun startActivityForResult(
        requestCode: Int,
        action: String?,
        data: ReadableMap?,
        promise: Promise
    ) {
        val activity = reactApplicationContext.currentActivity
        val intent = Intent(action)
        Arguments.toBundle(data)?.let { intent.putExtras(it) }
        activity!!.startActivityForResult(intent, requestCode)
        mPromises.put(requestCode, promise)
    }

    @ReactMethod
    fun resolveActivity(action: String?, promise: Promise) {
        val activity = reactApplicationContext.currentActivity
        val intent = Intent(action)
        val componentName = intent.resolveActivity(activity!!.packageManager)
        if (componentName == null) {
            promise.resolve(null)
            return
        }
        val map: WritableMap = WritableNativeMap()
        map.putString("class", componentName.className)
        map.putString("package", componentName.packageName)
        promise.resolve(map)
    }

    @ReactMethod
    fun finish(result: Int, action: String?, map: ReadableMap?) {
        val activity = reactApplicationContext.currentActivity
        val intent = Intent(action)
        Arguments.toBundle(map)?.let { intent.putExtras(it) }
        activity!!.setResult(result, intent)
        activity.finish()
    }

    override fun onActivityResult(
        activity: Activity,
        requestCode: Int,
        resultCode: Int,
        data: Intent?
    ) {
        val promise = mPromises[requestCode]
        if (promise != null) {
            val result: WritableMap = WritableNativeMap()
            result.putInt("resultCode", resultCode)
            when (val sdkResult = ProcessorResult.unwrapResult(data)) {
                is ProcessorResult.Successful -> {
                    Log.e(TAG, "sdkResult: success ${sdkResult.step}")
                    result.putString("type", "Success")
                    result.putString("step", sdkResult.step.name)
                }
                is ProcessorResult.Failure -> {
                    Log.e(TAG, "sdkResult: failure ${sdkResult.reason}")
                    result.putString("type", "Failure")
                    result.putString("reason", sdkResult.reason.name)
                }
                null -> { } // just ignore
            }

            promise.resolve(result)
        }
    }
}
