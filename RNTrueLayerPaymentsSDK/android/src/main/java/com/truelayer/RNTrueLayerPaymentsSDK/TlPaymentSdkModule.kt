package com.truelayer.RNTrueLayerPaymentsSDK

import android.app.Activity
import android.content.Intent
import android.os.Bundle
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
import com.truelayer.RNTrueLayerPaymentsSDK.TLReactNativeUtils.Companion.createProcessorFailureResult
import com.truelayer.RNTrueLayerPaymentsSDK.TLReactNativeUtils.Companion.createStatusFailure
import com.truelayer.RNTrueLayerPaymentsSDK.TLReactNativeUtils.Companion.mapMandateStatus
import com.truelayer.RNTrueLayerPaymentsSDK.TLReactNativeUtils.Companion.mapPaymentResultShown
import com.truelayer.RNTrueLayerPaymentsSDK.TLReactNativeUtils.Companion.mapPaymentStatus
import com.truelayer.payments.core.domain.configuration.Environment
import com.truelayer.payments.core.domain.errors.CoreError
import com.truelayer.payments.core.domain.errors.TrueLayerConfigurationError
import com.truelayer.payments.core.domain.utils.onError
import com.truelayer.payments.core.domain.utils.onOk
import com.truelayer.payments.ui.TrueLayerUI
import com.truelayer.payments.ui.models.ProcessorStatus
import com.truelayer.payments.ui.screens.processor.ProcessorActivityContract
import com.truelayer.payments.ui.screens.processor.ProcessorContext
import com.truelayer.payments.ui.screens.processor.ProcessorResult
import com.truelayerpayments.NativeTrueLayerPaymentsSDKSpec
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import java.util.HashMap
import kotlin.contracts.ExperimentalContracts
import kotlin.contracts.contract

