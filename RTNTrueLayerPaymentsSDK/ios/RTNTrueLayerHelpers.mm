#import <Foundation/Foundation.h>
#import "RTNTrueLayerHelpers.h"
#import "RTNTrueLayerSinglePaymentStep.h"
#import "RTNTrueLayerSinglePaymentErrorReason.h"

@implementation RTNTrueLayerHelpers: NSObject

+ (NSString *)stepFrom:(TrueLayerSinglePaymentObjCState)state {
  switch (state) {
    case TrueLayerSinglePaymentObjCStateAuthorized:
      return RTNTrueLayerSinglePaymentStepAuthorized;
      
    case TrueLayerSinglePaymentObjCStateExecuted:
      return RTNTrueLayerSinglePaymentStepExecuted;
      
    case TrueLayerSinglePaymentObjCStateRedirect:
      return RTNTrueLayerSinglePaymentStepRedirect;
      
    case TrueLayerSinglePaymentObjCStateSettled:
      return RTNTrueLayerSinglePaymentStepSettled;
      
    case TrueLayerSinglePaymentObjCStateWait:
      return RTNTrueLayerSinglePaymentStepWait;
  }
}

+ (NSString *)reasonFrom:(TrueLayerSinglePaymentObjCError)error {
  switch (error) {
    case TrueLayerSinglePaymentObjCErrorAuthorizationFailed:
      return RTNTrueLayerSinglePaymentErrorReasonPaymentFailed;
      
    case TrueLayerSinglePaymentObjCErrorConnectionIssues:
      return RTNTrueLayerSinglePaymentErrorReasonCommunicationIssue;
      
    case TrueLayerSinglePaymentObjCErrorGeneric:
      return RTNTrueLayerSinglePaymentErrorReasonUnknown;
      
    case TrueLayerSinglePaymentObjCErrorInvalidToken:
      return RTNTrueLayerSinglePaymentErrorReasonConnectionSecurityIssue;
      
    case TrueLayerSinglePaymentObjCErrorPaymentExpired:
      return RTNTrueLayerSinglePaymentErrorReasonPaymentFailed;
      
    case TrueLayerSinglePaymentObjCErrorPaymentNotFound:
      return RTNTrueLayerSinglePaymentErrorReasonPaymentFailed;
      
    case TrueLayerSinglePaymentObjCErrorPaymentRejected:
      return RTNTrueLayerSinglePaymentErrorReasonPaymentFailed;
      
    case TrueLayerSinglePaymentObjCErrorSdkNotConfigured:
      return RTNTrueLayerSinglePaymentErrorReasonProcessorContextNotAvailable;
      
    case TrueLayerSinglePaymentObjCErrorServerError:
      return RTNTrueLayerSinglePaymentErrorReasonCommunicationIssue;
      
    case TrueLayerSinglePaymentObjCErrorUnexpectedBehavior:
      return RTNTrueLayerSinglePaymentErrorReasonUnknown;
      
    case TrueLayerSinglePaymentObjCErrorUserCanceled:
      return RTNTrueLayerSinglePaymentErrorReasonUserAborted;
  }
}

@end
