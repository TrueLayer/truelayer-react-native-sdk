#import <Foundation/Foundation.h>
#import "RTNTrueLayerHelpers.h"

@implementation RTNTrueLayerHelpers: NSObject

+ (NSString *)stepFrom:(TrueLayerSinglePaymentObjCState)state {
  switch (state) {
    case TrueLayerSinglePaymentObjCStateAuthorized:
      return @"Authorized";
      
    case TrueLayerSinglePaymentObjCStateExecuted:
      return @"Executed";
      
    case TrueLayerSinglePaymentObjCStateRedirect:
      return @"Redirect";
      
    case TrueLayerSinglePaymentObjCStateSettled:
      return @"Settled";
      
    case TrueLayerSinglePaymentObjCStateWait:
      return @"Wait";
  }
}

+ (NSString *)reasonFrom:(TrueLayerSinglePaymentObjCError)error {
  switch (error) {
    case TrueLayerSinglePaymentObjCErrorAuthorizationFailed:
      return @"PaymentFailed";
      
    case TrueLayerSinglePaymentObjCErrorConnectionIssues:
      return @"CommunicationIssue";
      
    case TrueLayerSinglePaymentObjCErrorGeneric:
      return @"Unknown";
      
    case TrueLayerSinglePaymentObjCErrorInvalidToken:
      return @"ConnectionSecurityIssue";
      
    case TrueLayerSinglePaymentObjCErrorPaymentExpired:
      return @"PaymentFailed";
      
    case TrueLayerSinglePaymentObjCErrorPaymentNotFound:
      return @"PaymentFailed";
      
    case TrueLayerSinglePaymentObjCErrorPaymentRejected:
      return @"PaymentFailed";
      
    case TrueLayerSinglePaymentObjCErrorSdkNotConfigured:
      return @"ProcessorContextNotAvailable";
      
    case TrueLayerSinglePaymentObjCErrorServerError:
      return @"CommunicationIssue";
      
    case TrueLayerSinglePaymentObjCErrorUnexpectedBehavior:
      return @"Unknown";
      
    case TrueLayerSinglePaymentObjCErrorUserCanceled:
      return @"UserAborted";
  }
}

@end