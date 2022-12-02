#import "TrueLayerSinglePaymentObjCState.h"
#import "TrueLayerSinglePaymentObjCError.h"
#import "TrueLayerMandateObjCState.h"
#import "TrueLayerMandateObjCError.h"

/// Helper methods to use throughout the react native implementation of the TrueLayer SDK.
@interface RTNTrueLayerHelpers: NSObject

// MARK: - Single Payment

/// Returns a `step` value to send to the merchant from a given single payment state.
/// - Parameter state: The single payment state received from the TrueLayerSDK Objective-C bridge.
+(NSString *)stepFromSinglePaymentObjCState:(TrueLayerSinglePaymentObjCState)state;

/// Returns a `reason` value to send tot he merchant from a given single payment error.
/// - Parameter error: The single payment error received from the TrueLayerSDK Objective-C bridge.
+(NSString *)reasonFromSinglePaymentObjCError:(TrueLayerSinglePaymentObjCError)error;

// MARK: - Mandate

/// Returns a `step` value to send to the merchant from a given mandate state.
/// - Parameter state: The mandate state received from the TrueLayerSDK Objective-C bridge.
+(NSString *)stepFromMandateObjCState:(TrueLayerMandateObjCState)state;

/// Returns a `reason` value to send tot he merchant from a given mandate error.
/// - Parameter error: The mandate error received from the TrueLayerSDK Objective-C bridge.
+(NSString *)reasonFromMandateObjCError:(TrueLayerMandateObjCError)error;


@end
