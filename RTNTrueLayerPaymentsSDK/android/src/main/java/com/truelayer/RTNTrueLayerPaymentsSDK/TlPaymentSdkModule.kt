package com.truelayer.RTNTrueLayerPaymentsSDK;

import android.app.Activity
import android.content.Intent
import android.util.SparseArray
import com.facebook.react.bridge.ActivityEventListener
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeMap
import com.truelayer.payments.core.domain.configuration.Environment
import com.truelayer.payments.core.domain.errors.TrueLayerConfigurationError
import com.truelayer.payments.core.domain.utils.onError
import com.truelayer.payments.core.domain.utils.onOk
import com.truelayer.payments.ui.TrueLayerUI
import com.truelayer.payments.ui.screens.processor.PaymentUseCase
import com.truelayer.payments.ui.screens.processor.ProcessorActivityContract
import com.truelayer.payments.ui.screens.processor.ProcessorContext
import com.truelayer.payments.ui.screens.processor.ProcessorResult
import com.truelayerpayments.NativeTrueLayerPaymentsSDKSpec
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch

private class TLReactNativeUtils {
    companion object {
        fun extractMandateContext(map: ReadableMap?, preferences: ReadableMap?): ProcessorContext.MandateContext? {
            val id = map?.getString("mandateId")
            val token = map?.getString("resourceToken")
            val redirectUri = map?.getString("redirectUri")
            val preferredCountryCode = preferences?.getString("preferredCountryCode")

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

        fun extractPaymentContext(map: ReadableMap?, preferences: ReadableMap?): ProcessorContext.PaymentContext? {
            val id = map?.getString("paymentId")
            val token = map?.getString("resourceToken")
            val redirectUri = map?.getString("redirectUri")
            val preferredCountryCode = preferences?.getString("preferredCountryCode")
            val useCase = preferences?.getString("paymentUseCase")

            return if (id != null && token != null && redirectUri != null) {
                ProcessorContext.PaymentContext(
                    id = id,
                    resourceToken = token,
                    redirectUri = redirectUri,
                    preferences = ProcessorContext.PaymentPreferences(
                        preferredCountryCode = preferredCountryCode,
                        paymentUseCase = PaymentUseCase.values().firstOrNull { it.name.equals(useCase, true) } ?: PaymentUseCase.default
                    )
                )
            } else {
                null
            }
        }

        fun createProcessorFailureResult(reason: ProcessorResult.FailureReason): WritableMap {
            val map: WritableMap = WritableNativeMap()
            map.putString("type", "Failure")
            map.putString("reason", reason.name)
            return map
        }

        fun createProcessorSuccessResult(step: ProcessorResult.PaymentStep): WritableMap {
            val map: WritableMap = WritableNativeMap()
            map.putString("type", "Success")
            map.putString("step", step.name)
            return map
        }
    }
}

private fun WritableMap.concatenate(map: WritableMap) {
    map.entryIterator.forEach { entry ->
        when( val value = entry.value) {
            is String -> this.putString(entry.key, value)
            is Int -> this.putInt(entry.key, value)
            is Boolean -> this.putBoolean(entry.key, value)
            is Double -> this.putDouble(entry.key, value)
            is ReadableMap -> this.putMap(entry.key, value)
            is ReadableArray -> this.putArray(entry.key, value)
            null -> this.putNull(entry.key)
        }

    }
}

class TlPaymentSdkModule(reactContext: ReactApplicationContext):
    NativeTrueLayerPaymentsSDKSpec(reactContext), ActivityEventListener {

    val mPromises: SparseArray<Promise> = SparseArray()
    var trueLayerUI: TrueLayerUI? = null

    val scope = CoroutineScope(
        SupervisorJob() +
                Dispatchers.IO
    )

    companion object {
        const val NAME = "RTNTrueLayerPaymentsSDK"
    }

    override fun getName(): String {
        return "RTNTrueLayerPaymentsSDK"
    }

    override fun initialize() {
        super.initialize()
        reactApplicationContext.addActivityEventListener(this)
    }

    override fun _configure(
        environment: String?,
        promise: Promise?
    ) {
        val env = Environment.values().firstOrNull { it.name == environment } ?: Environment.PRODUCTION
        // we ignore the outcome in here for now
        val out = TrueLayerUI.init(reactApplicationContext) {
            this.environment = env
        }
        out.onOk {
            trueLayerUI = it
            promise?.resolve(null)
        }.onError {
            promise?.reject(it.cause)
        }
    }

    override fun _processPayment(
        paymentContext: ReadableMap?,
        prefereces: ReadableMap?,
        promise: Promise?
    ) {
        checkInitialized()?.let {
            promise?.reject(it)
            return
        }

        val activity = reactApplicationContext.currentActivity
        val extractedContext = TLReactNativeUtils.extractPaymentContext(paymentContext, prefereces)
        if (extractedContext == null) {
            promise?.resolve(
                TLReactNativeUtils.createProcessorFailureResult(ProcessorResult.FailureReason.ProcessorContextNotAvailable)
            )
            return
        }

        activity?.let {
            val intent = ProcessorActivityContract().createIntent(
                it,
                extractedContext
            )
            it.startActivityForResult(intent, 0)
        }
        mPromises.put(0, promise)

    }

    private fun checkInitialized(): Exception? {
        return if (trueLayerUI == null) {
            TrueLayerConfigurationError.NotInitialised("")
        } else {
            null
        }
    }

    override fun _processMandate(
        mandateContext: ReadableMap?,
        prefereces: ReadableMap?,
        promise: Promise?
    ) {
        checkInitialized()?.let {
            promise?.reject(it)
            return
        }

        val activity = reactApplicationContext.currentActivity
        val extractedContext = TLReactNativeUtils.extractMandateContext(mandateContext, prefereces)
        if (extractedContext == null) {
            promise?.resolve(
                TLReactNativeUtils.createProcessorFailureResult(ProcessorResult.FailureReason.ProcessorContextNotAvailable)
            )
            return
        }

        activity?.let {
            val intent = ProcessorActivityContract().createIntent(
                it,
                extractedContext
            )
            it.startActivityForResult(intent, 0)
        }
        mPromises.put(0, promise)

    }

    override fun _mandateStatus(mandateId: String?, resourceToken: String?, promise: Promise?) {
        checkInitialized()?.let {
            promise?.reject(it)
            return
        }
        if (mandateId == null || resourceToken == null) {
            promise?.resolve(
                TLReactNativeUtils.createProcessorFailureResult(ProcessorResult.FailureReason.ProcessorContextNotAvailable)
            )
            return
        }

        scope.launch(Dispatchers.IO) {
            TrueLayerUI.getMandateStatus(
                mandateId,
                resourceToken
            )
        }
    }

    override fun _paymentStatus(paymentId: String?, resourceToken: String?, promise: Promise?) {
        checkInitialized()?.let {
            promise?.reject(it)
            return
        }
        if (paymentId == null || resourceToken == null) {
            promise?.resolve(
                TLReactNativeUtils.createProcessorFailureResult(ProcessorResult.FailureReason.ProcessorContextNotAvailable)
            )
            return
        }

        scope.launch(Dispatchers.IO) {
            TrueLayerUI.getPaymentStatus(
                paymentId,
                resourceToken
            )
        }
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
                    result.concatenate(TLReactNativeUtils.createProcessorSuccessResult(sdkResult.step))
                }
                is ProcessorResult.Failure -> {
                    result.concatenate(TLReactNativeUtils.createProcessorFailureResult(sdkResult.reason))
                }
                null -> { } // just ignore
            }

            promise.resolve(result)
        }
    }
}
