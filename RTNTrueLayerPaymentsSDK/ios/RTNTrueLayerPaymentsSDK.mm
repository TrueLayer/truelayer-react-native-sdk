#import "RTNTrueLayerPaymentsSDKSpec.h"
#import "RTNTrueLayerPaymentsSDK.h"

@implementation RTNTrueLayerPaymentsSDK

RCT_EXPORT_MODULE()

- (void)_configure:(NSString *)environment
           resolve:(RCTPromiseResolveBlock)resolve
            reject:(RCTPromiseRejectBlock)reject
{
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