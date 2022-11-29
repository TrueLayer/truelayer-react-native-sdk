#import "RTNTrueLayerPaymentsSDKSpec.h"
#import "RTNTrueLayerPaymentsSDK.h"
#import <TrueLayerPaymentsSDK/TrueLayerPaymentsSDK-umbrella.h>
#import <React/RCTUtils.h>

@implementation RTNTrueLayerPaymentsSDK

RCT_EXPORT_MODULE()

- (void)_configure:(NSString *)environment
           resolve:(RCTPromiseResolveBlock)resolve
            reject:(RCTPromiseRejectBlock)reject
{
  // The Objective-C environment to convert the `NSString` `environment` value to,
  // so it can be passed to the Objective-C bridge of the TrueLayer SDK.
  TrueLayerObjectiveCEnvironment objCEnvironment;

  if (environment && [environment caseInsensitiveCompare:@"sandbox"] == NSOrderedSame) {
    objCEnvironment = TrueLayerObjectiveCEnvironmentSandbox;
  } else if (environment && [environment caseInsensitiveCompare:@"production"] == NSOrderedSame) {
    objCEnvironment = TrueLayerObjectiveCEnvironmentProduction;
  } else {
    // Create an NSError object for the configuration error.
    NSDictionary *userInfo = @{
       NSLocalizedDescriptionKey: @"Invalid environment value passed.",
       NSLocalizedFailureReasonErrorKey: @"The environment value passed does not match any expected cases.",
       NSLocalizedRecoverySuggestionErrorKey: @"Please use either `sandbox` or `production`."
    };
    
    NSError *error = [NSError errorWithDomain:@"TrueLayerPaymentsSDK.TrueLayerObjectiveCError"
                                         code:1
                                     userInfo:userInfo];

    reject([@(error.code) stringValue], error.localizedDescription, error);

    return;
  }
  
  [TrueLayerObjectiveCBridge configureWith:objCEnvironment];
  resolve(NULL);
}

- (void)_processPayment:(JS::NativeTrueLayerPaymentsSDK::Spec_processPaymentPaymentContext &)paymentContext
             prefereces:(JS::NativeTrueLayerPaymentsSDK::Spec_processPaymentPrefereces &)prefereces
                resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject {
  resolve(NULL);
}
- (void)_processMandate:(JS::NativeTrueLayerPaymentsSDK::Spec_processMandateMandateContext &)mandateContext
             prefereces:(JS::NativeTrueLayerPaymentsSDK::Spec_processMandatePrefereces &)prefereces
                resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject {
  resolve(NULL);
}
- (void)_paymentStatus:(NSString *)paymentId
         resourceToken:(NSString *)resourceToken
               resolve:(RCTPromiseResolveBlock)resolve
                reject:(RCTPromiseRejectBlock)reject {
  resolve(NULL);
  
}
- (void)_mandateStatus:(NSString *)mandateId
         resourceToken:(NSString *)resourceToken
               resolve:(RCTPromiseResolveBlock)resolve
                reject:(RCTPromiseRejectBlock)reject {
  resolve(NULL);
  
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeTrueLayerPaymentsSDKSpecJSI>(params);
}

@end