package com.truelayer.RTNTrueLayerPaymentsSDK;

import android.util.Log;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.truelayerpayments.NativeTrueLayerPaymentsSDKSpec;

public class TlPaymentSdkModule2 extends NativeTrueLayerPaymentsSDKSpec {

    public TlPaymentSdkModule2(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @NonNull
    @Override
    public String getName() {
        return "RTNTrueLayerPaymentsSDK";
    }

    public String configureSDK() {
        Log.e("TEST", "TlPaymentSdkModule2 configureSDK()");
        return "configuration successfull";
    }
}
