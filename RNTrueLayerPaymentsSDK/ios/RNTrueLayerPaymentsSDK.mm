#import <React/RCTUtils.h>
#import "RNTrueLayerPaymentsSDK.h"
#import "RNTrueLayerHelpers.h"
#import <TrueLayerObjectiveC/TrueLayerObjectiveC-Swift.h>

@implementation RNTrueLayerPaymentsSDK

RCT_EXPORT_MODULE()

#ifdef RCT_NEW_ARCH_ENABLED
- (void)_configure:(NSString *)environment
             theme:(JS::NativeTrueLayerPaymentsSDK::Spec_configureTheme &)theme
           resolve:(RCTPromiseResolveBlock)resolve
            reject:(RCTPromiseRejectBlock)reject
{
  TrueLayerVisualSettings *visualSettings = [self setupVisualSettingsFromTheme: theme];
  [self configureWithEnvironment:environment
                  visualSettings:visualSettings
                         resolve:resolve
                          reject:reject];
}
#else
RCT_EXPORT_METHOD(_configure:(NSString *)environment
                  theme:(NSDictionary *)theme
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
  TrueLayerVisualSettings *visualSettings = [self setupVisualSettingsFromDictionary: theme];
  
  [self configureWithEnvironment:environment
                  visualSettings:visualSettings
                         resolve:resolve
                          reject:reject];
}
#endif

// MARK: Process Payment

#ifdef RCT_NEW_ARCH_ENABLED
- (void)_processPayment:(JS::NativeTrueLayerPaymentsSDK::Spec_processPaymentPaymentContext &)paymentContext
            preferences:(JS::NativeTrueLayerPaymentsSDK::Spec_processPaymentPreferences &)preferences
                resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject
{
  bool shouldShowResultScreen = preferences.shouldPresentResultScreen().value_or(true);
  NSNumber * _Nullable waitTimeMillis = nil;
  
  if (preferences.waitTimeMillis().has_value()) {
    waitTimeMillis = [NSNumber numberWithDouble:preferences.waitTimeMillis().value()];
  }
  
  [self executeProcessPayment:paymentContext.paymentId()
                resourceToken:paymentContext.resourceToken()
                  redirectURI:paymentContext.redirectUri()
         preferredCountryCode:preferences.preferredCountryCode()
       shouldShowResultScreen:shouldShowResultScreen
               waitTimeMillis:waitTimeMillis
                      resolve:resolve
                       reject:reject];
}
#else
RCT_EXPORT_METHOD(_processPayment:(NSDictionary *)paymentContext
                  preferences:(NSDictionary *)preferences
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
  [self executeProcessPayment:paymentContext[@"paymentId"]
                resourceToken:paymentContext[@"resourceToken"]
                  redirectURI:paymentContext[@"redirectUri"]
         preferredCountryCode:preferences[@"preferredCountryCode"]
       shouldShowResultScreen:preferences[@"shouldPresentResultScreen"]
               waitTimeMillis:preferences[@"waitTimeMillis"]
                      resolve:resolve
                       reject:reject];
}
#endif

// MARK: Payment Status

