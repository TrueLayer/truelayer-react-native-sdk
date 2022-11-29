#import "RTNTrueLayerPaymentsSDKSpec.h"
#import "RTNTrueLayerPaymentsSDK.h"
#import <TrueLayerPaymentsSDK/TrueLayerPaymentsSDK-umbrella.h>
#import <React/RCTUtils.h>
#import "RTNTrueLayerHelpers.h"

@implementation RTNTrueLayerPaymentsSDK

RCT_EXPORT_MODULE()

- (void)_configure:(NSString *)environment
           resolve:(RCTPromiseResolveBlock)resolve
            reject:(RCTPromiseRejectBlock)reject
{
  // A pointer to an error in case the `configure` method is called with an invalid environment.
  NSError *error;
  [TrueLayerObjectiveCBridge configureWith:environment error:&error];
  
  if (error) {
    NSDictionary *result = @{
      @"type": @"Failure",
      @"reason": @"ProcessorContextNotAvailable"
    };
    
    resolve(result);
  } else {
    resolve(@{});
  }
}

- (void)_processPayment:(JS::NativeTrueLayerPaymentsSDK::Spec_processPaymentPaymentContext &)paymentContext
             prefereces:(JS::NativeTrueLayerPaymentsSDK::Spec_processPaymentPrefereces &)prefereces
                resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject {
  // Create a copied strong reference to the context information.
  NSString *paymentID = [NSString stringWithString:paymentContext.paymentId()];
  NSString *resourceToken = [NSString stringWithString:paymentContext.resourceToken()];
  NSString *redirectURI = [NSString stringWithString:paymentContext.redirectUri()];
  
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    // Capture the presented view controller.
    // We use the main thread here as `RCTPresentedViewController.init` accesses the main application window.
    UIViewController *reactViewController = RCTPresentedViewController();
    
    // Create the context required by the ObjC bridge in TrueLayerSDK.
    TrueLayerSinglePaymentContext *context = [[TrueLayerSinglePaymentContext alloc] initWithPaymentID:paymentID
                                                                                        resourceToken:resourceToken
                                                                                          redirectURL:[NSURL URLWithString:redirectURI]
                                                                                       viewController:reactViewController];
    
    // Call the ObjC bridge.
    [TrueLayerObjectiveCBridge processSinglePaymentWithContext:context success:^(TrueLayerSinglePaymentObjCState state) {
      // Create a `step` value to return to React Native, that is equal to the typescript `ProcessorStep` enum.
      // See `types.ts` for the raw values to match.
      NSString *step = [RTNTrueLayerHelpers stepFrom:state];
      
      NSDictionary *result = @{
        @"type": @"Success",
        @"step": step
      };
      
      resolve(result);
      
    } failure:^(TrueLayerSinglePaymentObjCError error) {
      // Create a `reason` value to return to React Native, that is equal to the typescript `FailureReason` enum.
      // See `types.ts` for the raw values to match.
      NSString *reason = [RTNTrueLayerHelpers reasonFrom:error];
            
      NSDictionary *result = @{
        @"type": @"Failure",
        @"reason": reason
      };
      
      resolve(result);
    }];
  }];
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
