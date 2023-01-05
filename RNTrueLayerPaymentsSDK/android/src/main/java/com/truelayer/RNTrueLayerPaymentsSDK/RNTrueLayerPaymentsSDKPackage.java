package com.truelayer.RNTrueLayerPaymentsSDK;

import androidx.annotation.Nullable;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.module.model.ReactModuleInfo;
import com.facebook.react.module.model.ReactModuleInfoProvider;
import com.facebook.react.TurboReactPackage;
import java.util.HashMap;
import java.util.Map;

public class RNTrueLayerPaymentsSDKPackage extends TurboReactPackage {

  @Nullable
  @Override
  public NativeModule getModule(String name, ReactApplicationContext reactContext) {
      return new TlPaymentSdkModule(reactContext);
  }

  @Override
  public ReactModuleInfoProvider getReactModuleInfoProvider() {
      return () -> {
          final Map<String, ReactModuleInfo> moduleInfo = new HashMap<>();
          moduleInfo.put(
                  TlPaymentSdkModule.NAME,
            new ReactModuleInfo(
                    TlPaymentSdkModule.NAME,
                    TlPaymentSdkModule.NAME,
                    false, // canOverrideExistingModule
                    false, // needsEagerInit
                    true, // hasConstants
                    false, // isCxxModule
                    true // isTurboModule
            )
          );
          return moduleInfo;
      };
  }
}

