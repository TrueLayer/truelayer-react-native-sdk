#import <React/RCTUtils.h>
#import "RNTrueLayerPaymentsSDK.h"
#import "RNTrueLayerHelpers.h"
#import <TrueLayerObjectiveC/TrueLayerObjectiveC-Swift.h>

@implementation RNTrueLayerPaymentsSDK

RCT_EXPORT_MODULE()

- (void)_configure:(NSString *)environment
           resolve:(RCTPromiseResolveBlock)resolve
            reject:(RCTPromiseRejectBlock)reject
{
 // The Objective-C environment to convert the `NSString` `environment` value to,
 // so it can be passed to the Objective-C bridge of the TrueLayer SDK.
 TrueLayerEnvironment sdkEnvironment;

 if (environment && [environment caseInsensitiveCompare:@"sandbox"] == NSOrderedSame) {
   sdkEnvironment = TrueLayerEnvironmentSandbox;
 } else if (environment && [environment caseInsensitiveCompare:@"production"] == NSOrderedSame) {
   sdkEnvironment = TrueLayerEnvironmentProduction;
 } else {
   // Create an NSError object for the configuration error.
   NSDictionary *userInfo = @{
      NSLocalizedDescriptionKey: @"Invalid environment value passed.",
      NSLocalizedFailureReasonErrorKey: @"The environment value passed does not match any expected cases.",
      NSLocalizedRecoverySuggestionErrorKey: @"Please use either `sandbox` or `production`."
   };

   NSError *error = [
    NSError errorWithDomain:@"TrueLayerPaymentsSDK.TrueLayerObjectiveCError"
    code:1
    userInfo:userInfo
  ];

   reject([@(error.code) stringValue], error.localizedDescription, error);

   return;
 }

 [TrueLayerPaymentsManager
  configureWithEnvironment:sdkEnvironment
  additionalConfiguration:[NSDictionary dictionaryWithObjectsAndKeys:@"react-native", @"customIntegrationType", nil]
 ];

 resolve(NULL);
}

- (void)_processPayment:(JS::NativeTrueLayerPaymentsSDK::Spec_processPaymentPaymentContext &)paymentContext preferences:(JS::NativeTrueLayerPaymentsSDK::Spec_processPaymentPreferences &)preferences resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  NSString *paymentID = [NSString stringWithString:paymentContext.paymentId()];
  NSString *resourceToken = [NSString stringWithString:paymentContext.resourceToken()];
  NSString *redirectURI = [NSString stringWithString:paymentContext.redirectUri()];
  NSString *preferredCountryCode;
  if (preferences.preferredCountryCode()) {
    // Only set the preferred country code if it is not `nil`, as `[NSString stringWithString:]` requires the parameter to be non-nil.
    preferredCountryCode = [NSString stringWithString:preferences.preferredCountryCode()];
  }

  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    // Capture the presented view controller.
    // We use the main thread here as `RCTPresentedViewController.init` accesses the main application window.
    UIViewController *reactViewController = RCTPresentedViewController();

    // Create the context required by the ObjC bridge in TrueLayerSDK.
    TrueLayerSinglePaymentPreferences *trueLayerPreferences = [[
      TrueLayerSinglePaymentPreferences alloc]
      initWithPresentationStyle:[[TrueLayerPresentationStyle alloc] initWithPresentOn:reactViewController style:UIModalPresentationAutomatic]
      preferredCountryCode:preferredCountryCode
    ];

    TrueLayerSinglePaymentContext *context = [
      [TrueLayerSinglePaymentContext alloc] 
      initWithIdentifier:paymentID
      token:resourceToken
      redirectURL:[NSURL URLWithString:redirectURI]
      preferences:trueLayerPreferences
    ];

    [TrueLayerPaymentsManager processSinglePaymentWithContext:context success:^(TrueLayerSinglePaymentState state) {
      // Create a `step` value to return to React Native, that is equal to the typescript `ProcessorStep` enum.
      // See `types.ts` for the raw values to match.
      NSString *step = [RNTrueLayerHelpers stepFromSinglePaymentState:state];

       NSDictionary *result = @{
         @"type": @"Success",
         @"step": step
       };

       resolve(result);
    } failure:^(TrueLayerSinglePaymentError error) {
      // Create a `reason` value to return to React Native, that is equal to the typescript `FailureReason` enum.
      // See `types.ts` for the raw values to match.
      NSString *reason = [RNTrueLayerHelpers reasonFromSinglePaymentError:error];
      
      NSDictionary *result = @{
        @"type": @"Failure",
        @"reason": reason
      };

      resolve(result);
    }];
  }];
}


