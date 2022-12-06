#import "TrueLayerSinglePaymentObjCState.h"
#import "TrueLayerSinglePaymentObjCError.h"

/// Helper methods to use throughout the react native implementation of the TrueLayer SDK.
@interface RTNTrueLayerHelpers: NSObject

/// Returns a `step` value to send to the merchant from a given single payment state.
/// - Parameter state: The single payment state received from the TrueLayerSDK Objective-C bridge.
+(NSString *)stepFrom:(TrueLayerSinglePaymentObjCState)state;

/// Returns a `reason` value to send tot he merchant from a given single payment error.
/// - Parameter error: The single payment error received from the TrueLayerSDK Objective-C bridge.
+(NSString *)reasonFrom:(TrueLayerSinglePaymentObjCError)error;

@end