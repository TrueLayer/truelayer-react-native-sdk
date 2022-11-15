package com.truelayer.RTNTrueLayerPaymentsSDK;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.module.model.ReactModuleInfo;
import com.facebook.react.module.model.ReactModuleInfoProvider;
import com.facebook.react.TurboReactPackage;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RTNTrueLayerPaymentsSDKPackage extends TurboReactPackage {

  @Nullable
  @Override
  public NativeModule getModule(String name, ReactApplicationContext reactContext) {
      return new TlPaymentSdkModule2(reactContext);
  }

  @Override
  public ReactModuleInfoProvider getReactModuleInfoProvider() {
      return () -> {
          final Map<String, ReactModuleInfo> moduleInfos = new HashMap<>();
          moduleInfos.put(
                  TlPaymentSdkModule.getNAME(),
            new ReactModuleInfo(
                    TlPaymentSdkModule.getNAME(),
                    TlPaymentSdkModule.getNAME(),
                    false, // canOverrideExistingModule
                    false, // needsEagerInit
                    true, // hasConstants
                    false, // isCxxModule
                    true // isTurboModule
            )
          );
          return moduleInfos;
      };
  }
}