private class TLReactNativeUtils {
    class ContextExtractor(
        map: ReadableMap?,
        preferences: ReadableMap?
    ) {
        val paymentId: String?
        val mandateId: String?
        val token: String?
        val redirectUri: String?
        val preferredCountryCode: String?
        val shouldPresentResultScreen: Boolean?
        val waitTimeMillis: Long?

        init {
            mandateId = map?.getString("mandateId")
            paymentId = map?.getString("paymentId")
            token = map?.getString("resourceToken")
            redirectUri = map?.getString("redirectUri")
            preferredCountryCode = preferences?.getString("preferredCountryCode")
            shouldPresentResultScreen = preferences?.getBooleanOrNull("shouldPresentResultScreen")
            waitTimeMillis = preferences?.getIntOrNull("waitTimeMillis")?.toLong()
        }

        @OptIn(ExperimentalContracts::class)
        fun isValidMandate(mandateId: String?, token: String?, redirectUri: String?): Boolean {
            contract {
                returns(true) implies (mandateId != null && token != null && redirectUri != null)
            }
            return mandateId != null && token != null && redirectUri != null
        }

        @OptIn(ExperimentalContracts::class)
        fun isValidPayment(paymentId: String?, token: String?, redirectUri: String?): Boolean {
            contract {
                returns(true) implies (paymentId != null && token != null && redirectUri != null)
            }
            return paymentId != null && token != null && redirectUri != null
        }

        fun getMandateContext(): ProcessorContext.MandateContext? {
            if (!isValidMandate(mandateId, token, redirectUri)) return null
            return ProcessorContext.MandateContext(
                id = mandateId,
                resourceToken = token,
                redirectUri = redirectUri,
                preferences = ProcessorContext.MandatePreferences(
                    preferredCountryCode = preferredCountryCode,
                    shouldPresentResultScreen = shouldPresentResultScreen ?: true,
                    waitTimeMillis = waitTimeMillis ?: 3_000
                )
            )
        }

        fun getPaymentContext(): ProcessorContext.PaymentContext? {
            if (!isValidPayment(paymentId, token, redirectUri)) return null
            return ProcessorContext.PaymentContext(
                id = paymentId,
                resourceToken = token,
                redirectUri = redirectUri,
                preferences = ProcessorContext.PaymentPreferences(
                    preferredCountryCode = preferredCountryCode,
                    shouldPresentResultScreen = shouldPresentResultScreen ?: true,
                    waitTimeMillis = waitTimeMillis ?: 3_000
                )
            )
        }
    }
    companion object {
        fun mapFailureReason(reason: ProcessorResult.FailureReason): String {
            /*
                export type FailureReason =
                  | "NoInternet"
                  | "UserAborted"
                  | "ProviderOffline"
                  | "CommunicationIssue"
                  | "ConnectionSecurityIssue"
                  | "PaymentFailed"
                  | "WaitAbandoned"
                  | "ProcessorContextNotAvailable"
                  | "Unknown";
             */
            
            return when (reason) {
                ProcessorResult.FailureReason.NoInternet -> "NoInternet"
                ProcessorResult.FailureReason.UserAborted -> "UserAborted"
                ProcessorResult.FailureReason.UserAbortedProviderTemporarilyUnavailable -> "ProviderOffline"
                ProcessorResult.FailureReason.UserAbortedFailedToNotifyBackend -> "UserAborted"
                ProcessorResult.FailureReason.UserAbortedProviderTemporarilyUnavailableFailedToNotifyBackend -> "ProviderOffline"
                ProcessorResult.FailureReason.CommunicationIssue -> "CommunicationIssue"
                ProcessorResult.FailureReason.ConnectionSecurityIssue -> "ConnectionSecurityIssue"
                ProcessorResult.FailureReason.PaymentFailed -> "PaymentFailed"
                ProcessorResult.FailureReason.WaitAbandoned -> "WaitAbandoned"
                ProcessorResult.FailureReason.WaitTokenExpired -> "CommunicationIssue"
                ProcessorResult.FailureReason.ProcessorContextNotAvailable -> "ProcessorContextNotAvailable"
                ProcessorResult.FailureReason.InvalidResource -> "Unknown"
                ProcessorResult.FailureReason.Unknown -> "Unknown"
            }
        }

        fun mapPaymentStep(step: ProcessorResult.PaymentStep): String {
            /*
                export enum ProcessorStep {
                  Redirect = "Redirect",
                  Wait = "Wait",
                  Authorized = "Authorized",
                  Executed = "Executed",
                  Settled = "Settled",
                }
             */
            return when (step) {
                ProcessorResult.PaymentStep.Redirect -> "Redirect"
                ProcessorResult.PaymentStep.Wait -> "Wait"
                ProcessorResult.PaymentStep.Authorized -> "Authorized"
                ProcessorResult.PaymentStep.Successful -> "Executed"
                ProcessorResult.PaymentStep.Settled -> "Settled"
            }
        }


        fun mapPaymentResultShown(resultShown: ProcessorResult.ResultShown): String {
            /*
                export enum ResultShown {
                  NoneShown = "NoneShown",
                  NoneInvalidState = "NoneInvalidState",
                  Success = "Success",
                  Initiated = "Initiated",
                  InsufficientFunds = "InsufficientFunds",
                  PaymentLimitExceeded = "PaymentLimitExceeded",
                  UserCanceledAtProvider = "UserCanceledAtProvider",
                  AuthorizationFailed = "AuthorizationFailed",
                  Expired = "Expired",
                  InvalidAccountDetails = "InvalidAccountDetails",
                  GenericFailed = "GenericFailed",
                }
            */
            return when (resultShown) {
                ProcessorResult.ResultShown.None -> "NoneShown"
                ProcessorResult.ResultShown.Initiated -> "Initiated"
                ProcessorResult.ResultShown.Success -> "Success"
                ProcessorResult.ResultShown.InsufficientFunds -> "InsufficientFunds"
                ProcessorResult.ResultShown.PaymentLimitExceeded -> "PaymentLimitExceeded"
                ProcessorResult.ResultShown.UserCanceledAtProvider -> "UserCanceledAtProvider"
                ProcessorResult.ResultShown.AuthorizationFailed -> "AuthorizationFailed"
                ProcessorResult.ResultShown.Expired -> "Expired"
                ProcessorResult.ResultShown.InvalidAccountDetails -> "InvalidAccountDetails"
                ProcessorResult.ResultShown.InvalidGenericWithoutRetry -> "GenericFailed"
                ProcessorResult.ResultShown.Failed -> "GenericFailed"
            }
        }

        /*
            export type ProcessorResult =
              | { type: ResultType.Success; step: ProcessorStep, resultShown: ResultShown }
              | { type: ResultType.Failure; reason: FailureReason, resultShown: ResultShown };
         */
        fun createProcessorFailureResult(reason: ProcessorResult.FailureReason, resultShown: ProcessorResult.ResultShown): WritableMap {
            val map: WritableMap = WritableNativeMap()
            map.putString("type", "Failure")
            map.putString("reason", mapFailureReason(reason))
            map.putString("resultShown", mapPaymentResultShown(resultShown))
            return map
        }

        /*
            export type ProcessorResult =
              | { type: ResultType.Success; step: ProcessorStep, resultShown: ResultShown }
              | { type: ResultType.Failure; reason: FailureReason, resultShown: ResultShown };
         */
        fun createProcessorSuccessResult(step: ProcessorResult.PaymentStep, resultShown: ProcessorResult.ResultShown): WritableMap {
            val map: WritableMap = WritableNativeMap()
            map.putString("type", "Success")
            map.putString("step", mapPaymentStep(step))
            map.putString("resultShown", mapPaymentResultShown(resultShown))
            return map
        }

        /*
            export enum PaymentStatus {
              AuthorizationRequired = "AuthorizationRequired",
              Authorized = "Authorized",
              Authorizing = "Authorizing",
              Executed = "Executed",
              Failed = "Failed",
              Settled = "Settled",
            }
         */
        fun mapPaymentStatus(status: ProcessorStatus): String =
            when (status) {
                ProcessorStatus.AuthorizationRequired -> "AuthorizationRequired"
                ProcessorStatus.Authorizing -> "Authorizing"
                ProcessorStatus.Authorized -> "Authorized"
                ProcessorStatus.Executed -> "Executed"
                ProcessorStatus.Settled -> "Settled"
                ProcessorStatus.Revoked, // this one doesn't exist in payments
                ProcessorStatus.Failed -> "Failed"
            }

        /*
            export enum MandateStatus {
              AuthorizationRequired = "AuthorizationRequired",
              Authorized = "Authorized",
              Authorizing = "Authorizing",
              Failed = "Failed",
              Revoked = "Revoked",
            }
         */
        fun mapMandateStatus(status: ProcessorStatus): String =
            when (status) {
                ProcessorStatus.AuthorizationRequired -> "AuthorizationRequired"
                ProcessorStatus.Authorizing -> "Authorizing"
                ProcessorStatus.Authorized -> "Authorized"
                ProcessorStatus.Revoked -> "Revoked"
                ProcessorStatus.Failed -> "Failed"
                // this does not exist in mandates
                ProcessorStatus.Executed,
                // this does not exist in mandates
                // mapping both as failed
                ProcessorStatus.Settled -> "Failed"
            }

        fun createStatusFailure(error: CoreError) =
            WritableNativeMap().apply {
                putString("type", "Failure")
                putMap("failure", mapToFailure(error))
            }

        fun mapToFailure(error: CoreError): WritableNativeMap =
            WritableNativeMap().apply {
                putString("reason", mapFailureReason(error.intoProcessorResult().reason))
                putString("errorMessage", error.message)
                putString("traceId", error.traceId)
                putString("causeException", error.cause?.toString())
                when (error) {
                    is CoreError.CertificateValidationError,
                    is CoreError.ConnectionError -> { } // ignore
                    is CoreError.HttpError.InvalidParameters -> {
                        putInt("httpResponseCode", error.httpStatusCode)
                        putString("rawResponseBody", error.responseBody)
                        putString("title", error.title)
                        putString("description", error.description)
                    }
                    is CoreError.HttpError.ServerError -> {
                        putInt("httpResponseCode", error.httpStatusCode)
                        putString("rawResponseBody", error.responseBody)
                        putString("title", error.title)
                        putString("description", error.description)
                    }
                    is CoreError.ValidationError -> {
                        putString("rawResponseBody", error.responseBody)
                    }
                }
            }
    }
}

