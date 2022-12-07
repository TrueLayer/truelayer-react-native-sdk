/// The reasons for any errors that may occur while processing a single payment or mandate. These match the types in `types.ts`.
/// We share these error constants as they are shared in the react-native spec.
/// The mandate-specific errors returned by the TrueLayer iOS SDK are mapped to these shared errors.
typedef NSString *RTNTrueLayerErrorReason NS_TYPED_ENUM;
extern RTNTrueLayerErrorReason const RTNTrueLayerErrorReasonPaymentFailed;
extern RTNTrueLayerErrorReason const RTNTrueLayerErrorReasonCommunicationIssue;
extern RTNTrueLayerErrorReason const RTNTrueLayerErrorReasonUnknown;
extern RTNTrueLayerErrorReason const RTNTrueLayerErrorReasonConnectionSecurityIssue;
extern RTNTrueLayerErrorReason const RTNTrueLayerErrorReasonProcessorContextNotAvailable;
extern RTNTrueLayerErrorReason const RTNTrueLayerErrorReasonUserAborted;
