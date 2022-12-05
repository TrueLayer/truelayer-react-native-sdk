#import <Foundation/Foundation.h>
#import "RTNTrueLayerHelpers.h"
#import "RTNTrueLayerSinglePaymentStep.h"
#import "RTNTrueLayerErrorReason.h"
#import "RTNTrueLayerMandateStep.h"
#import "RTNTrueLayerSinglePaymentStatus.h"

@implementation RTNTrueLayerHelpers: NSObject

// MARK: - Single Payment

+ (NSString *)stepFromSinglePaymentObjCState:(TrueLayerSinglePaymentObjCState)state {
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

+ (NSString *)reasonFromSinglePaymentObjCError:(TrueLayerSinglePaymentObjCError)error {
  switch (error) {
    case TrueLayerSinglePaymentObjCErrorAuthorizationFailed:
      return RTNTrueLayerErrorReasonPaymentFailed;
      
    case TrueLayerSinglePaymentObjCErrorConnectionIssues:
      return RTNTrueLayerErrorReasonCommunicationIssue;
      
    case TrueLayerSinglePaymentObjCErrorGeneric:
      return RTNTrueLayerErrorReasonUnknown;
      
    case TrueLayerSinglePaymentObjCErrorInvalidToken:
      return RTNTrueLayerErrorReasonConnectionSecurityIssue;
      
    case TrueLayerSinglePaymentObjCErrorPaymentExpired:
      return RTNTrueLayerErrorReasonPaymentFailed;
      
    case TrueLayerSinglePaymentObjCErrorPaymentNotFound:
      return RTNTrueLayerErrorReasonPaymentFailed;
      
    case TrueLayerSinglePaymentObjCErrorPaymentRejected:
      return RTNTrueLayerErrorReasonPaymentFailed;
      
    case TrueLayerSinglePaymentObjCErrorSdkNotConfigured:
      return RTNTrueLayerErrorReasonProcessorContextNotAvailable;
      
    case TrueLayerSinglePaymentObjCErrorServerError:
      return RTNTrueLayerErrorReasonCommunicationIssue;
      
    case TrueLayerSinglePaymentObjCErrorUnexpectedBehavior:
      return RTNTrueLayerErrorReasonUnknown;
      
    case TrueLayerSinglePaymentObjCErrorUserCanceled:
      return RTNTrueLayerErrorReasonUserAborted;
  }
}

+ (NSString *)statusFromSinglePaymentObjCStatus:(TrueLayerSinglePaymentObjCStatus)status {
  switch (status) {
    case TrueLayerSinglePaymentObjCStatusAuthorizationRequired:
      return RTNTrueLayerSinglePaymentStatusAuthorizationRequired;

    case TrueLayerSinglePaymentObjCStatusAuthorizing:
      return RTNTrueLayerSinglePaymentStatusAuthorizing;

    case TrueLayerSinglePaymentObjCStatusAuthorized:
      return RTNTrueLayerSinglePaymentStatusAuthorized;

    case TrueLayerSinglePaymentObjCStatusExecuted:
      return RTNTrueLayerSinglePaymentStatusExecuted;

    case TrueLayerSinglePaymentObjCStatusSettled:
      return RTNTrueLayerSinglePaymentStatusSettled;

    case TrueLayerSinglePaymentObjCStatusFailed:
      return RTNTrueLayerSinglePaymentStatusFailed;
  }
}

// MARK: - Mandate

+ (NSString *)stepFromMandateObjCState:(TrueLayerMandateObjCState)state {
  switch (state) {
    case TrueLayerMandateObjCStateAuthorized:
      return RTNTrueLayerMandateStepAuthorized;
      
    case TrueLayerMandateObjCStateRedirect:
      return RTNTrueLayerMandateStepRedirect;
  }
}

+ (NSString *)reasonFromMandateObjCError:(TrueLayerMandateObjCError)error {
  switch (error) {
    case TrueLayerMandateObjCErrorAuthorizationFailed:
      return RTNTrueLayerErrorReasonPaymentFailed;
      
    case TrueLayerMandateObjCErrorConnectionIssues:
      return RTNTrueLayerErrorReasonCommunicationIssue;
      
    case TrueLayerMandateObjCErrorGeneric:
      return RTNTrueLayerErrorReasonUnknown;
      
    case TrueLayerMandateObjCErrorInvalidToken:
      return RTNTrueLayerErrorReasonConnectionSecurityIssue;
      
    case TrueLayerMandateObjCErrorMandateExpired:
      return RTNTrueLayerErrorReasonPaymentFailed;
      
    case TrueLayerMandateObjCErrorMandateNotFound:
      return RTNTrueLayerErrorReasonPaymentFailed;
      
    case TrueLayerMandateObjCErrorMandateRejected:
      return RTNTrueLayerErrorReasonPaymentFailed;
      
    case TrueLayerMandateObjCErrorRevoked:
      return RTNTrueLayerErrorReasonPaymentFailed;
      
    case TrueLayerMandateObjCErrorSdkNotConfigured:
      return RTNTrueLayerErrorReasonProcessorContextNotAvailable;
      
    case TrueLayerMandateObjCErrorServerError:
      return RTNTrueLayerErrorReasonCommunicationIssue;
      
    case TrueLayerMandateObjCErrorUnexpectedBehavior:
      return RTNTrueLayerErrorReasonUnknown;
      
    case TrueLayerMandateObjCErrorUserCanceled:
      return RTNTrueLayerErrorReasonUserAborted;
  }
}

@end