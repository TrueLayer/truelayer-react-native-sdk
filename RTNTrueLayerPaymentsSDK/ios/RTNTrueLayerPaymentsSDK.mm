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
  // Create a copied strong reference to the context information.
  NSString *paymentID = [NSString stringWithString:paymentContext.paymentId()];
  NSString *resourceToken = [NSString stringWithString:paymentContext.resourceToken()];
  NSString *redirectURI = [NSString stringWithString:paymentContext.redirectUri()];
  NSString *preferredCountryCode;
  if (prefereces.preferredCountryCode()) {
    // Only set the preferred country code if it is not `nil`, as `[NSString stringWithString:]` requires the parameter to be non-nil.
    preferredCountryCode = [NSString stringWithString:prefereces.preferredCountryCode()];
  }
 
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    // Capture the presented view controller.
    // We use the main thread here as `RCTPresentedViewController.init` accesses the main application window.
    UIViewController *reactViewController = RCTPresentedViewController();
    
    // Create the context required by the ObjC bridge in TrueLayerSDK.
    TrueLayerSinglePaymentPreferences *trueLayerPreferences = [[TrueLayerSinglePaymentPreferences alloc] initWithPreferredCountryCode:preferredCountryCode
                                                                                                                       viewController:reactViewController];
    TrueLayerSinglePaymentContext *context = [[TrueLayerSinglePaymentContext alloc] initWithIdentifier:paymentID
                                                                                        resourceToken:resourceToken
                                                                                          redirectURL:[NSURL URLWithString:redirectURI]
                                                                                       preferences:trueLayerPreferences];
    
    // Call the ObjC bridge.
    [TrueLayerObjectiveCBridge processSinglePaymentWithContext:context success:^(TrueLayerSinglePaymentObjCState state) {
      // Create a `step` value to return to React Native, that is equal to the typescript `ProcessorStep` enum.
      // See `types.ts` for the raw values to match.
      NSString *step = [RTNTrueLayerHelpers stepFromSinglePaymentObjCState:state];
      
      NSDictionary *result = @{
        @"type": @"Success",
        @"step": step
      };
      
      resolve(result);
      
    } failure:^(TrueLayerSinglePaymentObjCError error) {
      // Create a `reason` value to return to React Native, that is equal to the typescript `FailureReason` enum.
      // See `types.ts` for the raw values to match.
      NSString *reason = [RTNTrueLayerHelpers reasonFromSinglePaymentObjCError:error];
            
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
  // Create a copied strong reference to the context information.
  NSString *mandateID = [NSString stringWithString:mandateContext.mandateId()];
  NSString *resourceToken = [NSString stringWithString:mandateContext.resourceToken()];
  NSString *redirectURI = [NSString stringWithString:mandateContext.redirectUri()];
  
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    // Capture the presented view controller.
    // We use the main thread here as `RCTPresentedViewController.init` accesses the main application window.
    UIViewController *reactViewController = RCTPresentedViewController();
    
    // Create the context required by the ObjC bridge in TrueLayerSDK.
    TrueLayerMandatePreferences *objCPreferences = [[TrueLayerMandatePreferences alloc] initWithViewController:reactViewController];
    TrueLayerMandateContext *context = [[TrueLayerMandateContext alloc] initWithMandateID:mandateID
                                                                                        resourceToken:resourceToken
                                                                                          redirectURL:[NSURL URLWithString:redirectURI]
                                                                                       preferences:objCPreferences];
    
    // Call the ObjC bridge.
    [TrueLayerObjectiveCBridge processMandateWithContext:context
                                                 success:^(TrueLayerMandateObjCState state) {
      // Create a `step` value to return to React Native, that is equal to the typescript `ProcessorStep` enum.
      // See `types.ts` for the raw values to match.
      NSString *step = [RTNTrueLayerHelpers stepFromMandateObjCState:state];
      
      NSDictionary *result = @{
        @"type": @"Success",
        @"step": step
      };
      
      resolve(result);
      
    }
                                                 failure:^(TrueLayerMandateObjCError error) {
      // Create a `reason` value to return to React Native, that is equal to the typescript `FailureReason` enum.
      // See `types.ts` for the raw values to match.
      NSString *reason = [RTNTrueLayerHelpers reasonFromMandateObjCError:error];
            
      NSDictionary *result = @{
        @"type": @"Failure",
        @"reason": reason
      };
      
      resolve(result);
    }];
  }];
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
