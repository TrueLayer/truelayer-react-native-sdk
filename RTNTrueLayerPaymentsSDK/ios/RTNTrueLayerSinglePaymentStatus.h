/// The various statuses in which a payment can be.
/// These reflect the constants in the React Native spec in `types.ts`.
typedef NSString *RTNTrueLayerSinglePaymentStatus NS_TYPED_ENUM;
extern RTNTrueLayerSinglePaymentStatus const RTNTrueLayerSinglePaymentStatusAuthorizationRequired;
extern RTNTrueLayerSinglePaymentStatus const RTNTrueLayerSinglePaymentStatusAuthorized;
extern RTNTrueLayerSinglePaymentStatus const RTNTrueLayerSinglePaymentStatusAuthorizing;
extern RTNTrueLayerSinglePaymentStatus const RTNTrueLayerSinglePaymentStatusExecuted;
extern RTNTrueLayerSinglePaymentStatus const RTNTrueLayerSinglePaymentStatusFailed;
extern RTNTrueLayerSinglePaymentStatus const RTNTrueLayerSinglePaymentStatusSettled;