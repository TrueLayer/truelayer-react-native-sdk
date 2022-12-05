#import "TrueLayerSinglePaymentObjCState.h"
#import "TrueLayerSinglePaymentObjCError.h"
#import "TrueLayerMandateObjCState.h"
#import "TrueLayerMandateObjCError.h"
#import "TrueLayerSinglePaymentObjCStatus.h"

/// Helper methods to use throughout the react native implementation of the TrueLayer SDK.
@interface RTNTrueLayerHelpers: NSObject

// MARK: - Single Payment

/// Returns a `step` value to send to the merchant from a given single payment state.
/// - Parameter state: The single payment state received from the TrueLayerSDK Objective-C bridge.
+(NSString *)stepFromSinglePaymentObjCState:(TrueLayerSinglePaymentObjCState)state;

/// Returns a `reason` value to send to the merchant from a given single payment error.
/// - Parameter error: The single payment error received from the TrueLayerSDK Objective-C bridge.
+(NSString *)reasonFromSinglePaymentObjCError:(TrueLayerSinglePaymentObjCError)error;

/// Returns a `status` value to send to the merchant from a given Objective-C single payment status.
/// - Parameter status: The single payment status from the TrueLayerSDK Objecive-C bridge.
+(NSString *)statusFromSinglePaymentObjCStatus:(TrueLayerSinglePaymentObjCStatus)status;

// MARK: - Mandate

/// Returns a `step` value to send to the merchant from a given mandate state.
/// - Parameter state: The mandate state received from the TrueLayerSDK Objective-C bridge.
+(NSString *)stepFromMandateObjCState:(TrueLayerMandateObjCState)state;

/// Returns a `reason` value to send tot he merchant from a given mandate error.
/// - Parameter error: The mandate error received from the TrueLayerSDK Objective-C bridge.
+(NSString *)reasonFromMandateObjCError:(TrueLayerMandateObjCError)error;

/// Returns a `status` value to send to the merchant from a given Objective-C mandate status.
/// - Parameter status: The mandate status from the TrueLayerSDK Objecive-C bridge.
+(NSString *)statusFromMandateObjCStatus:(TrueLayerMandateObjCStatus)status;

@end