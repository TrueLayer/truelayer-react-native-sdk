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
  NSError *error = [self errorWithDescriptionKey:@"Invalid environment value passed."
                            failureReasonErrorKey:@"The environment value passed does not match any expected cases."
                       recoverySuggestionErrorKey:@"Please use either `sandbox` or `production`."
                                             code:1];

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
  // Check that all the context values exist. Else, reject the promise.
  if (paymentContext.paymentId() == nil || paymentContext.resourceToken() == nil || paymentContext.redirectUri() == nil) {
    NSError *error = [self errorWithDescriptionKey:@"Payment context value is nil."
                             failureReasonErrorKey:@"The payment ID, resource token, or redirect URI passed is nil."
                        recoverySuggestionErrorKey:@"Please pass a valid, non-nil payment ID, resource token, or redirect URI."
                                              code:2];

    reject([@(error.code) stringValue], error.localizedDescription, error);

    return;
  }
  
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
  // Check that the paymentId and resourceToken values are non-nil.
  if (paymentId == nil || resourceToken == nil) {
    NSError *error = [self errorWithDescriptionKey:@"Payment ID or resource token is nil."
                             failureReasonErrorKey:@"The payment ID or resource token is nil."
                        recoverySuggestionErrorKey:@"Please pass a valid, non-nil payment ID and resource token"
                                              code:3];

    reject([@(error.code) stringValue], error.localizedDescription, error);

    return;
  }

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
  // Check that all the context values exist. Else, reject the promise.
  if (mandateContext.mandateId() == nil || mandateContext.resourceToken() == nil || mandateContext.redirectUri() == nil) {
    NSError *error = [self errorWithDescriptionKey:@"Mandate context value is nil."
                             failureReasonErrorKey:@"The mandate ID, resource token, or redirect URI passed is nil."
                        recoverySuggestionErrorKey:@"Please pass a valid, non-nil mandate ID, resource token, or redirect URI."
                                              code:4];

    reject([@(error.code) stringValue], error.localizedDescription, error);

    return;
  }

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
  // Check that the mandateId and resourceToken values are non-nil.
  if (mandateId == nil || resourceToken == nil) {
    NSError *error = [self errorWithDescriptionKey:@"Mandate ID or resource token is nil."
                             failureReasonErrorKey:@"The mandate ID or resource token is nil."
                        recoverySuggestionErrorKey:@"Please pass a valid, non-nil mandate ID and resource token"
                                              code:5];

    reject([@(error.code) stringValue], error.localizedDescription, error);

    return;
  }

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

// MARK: - Helpers

/// Creates an `NSError` with the domain `TrueLayerPaymentsSDK.TrueLayerObjectiveCError` and a given description, failure reason, recovery suggestion, and code.
/// - Parameters:
///   - descriptionKey: The corresponding value is a localized string representation of the error that, if present, will be returned by localizedDescription.
///   - failureReasonErrorKey: The corresponding value is a localized string representation containing the reason for the failure that, if present, will be returned by localizedFailureReason.
///   - recoverySuggestionErrorKey: The corresponding value is a string containing the localized recovery suggestion for the error.
///   - code: The unique code for the error.
-(NSError *)errorWithDescriptionKey:(NSString *)descriptionKey
              failureReasonErrorKey:(NSString *)failureReasonErrorKey
         recoverySuggestionErrorKey:(NSString *)recoverySuggestionErrorKey
                               code:(NSInteger)code
{
    NSDictionary *userInfo = @{
       NSLocalizedDescriptionKey: descriptionKey,
       NSLocalizedFailureReasonErrorKey: failureReasonErrorKey,
       NSLocalizedRecoverySuggestionErrorKey: recoverySuggestionErrorKey
    };

    return [
     NSError errorWithDomain:@"TrueLayerPaymentsSDK.TrueLayerObjectiveCError"
     code:code
     userInfo:userInfo
   ];
}

@end