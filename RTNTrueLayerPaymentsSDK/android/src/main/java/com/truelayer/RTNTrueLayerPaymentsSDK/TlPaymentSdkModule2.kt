package com.truelayer.RTNTrueLayerPaymentsSDK;

import android.app.Activity
import android.content.Intent
import android.util.Log;
import android.util.SparseArray;

import androidx.annotation.NonNull;
import com.facebook.react.bridge.*
import com.truelayer.payments.core.domain.configuration.Environment
import com.truelayer.payments.ui.TrueLayerUI
import com.truelayer.payments.ui.screens.processor.ProcessorActivityContract
import com.truelayer.payments.ui.screens.processor.ProcessorContext
import com.truelayer.payments.ui.screens.processor.ProcessorResult

import com.truelayerpayments.NativeTrueLayerPaymentsSDKSpec;

class TlPaymentSdkModule2(reactContext: ReactApplicationContext): NativeTrueLayerPaymentsSDKSpec(reactContext), ActivityEventListener {

    private val TAG = "TlPaymentSdkModule2";
    val mPromises: SparseArray<Promise> = SparseArray()

    override fun getName(): String {
        return "RTNTrueLayerPaymentsSDK";
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
        }
        return "configuration successfull"
    }

    override fun processPayment(
        paymentContext: ReadableMap?,
        prefereces: ReadableMap?,
        promise: Promise?
    ) {

    }

    override fun processMandate(
        mandateContext: ReadableMap?,
        prefereces: ReadableMap?,
        promise: Promise?
    ) {
        Log.e(TAG,"context: $mandateContext, preferences: $prefereces")

        val activity = reactApplicationContext.currentActivity
        val prefs = prefereces?.let {
            val countryCode: String? = it.getString("preferredCountryCode")
            ProcessorContext.MandatePreferences(
                preferredCountryCode = countryCode
            )
        }

        activity?.let {
            val intent = ProcessorActivityContract().createIntent(
                it,
                ProcessorContext.MandateContext(
                    "",
                    "",
                    "",
                    prefs
                )
            )
            it.startActivityForResult(intent, 0)
        }
        mPromises.put(0, promise)

    }

    override fun onNewIntent(p0: Intent?) {

    }

    override fun getConstants(): Map<String, Any>? {
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
            val sdkResult = ProcessorResult.unwrapResult(data)

            var map = WritableNativeMap()
            when (sdkResult) {
                is ProcessorResult.Successful -> {
                    Log.e(TAG, "sdkResult: success ${sdkResult.step}")
                    map.putString("result", "success")
                    map.putString("step", sdkResult.step.name)
                }
                is ProcessorResult.Failure -> {
                    Log.e(TAG, "sdkResult: failure ${sdkResult.reason}")
                    map.putString("result", "failure")
                    map.putString("reason", sdkResult.reason.name)
                }
                null -> map = Arguments.makeNativeMap(data?.extras)
            }
//      result.putMap("data", Arguments.makeNativeMap(data.extras))
            result.putMap("data", map)
            promise.resolve(result)
        }
    }
}