- (void)_paymentStatus:(NSString *)paymentId resourceToken:(NSString *)resourceToken resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  // Create a copied strong reference to the context information.
  NSString *paymentIDCopy = [NSString stringWithString:paymentId];
  NSString *resourceTokenCopy = [NSString stringWithString:resourceToken];
  
  [TrueLayerPaymentsManager
   singlePaymentStatusWithPaymentIdentifier:paymentIDCopy
   resourceToken:resourceTokenCopy
   success:^(enum TrueLayerSinglePaymentStatus status) {
    NSString *finalStatus = [RNTrueLayerHelpers statusFromSinglePaymentStatus:status];
    
    NSDictionary *result = @{
      @"type": @"Success",
      @"status": finalStatus
    };
    
    resolve(result);
  }
  failure:^(enum TrueLayerSinglePaymentError error) {
    // Create a `reason` value to return to React Native, that is equal to the typescript `FailureReason` enum.
    // See `types.ts` for the raw values to match.
    NSString *reason = [RNTrueLayerHelpers reasonFromSinglePaymentError:error];

    NSDictionary *result = @{
      @"type": @"Failure",
      @"reason": reason
    };

    resolve(result);
  }];
}

- (void)_processMandate:(JS::NativeTrueLayerPaymentsSDK::Spec_processMandateMandateContext &)mandateContext preferences:(JS::NativeTrueLayerPaymentsSDK::Spec_processMandatePreferences &)preferences resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  // Create a copied strong reference to the context information.
  NSString *mandateID = [NSString stringWithString:mandateContext.mandateId()];
  NSString *resourceToken = [NSString stringWithString:mandateContext.resourceToken()];
  NSString *redirectURI = [NSString stringWithString:mandateContext.redirectUri()];
  
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    // Capture the presented view controller.
    // We use the main thread here as `RCTPresentedViewController.init` accesses the main application window.
    UIViewController *reactViewController = RCTPresentedViewController();
    
    // Create the context required by the ObjC bridge in TrueLayerSDK.
    TrueLayerMandatePreferences *preferences = [
      [TrueLayerMandatePreferences alloc] initWithPresentationStyle:[[TrueLayerPresentationStyle alloc] initWithPresentOn:reactViewController style:UIModalPresentationAutomatic]
    ];
    
    TrueLayerMandateContext *context = [
      [TrueLayerMandateContext alloc] initWithIdentifier:mandateID
      token:resourceToken
      redirectURL:[NSURL URLWithString:redirectURI]
      preferences:preferences
    ];
    
    // Call the ObjC bridge.
    [TrueLayerPaymentsManager
     processMandateWithContext:context
     success:^(TrueLayerMandateState state) {
      // Create a `step` value to return to React Native, that is equal to the typescript `ProcessorStep` enum.
      // See `types.ts` for the raw values to match.
      NSString *step = [RNTrueLayerHelpers stepFromMandateState:state];
      
      NSDictionary *result = @{
        @"type": @"Success",
        @"step": step
      };
      
      resolve(result);
    }
    failure:^(TrueLayerMandateError error) {
      // Create a `reason` value to return to React Native, that is equal to the typescript `FailureReason` enum.
      // See `types.ts` for the raw values to match.
      NSString *reason = [RNTrueLayerHelpers reasonFromMandateError:error];
      
      NSDictionary *result = @{
        @"type": @"Failure",
        @"reason": reason
      };
      
      resolve(result);
    }];
  }];
}

- (void)_mandateStatus:(NSString *)mandateId resourceToken:(NSString *)resourceToken resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  // Create a copied strong reference to the context information.
  NSString *mandateIDCopy = [NSString stringWithString:mandateId];
  NSString *resourceTokenCopy = [NSString stringWithString:resourceToken];
  
  [TrueLayerPaymentsManager
   mandateStatusWithMandateIdentifier:mandateIDCopy
   resourceToken:resourceTokenCopy
  success:^(enum TrueLayerMandateStatus status) {
    NSString *finalStatus = [RNTrueLayerHelpers statusFromMandateStatus:status];
    
    NSDictionary *result = @{
      @"type": @"Success",
      @"status": finalStatus
    };
    
    resolve(result);
  }
  failure:^(enum TrueLayerMandateError error) {
    // Create a `reason` value to return to React Native, that is equal to the typescript `FailureReason` enum.
    // See `types.ts` for the raw values to match.
    NSString *reason = [RNTrueLayerHelpers reasonFromMandateError:error];
    
    NSDictionary *result = @{
      @"type": @"Failure",
      @"reason": reason
    };
    
    resolve(result);
  }];
}

 - (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
     (const facebook::react::ObjCTurboModule::InitParams &)params
 {
     return std::make_shared<facebook::react::NativeTrueLayerPaymentsSDKSpecJSI>(params);
 }

@end