RCT_EXPORT_METHOD(_paymentStatus:(NSString *)paymentId
                  resourceToken:(NSString *)resourceToken
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
  // Check that the paymentId and resourceToken values are non-nil.
  if (paymentId == nil || resourceToken == nil) {
    NSError *error = [self errorWithDescriptionKey:@"Payment ID or resource token is nil."
                             failureReasonErrorKey:@"The payment ID or resource token is nil."
                        recoverySuggestionErrorKey:@"Please pass a valid, non-nil payment ID and resource token."
                                              code:3];
    
    reject([@(error.code) stringValue], error.localizedDescription, error);
    return;
  }
  
  // Create a copied strong reference to the context information.
  NSString *paymentIDCopy = [NSString stringWithString:paymentId];
  NSString *resourceTokenCopy = [NSString stringWithString:resourceToken];
  
  [TrueLayerPaymentsManager singlePaymentStatusWithPaymentIdentifier:paymentIDCopy
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

// MARK: Process Mandate

#ifdef RCT_NEW_ARCH_ENABLED
- (void)_processMandate:(JS::NativeTrueLayerPaymentsSDK::Spec_processMandateMandateContext &)mandateContext
            preferences:(JS::NativeTrueLayerPaymentsSDK::Spec_processMandatePreferences &)preferences
                resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject
{
  bool shouldShowResultScreen = preferences.shouldPresentResultScreen().value_or(true);
  NSNumber * _Nullable waitTimeMillis = nil;
  
  if (preferences.waitTimeMillis().has_value()) {
    waitTimeMillis = [NSNumber numberWithDouble:preferences.waitTimeMillis().value()];
  }
  
  [self executeProcessMandate:mandateContext.mandateId()
                resourceToken:mandateContext.resourceToken()
                  redirectURI:mandateContext.redirectUri()
       shouldShowResultScreen:shouldShowResultScreen
               waitTimeMillis:waitTimeMillis
                      resolve:resolve
                       reject:reject];
}
#else
RCT_EXPORT_METHOD(_processMandate:(NSDictionary *)paymentContext
                  preferences:(NSDictionary *)preferences
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
  [self executeProcessMandate:paymentContext[@"mandateId"]
                resourceToken:paymentContext[@"resourceToken"]
                  redirectURI:paymentContext[@"redirectUri"]
       shouldShowResultScreen:preferences[@"shouldPresentResultScreen"]
               waitTimeMillis:preferences[@"waitTimeMillis"]
                      resolve:resolve
                       reject:reject];
}
#endif

// MARK: Mandate Status

RCT_EXPORT_METHOD(_mandateStatus:(NSString *)mandateId
                  resourceToken:(NSString *)resourceToken
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
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
  
  [TrueLayerPaymentsManager mandateStatusWithMandateIdentifier:mandateIDCopy
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

// MARK: - Helpers

-(void)configureWithEnvironment:(NSString *)environment
                 visualSettings:(TrueLayerVisualSettings *)visualSettings
                        resolve:(RCTPromiseResolveBlock)resolve
                         reject:(RCTPromiseRejectBlock)reject {
  // The Objective-C environment to convert the `NSString` `environment` value to,
  // so it can be passed to the Objective-C bridge of the TrueLayer SDK.
  TrueLayerEnvironment sdkEnvironment;
  
  if (visualSettings == NULL) {
    // Create an NSError object for the configuration error.
    NSError *error = [self errorWithDescriptionKey:@"Invalid HEX color."
                             failureReasonErrorKey:@"One of the passed colors is invalid."
                        recoverySuggestionErrorKey:@"Make sure it's a valid HEX color."
                                              code:2];
    
    reject([@(error.code) stringValue], error.localizedDescription, error);
    return;
  }
  
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
  
  NSDictionary *additionalConfiguration = @{
    @"customIntegrationType": @"React Native",
    @"customIntegrationVersion": @"2.1.0"
  };
  
  [TrueLayerPaymentsManager configureWithEnvironment:sdkEnvironment
                                      visualSettings:visualSettings
                             additionalConfiguration:additionalConfiguration
                                   completionHandler:^{
    resolve(NULL);
  }];
}

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
  
  return [NSError errorWithDomain:@"TrueLayerPaymentsSDK.TrueLayerObjectiveCError"
                             code:code
                         userInfo:userInfo];
}

-(void)executeProcessPayment:(NSString *)paymentId
               resourceToken:(NSString *)resourceToken
                 redirectURI:(NSString *)redirectURI
        preferredCountryCode:(nullable NSString *)preferredCountryCode
      shouldShowResultScreen:(bool)shouldShowResultScreen
              waitTimeMillis:(NSNumber  * _Nullable)waitTimeMillis
                     resolve:(RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
{
  // Check that all the context values exist. Else, reject the promise.
  if (paymentId == nil || resourceToken == nil || redirectURI == nil) {
    NSError *error = [self errorWithDescriptionKey:@"A value in the payment context is nil."
                             failureReasonErrorKey:@"The payment ID, resource token, or redirect URI passed is nil."
                        recoverySuggestionErrorKey:@"Please pass a valid, non-nil payment ID, resource token, and redirect URI."
                                              code:2];
    
    reject([@(error.code) stringValue], error.localizedDescription, error);
    return;
  }
  
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    // Capture the presented view controller.
    // We use the main thread here as `RCTPresentedViewController.init` accesses the main application window.
    UIViewController *reactViewController = RCTPresentedViewController();
    
    // Create the context required by the ObjC bridge in TrueLayerSDK.
    TrueLayerPresentationStyle *presentationStyle = [[TrueLayerPresentationStyle alloc] initWithPresentOn:reactViewController
                                                                                                    style:UIModalPresentationAutomatic];
    TrueLayerSinglePaymentPreferences *trueLayerPreferences = [[TrueLayerSinglePaymentPreferences alloc] initWithPresentationStyle:presentationStyle
                                                                                                              preferredCountryCode:preferredCountryCode
                                                                                                            shouldShowResultScreen:shouldShowResultScreen
                                                                                                        maximumResultScreenTimeout: waitTimeMillis];
    TrueLayerSinglePaymentContext *context = [[TrueLayerSinglePaymentContext alloc] initWithIdentifier:paymentId
                                                                                                 token:resourceToken
                                                                                           redirectURL:[NSURL URLWithString:redirectURI]
                                                                                           preferences:trueLayerPreferences];
    
    [TrueLayerPaymentsManager processSinglePaymentWithContext:context 
                                                    onSuccess:^(TrueLayerProcessSinglePaymentSuccess * _Nonnull singlePaymentSuccess) {
      // See `types.ts` for the raw values to match.
      NSString *step = [RNTrueLayerHelpers stepFromSinglePaymentState:singlePaymentSuccess.state];
      NSString *resultShown = [RNTrueLayerHelpers resultShownFromSinglePaymentResultShown:singlePaymentSuccess.resultShown];
      
      NSDictionary *result = @{
        @"type": @"Success",
        @"step": step,
        @"resultShown": resultShown
      };
      
      resolve(result);

    } 
                                                    onFailure:^(TrueLayerProcessSinglePaymentFailure * _Nonnull singlePaymentFailure) {
      NSString *reason = [RNTrueLayerHelpers reasonFromSinglePaymentError:singlePaymentFailure.error];
      NSString *resultShown = [RNTrueLayerHelpers resultShownFromSinglePaymentResultShown:singlePaymentFailure.resultShown];

      NSDictionary *result = @{
        @"type": @"Failure",
        @"reason": reason,
        @"resultShown": resultShown
      };
      
      resolve(result);
    }];
  }];
}

-(void)executeProcessMandate:(NSString *)mandateId
               resourceToken:(NSString *)resourceToken
                 redirectURI:(NSString *)redirectURI
      shouldShowResultScreen:(bool)shouldShowResultScreen
              waitTimeMillis:(NSNumber  * _Nullable)waitTimeMillis
                     resolve:(RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
{
  // Check that all the context values exist. Else, reject the promise.
  if (mandateId == nil || resourceToken == nil || redirectURI == nil) {
    NSError *error = [self errorWithDescriptionKey:@"A value in the payment context is nil."
                             failureReasonErrorKey:@"The payment ID, resource token, or redirect URI passed is nil."
                        recoverySuggestionErrorKey:@"Please pass a valid, non-nil payment ID, resource token, and redirect URI."
                                              code:2];
    
    reject([@(error.code) stringValue], error.localizedDescription, error);
    return;
  }
  
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    // Capture the presented view controller.
    // We use the main thread here as `RCTPresentedViewController.init` accesses the main application window.
    UIViewController *reactViewController = RCTPresentedViewController();
    
    // Create the context required by the ObjC bridge in TrueLayerSDK.
    TrueLayerPresentationStyle *presentationStyle = [[TrueLayerPresentationStyle alloc] initWithPresentOn:reactViewController
                                                                                                    style:UIModalPresentationAutomatic];
    TrueLayerMandatePreferences *preferences = [[TrueLayerMandatePreferences alloc] initWithPresentationStyle:presentationStyle
                                                                                       shouldShowResultScreen:shouldShowResultScreen
                                                                                   maximumResultScreenTimeout:waitTimeMillis];
    
    TrueLayerMandateContext *context = [[TrueLayerMandateContext alloc] initWithIdentifier:mandateId
                                                                                     token:resourceToken
                                                                               redirectURL:[NSURL URLWithString:redirectURI]
                                                                               preferences:preferences];
        
    [TrueLayerPaymentsManager processMandateWithContext:context
                                   onSuccess:^(TrueLayerProcessMandateSuccess * _Nonnull singlePaymentSuccess) {
      // See `types.ts` for the raw values to match.
      NSString *step = [RNTrueLayerHelpers stepFromMandateState:singlePaymentSuccess.state];
      NSString *resultShown = [RNTrueLayerHelpers resultShownFromMandateResultShown:singlePaymentSuccess.resultShown];
      
      NSDictionary *result = @{
        @"type": @"Success",
        @"step": step,
        @"resultShown": resultShown
      };
      
      resolve(result);
      
    }
                                   onFailure:^(TrueLayerProcessMandateFailure * _Nonnull singlePaymentFailure) {
      NSString *reason = [RNTrueLayerHelpers reasonFromMandateError:singlePaymentFailure.error];
      NSString *resultShown = [RNTrueLayerHelpers resultShownFromMandateResultShown:singlePaymentFailure.resultShown];
      
      NSDictionary *result = @{
        @"type": @"Failure",
        @"reason": reason,
        @"resultShown": resultShown
      };
      
      resolve(result);
    }];
  }];
}

// MARK: Styling Helper

#ifdef RCT_NEW_ARCH_ENABLED
- (TrueLayerVisualSettings * _Nullable)setupVisualSettingsFromTheme:(JS::NativeTrueLayerPaymentsSDK::Spec_configureTheme &)theme {
  TrueLayerVisualSettings *visualSettings = [[TrueLayerVisualSettings alloc] init];
  NSError *error;
  
  if (theme.ios().has_value()) {
    bool hasLightColors = theme.ios().value().lightColors().has_value();
    bool hasDarkColors = theme.ios().value().darkColors().has_value();
    
    if (theme.ios().value().fontFamilyName() != nil) {
      visualSettings.customFontFamilyName = theme.ios().value().fontFamilyName();
    }
    
    if (hasLightColors && hasDarkColors) {
      JS::NativeTrueLayerPaymentsSDK::Spec_configureThemeIosLightColors lightColors = theme.ios().value().lightColors().value();
      JS::NativeTrueLayerPaymentsSDK::Spec_configureThemeIosDarkColors darkColors = theme.ios().value().darkColors().value();
      
      TrueLayerBackgroundColors *backgroundColors =
      [[TrueLayerBackgroundColors alloc] initWithBackgroundPrimaryLightHex: lightColors.backgroundPrimary()
                                               backgroundSecondaryLightHex: lightColors.backgroundSecondary()
                                           backgroundActionPrimaryLightHex: lightColors.backgroundActionPrimary()
                                                    backgroundCellLightHex: lightColors.backgroundCell()
                                                  backgroundPrimaryDarkHex: darkColors.backgroundPrimary()
                                                backgroundSecondaryDarkHex: darkColors.backgroundSecondary()
                                            backgroundActionPrimaryDarkHex: darkColors.backgroundActionPrimary()
                                                     backgroundCellDarkHex: darkColors.backgroundCell()
                                                                     error: &error];
      
      TrueLayerContentColors *contentColors =
      [[TrueLayerContentColors alloc] initWithContentPrimaryLightHex: lightColors.contentPrimary()
                                            contentSecondaryLightHex: lightColors.contentSecondary()
                                      contentPrimaryInvertedLightHex: lightColors.contentPrimaryInverted()
                                               contentActionLightHex: lightColors.contentAction()
                                                contentErrorLightHex: lightColors.contentError()
                                               contentPrimaryDarkHex: darkColors.contentPrimary()
                                             contentSecondaryDarkHex: darkColors.contentSecondary()
                                       contentPrimaryInvertedDarkHex: darkColors.contentPrimaryInverted()
                                                contentActionDarkHex: darkColors.contentAction()
                                                 contentErrorDarkHex: darkColors.contentError()
                                                               error: &error];
      
      TrueLayerAccessoryColors *accessoryColors =
      [[TrueLayerAccessoryColors alloc] initWithSeparatorLightHex: lightColors.separator()
                                          uiElementBorderLightHex: lightColors.uiElementBorder()
                                                 separatorDarkHex: darkColors.separator()
                                           uiElementBorderDarkHex: darkColors.uiElementBorder()
                                                            error: &error];
      
      visualSettings.colors.backgroundColors = backgroundColors;
      visualSettings.colors.contentColors = contentColors;
      visualSettings.colors.accessoryColors = accessoryColors;
      
    } else if (hasLightColors) {
      JS::NativeTrueLayerPaymentsSDK::Spec_configureThemeIosLightColors lightColors = theme.ios().value().lightColors().value();
      
      TrueLayerBackgroundColors *backgroundColors =
      [[TrueLayerBackgroundColors alloc] initWithBackgroundPrimaryLightHex: lightColors.backgroundPrimary()
                                               backgroundSecondaryLightHex: lightColors.backgroundSecondary()
                                           backgroundActionPrimaryLightHex: lightColors.backgroundActionPrimary()
                                                    backgroundCellLightHex: lightColors.backgroundCell()
                                                  backgroundPrimaryDarkHex: NULL
                                                backgroundSecondaryDarkHex: NULL
                                            backgroundActionPrimaryDarkHex: NULL
                                                     backgroundCellDarkHex: NULL
                                                                     error: &error];
      
      TrueLayerContentColors *contentColors =
      [[TrueLayerContentColors alloc] initWithContentPrimaryLightHex: lightColors.contentPrimary()
                                            contentSecondaryLightHex: lightColors.contentSecondary()
                                      contentPrimaryInvertedLightHex: lightColors.contentPrimaryInverted()
                                               contentActionLightHex: lightColors.contentAction()
                                                contentErrorLightHex: lightColors.contentError()
                                               contentPrimaryDarkHex: NULL
                                             contentSecondaryDarkHex: NULL
                                       contentPrimaryInvertedDarkHex: NULL
                                                contentActionDarkHex: NULL
                                                 contentErrorDarkHex: NULL
                                                               error: &error];
      
      TrueLayerAccessoryColors *accessoryColors =
      [[TrueLayerAccessoryColors alloc] initWithSeparatorLightHex: lightColors.separator()
                                          uiElementBorderLightHex: lightColors.uiElementBorder()
                                                 separatorDarkHex: NULL
                                           uiElementBorderDarkHex: NULL
                                                            error: &error];
      
      visualSettings.colors.backgroundColors = backgroundColors;
      visualSettings.colors.contentColors = contentColors;
      visualSettings.colors.accessoryColors = accessoryColors;
    } else if (hasDarkColors) {
      JS::NativeTrueLayerPaymentsSDK::Spec_configureThemeIosDarkColors darkColors = theme.ios().value().darkColors().value();
      
      TrueLayerBackgroundColors *backgroundColors =
      [[TrueLayerBackgroundColors alloc] initWithBackgroundPrimaryLightHex: NULL
                                               backgroundSecondaryLightHex: NULL
                                           backgroundActionPrimaryLightHex: NULL
                                                    backgroundCellLightHex: NULL
                                                  backgroundPrimaryDarkHex: darkColors.backgroundPrimary()
                                                backgroundSecondaryDarkHex: darkColors.backgroundSecondary()
                                            backgroundActionPrimaryDarkHex: darkColors.backgroundActionPrimary()
                                                     backgroundCellDarkHex: darkColors.backgroundCell()
                                                                     error: &error];
      
      TrueLayerContentColors *contentColors =
      [[TrueLayerContentColors alloc] initWithContentPrimaryLightHex: NULL
                                            contentSecondaryLightHex: NULL
                                      contentPrimaryInvertedLightHex: NULL
                                               contentActionLightHex: NULL
                                                contentErrorLightHex: NULL
                                               contentPrimaryDarkHex: darkColors.contentPrimary()
                                             contentSecondaryDarkHex: darkColors.contentSecondary()
                                       contentPrimaryInvertedDarkHex: darkColors.contentPrimaryInverted()
                                                contentActionDarkHex: darkColors.contentAction()
                                                 contentErrorDarkHex: darkColors.contentError()
                                                               error: &error];
      
      TrueLayerAccessoryColors *accessoryColors =
      [[TrueLayerAccessoryColors alloc] initWithSeparatorLightHex: NULL
                                          uiElementBorderLightHex: NULL
                                                 separatorDarkHex: darkColors.separator()
                                           uiElementBorderDarkHex: darkColors.uiElementBorder()
                                                            error: &error];
      
      visualSettings.colors.backgroundColors = backgroundColors;
      visualSettings.colors.contentColors = contentColors;
      visualSettings.colors.accessoryColors = accessoryColors;
    }
  } else {
    return visualSettings;
  }
  
  if (error != nil) {
    return NULL;
  }
  
  return visualSettings;
}
#else
- (TrueLayerVisualSettings * _Nullable)setupVisualSettingsFromDictionary:(NSDictionary *)theme {
  TrueLayerVisualSettings *visualSettings = [[TrueLayerVisualSettings alloc] init];
  NSError *error;
  
  if (theme[@"ios"] != nil) {
    if (theme[@"ios"][@"fontFamilyName"] != nil) {
      visualSettings.customFontFamilyName = theme[@"ios"][@"fontFamilyName"];
    }
    
    TrueLayerBackgroundColors *backgroundColors =
    [[TrueLayerBackgroundColors alloc] initWithBackgroundPrimaryLightHex: theme[@"ios"][@"lightColors"][@"backgroundPrimary"]
                                             backgroundSecondaryLightHex: theme[@"ios"][@"lightColors"][@"backgroundSecondary"]
                                         backgroundActionPrimaryLightHex: theme[@"ios"][@"lightColors"][@"backgroundActionPrimary"]
                                                  backgroundCellLightHex: theme[@"ios"][@"lightColors"][@"backgroundCell"]
                                                backgroundPrimaryDarkHex: theme[@"ios"][@"darkColors"][@"backgroundPrimary"]
                                              backgroundSecondaryDarkHex: theme[@"ios"][@"darkColors"][@"backgroundSecondary"]
                                          backgroundActionPrimaryDarkHex: theme[@"ios"][@"darkColors"][@"backgroundActionPrimary"]
                                                   backgroundCellDarkHex: theme[@"ios"][@"darkColors"][@"backgroundCell"]
                                                                   error: &error];
    
    TrueLayerContentColors *contentColors =
    [[TrueLayerContentColors alloc] initWithContentPrimaryLightHex: theme[@"ios"][@"lightColors"][@"contentPrimary"]
                                          contentSecondaryLightHex: theme[@"ios"][@"lightColors"][@"contentSecondary"]
                                    contentPrimaryInvertedLightHex: theme[@"ios"][@"lightColors"][@"contentPrimaryInverted"]
                                             contentActionLightHex: theme[@"ios"][@"lightColors"][@"contentAction"]
                                              contentErrorLightHex: theme[@"ios"][@"lightColors"][@"contentError"]
                                             contentPrimaryDarkHex: theme[@"ios"][@"darkColors"][@"contentPrimary"]
                                           contentSecondaryDarkHex: theme[@"ios"][@"darkColors"][@"contentSecondary"]
                                     contentPrimaryInvertedDarkHex: theme[@"ios"][@"darkColors"][@"contentPrimaryInverted"]
                                              contentActionDarkHex: theme[@"ios"][@"darkColors"][@"contentAction"]
                                               contentErrorDarkHex: theme[@"ios"][@"darkColors"][@"contentError"]
                                                             error: &error];
    
    TrueLayerAccessoryColors *accessoryColors =
    [[TrueLayerAccessoryColors alloc] initWithSeparatorLightHex: theme[@"ios"][@"lightColors"][@"separator"]
                                        uiElementBorderLightHex: theme[@"ios"][@"lightColors"][@"uiElementBorder"]
                                               separatorDarkHex: theme[@"ios"][@"darkColors"][@"separator"]
                                         uiElementBorderDarkHex: theme[@"ios"][@"darkColors"][@"uiElementBorder"]
                                                          error: &error];
    
    visualSettings.colors.backgroundColors = backgroundColors;
    visualSettings.colors.contentColors = contentColors;
    visualSettings.colors.accessoryColors = accessoryColors;
    
  }
  
  if (error != nil) {
    return NULL;
  }
  
  return visualSettings;
}
#endif

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativeTrueLayerPaymentsSDKSpecJSI>(params);
}
#endif

@end