private fun String?.convertToEnvironment() = Environment.values().firstOrNull { it.name == this } ?: Environment.PRODUCTION

private fun CoreError.intoProcessorResult(): ProcessorResult.Failure = when (this) {
    is CoreError.ConnectionError ->
        ProcessorResult.Failure(ProcessorResult.FailureReason.NoInternet, ProcessorResult.ResultShown.None)
    is CoreError.CertificateValidationError ->
        ProcessorResult.Failure(ProcessorResult.FailureReason.ConnectionSecurityIssue, ProcessorResult.ResultShown.None)
    is CoreError.HttpError,
    is CoreError.ValidationError ->
        ProcessorResult.Failure(ProcessorResult.FailureReason.CommunicationIssue, ProcessorResult.ResultShown.None)
}

private fun WritableMap.concatenate(map: WritableMap) {
    map.entryIterator.forEach { entry ->
        when (val value = entry.value) {
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

class TlPaymentSdkModule(reactContext: ReactApplicationContext) :
    NativeTrueLayerPaymentsSDKSpec(reactContext), ActivityEventListener {

    val mPromises: SparseArray<Promise> = SparseArray()
    var trueLayerUI: TrueLayerUI? = null
    var themeMap: HashMap<String, Any>? = null

    val scope = CoroutineScope(
        SupervisorJob() +
            Dispatchers.IO
    )

    companion object {
        const val NAME = "RNTrueLayerPaymentsSDK"
    }

    override fun getName(): String {
        return "RNTrueLayerPaymentsSDK"
    }

    override fun initialize() {
        super.initialize()
        reactApplicationContext.addActivityEventListener(this)
    }

    override fun _configure(
        environment: String?,
        theme: ReadableMap?,
        promise: Promise?
    ) {
        val env = environment.convertToEnvironment()
        themeMap = theme?.getMap("android")?.toHashMap()

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
        preferences: ReadableMap?,
        promise: Promise?
    ) {
        checkInitialized()?.let {
            promise?.reject(it)
            return
        }

        val activity = reactApplicationContext.currentActivity
        val contextExtractor = TLReactNativeUtils.ContextExtractor(paymentContext, preferences)
        val extractedContext: ProcessorContext.PaymentContext? = contextExtractor.getPaymentContext()
        if (extractedContext == null) {
            promise?.resolve(
                createProcessorFailureResult(ProcessorResult.FailureReason.ProcessorContextNotAvailable, ProcessorResult.ResultShown.None)
            )
            return
        }

        activity?.let {
            val intent = ProcessorActivityContract().createIntent(
                it,
                extractedContext
            )
            intent.putExtra("react-native", true)
            intent.putExtra("react-native-sdk-version", BuildConfig.RN_TL_SDK_VERSION)
            intent.putExtra("theme", themeMap)
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
        preferences: ReadableMap?,
        promise: Promise?
    ) {
        checkInitialized()?.let {
            promise?.reject(it)
            return
        }

        val activity = reactApplicationContext.currentActivity
        val contextExtractor = TLReactNativeUtils.ContextExtractor(mandateContext, preferences)
        val extractedContext: ProcessorContext.MandateContext? = contextExtractor.getMandateContext()
        if (extractedContext == null) {
            promise?.resolve(
                createProcessorFailureResult(ProcessorResult.FailureReason.ProcessorContextNotAvailable, ProcessorResult.ResultShown.None)
            )
            return
        }

        activity?.let {
            val intent = ProcessorActivityContract().createIntent(
                it,
                extractedContext
            )
            intent.putExtra("react-native", true)
            intent.putExtra("react-native-sdk-version", BuildConfig.RN_TL_SDK_VERSION)
            intent.putExtra("theme", themeMap)
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
                createProcessorFailureResult(ProcessorResult.FailureReason.ProcessorContextNotAvailable, ProcessorResult.ResultShown.None)
            )
            return
        }

        val bundle = Bundle()
        bundle.putBoolean("react-native", true)
        bundle.putString("react-native-sdk-version", BuildConfig.RN_TL_SDK_VERSION)

        scope.launch(Dispatchers.IO) {
            TrueLayerUI.getMandateStatus(
                mandateId,
                resourceToken,
                bundle
            )
                .onOk {
                    val mandateStatusResult = WritableNativeMap().apply {
                        putString("type", "Success")
                        putString("status", mapMandateStatus(it))
                        putString("resultShown", mapPaymentResultShown(ProcessorResult.ResultShown.None))
                    }

                    promise?.resolve(mandateStatusResult)
                }
                .onError {
                    promise?.resolve(createStatusFailure(it))
                }
        }
    }

    override fun _paymentStatus(paymentId: String?, resourceToken: String?, promise: Promise?) {
        checkInitialized()?.let {
            promise?.reject(it)
            return
        }
        if (paymentId == null || resourceToken == null) {
            promise?.resolve(
                createProcessorFailureResult(ProcessorResult.FailureReason.ProcessorContextNotAvailable, ProcessorResult.ResultShown.None)
            )
            return
        }
        val bundle = Bundle()
        bundle.putBoolean("react-native", true)
        bundle.putString("react-native-sdk-version", BuildConfig.RN_TL_SDK_VERSION)

        scope.launch(Dispatchers.IO) {
            TrueLayerUI.getPaymentStatus(
                paymentId,
                resourceToken,
                bundle
            )
                .onOk {
                    val paymentStatusResult = WritableNativeMap().apply {
                        putString("type", "Success")
                        putString("status", mapPaymentStatus(it))
                        putString("resultShown", mapPaymentResultShown(ProcessorResult.ResultShown.None))
                    }

                    promise?.resolve(paymentStatusResult)
                }
                .onError {
                    promise?.resolve(createStatusFailure(it))
                }
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
                    result.concatenate(TLReactNativeUtils.createProcessorSuccessResult(sdkResult.step, sdkResult.resultShown))
                }
                is ProcessorResult.Failure -> {
                    result.concatenate(createProcessorFailureResult(sdkResult.reason, sdkResult.resultShown))
                }
                null -> { } // just ignore
            }

            promise.resolve(result)
        }
    }
}
