package com.truelayerreactnativesdk

import android.app.Activity
import android.content.Intent
import android.util.Log
import android.util.SparseArray
import com.facebook.react.bridge.ActivityEventListener
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeMap
import com.truelayer.payments.core.domain.configuration.Environment
import com.truelayer.payments.ui.TrueLayerUI
import com.truelayer.payments.ui.models.PaymentContext
import com.truelayer.payments.ui.screens.coordinator.FlowCoordinatorActivityContract
import com.truelayer.payments.ui.screens.coordinator.FlowCoordinatorResult
import javax.annotation.Nullable

class TruelayerReactNativeSdkModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext), ActivityEventListener {

    private val TAG = "TruelayerReactNativeSdkModule"
  
    val mPromises: SparseArray<Promise>

    override fun getName(): String {
        return "TruelayerReactNativeSdk"
    }

    @Nullable
  override fun getConstants(): Map<String, Any>? {
    val constants: HashMap<String, Any> = HashMap()
    constants["OK"] = Activity.RESULT_OK
    constants["CANCELED"] = Activity.RESULT_CANCELED
    return constants
  }

  override fun initialize() {
    super.initialize()
    reactApplicationContext.addActivityEventListener(this)
    // we ignore the outcome in here for now
    TrueLayerUI.init(reactApplicationContext) {
      environment = Environment.DEVELOPMENT
    }
  }

  /**
   data class PaymentContext(
    val paymentId: String,
    val resourceToken: String,
    val redirectUri: String,
    val preferences: Preferences? = null
   )
   */

  @ReactMethod
  fun startPayment(
    paymentId: String,
    resourceToken: String,
    redirectUri: String,
    preferences: ReadableMap?,
    promise: Promise
  ) {
    val activity = reactApplicationContext.currentActivity
    val prefs = preferences?.let {
      val countryCode: String? = it.getString("preferredCountryCode")
      PaymentContext.Preferences(
        preferredCountryCode = countryCode
      )
    }

    activity?.let {
      val intent = FlowCoordinatorActivityContract().createIntent(
        it,
        PaymentContext(paymentId, resourceToken, redirectUri, prefs)
      )
      it.startActivityForResult(intent, 0)
    }
    mPromises.put(0, promise)
  }

  override fun onCatalystInstanceDestroy() {
    super.onCatalystInstanceDestroy()
    reactApplicationContext.removeActivityEventListener(this)
  }

  @ReactMethod
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
      val sdkResult = FlowCoordinatorResult.unwrapResult(data!!)

      var map = WritableNativeMap()
      when (sdkResult) {
        is FlowCoordinatorResult.Successful -> {
          Log.e(TAG, "sdkResult: success ${sdkResult.step}")
          map.putString("result", "success")
          map.putString("step", sdkResult.step.name)
        }
        is FlowCoordinatorResult.Failure -> {
          Log.e(TAG, "sdkResult: failure ${sdkResult.reason}")
          map.putString("result", "failure")
          map.putString("reason", sdkResult.reason.name)
        }
        null -> map = Arguments.makeNativeMap(data!!.extras)
      }
//      result.putMap("data", Arguments.makeNativeMap(data.extras))
      result.putMap("data", map)
      promise.resolve(result)
    }
  }

  override fun onNewIntent(intent: Intent) {
    /* Do nothing */
  }

  init {
    mPromises = SparseArray()
  }

}
