import RNTrueLayerPaymentsSDK from "./NativeTrueLayerPaymentsSDK";
import {
  PaymentContext,
  PaymentPreferences,
  MandateContext,
  MandatePreferences,
  Environment,
  ProcessorResult,
  MandateStatusResult,
  PaymentStatusResult
} from "./models/types";

/**
 * Main TrueLayer interface to process payments and mandates.
 * In order to use TrueLayerSDK please make sure to
 * call configure() (only once) before attempting
 * to call any other functions otherwise you will
 * encounter a crash.
 */
export abstract class TrueLayerPaymentsSDKWrapper {
  /**
   * Configures and initializes the SDK. This function must be called before
   * any other call can be made.
   * @param environment select which environment you want to connect to
   * @see Environment
   */
  static configure(
    environment: Environment = Environment.Production
  ): Promise<void> {
    return RNTrueLayerPaymentsSDK!!._configure(environment);
  }

  /**
   * Processes payment for a given context
   * @param paymentContext context of a payment to process
   * @param preferences (optional) extra preferences
   *
   * @see PaymentContext
   * @see PaymentPreferences
   * @see ProcessorResult
   *
   * @returns Success with the step at which SDK handed payment back to caller
   *          or Failure with a corresponding FailureReason.
   */
  static processPayment(
    paymentContext: PaymentContext,
    preferences?: PaymentPreferences
  ): Promise<ProcessorResult> {
    return RNTrueLayerPaymentsSDK!!._processPayment(
      paymentContext,
      preferences
    );
  }

  /**
   * Processes mandate (recurring payment) for a given context
   * @param paymentContext context of a mandate to process
   * @param preferences (optional) extra preferences
   *
   * @see MandateContext
   * @see MandatePreferences
   * @see ProcessorResult
   *
   * @returns Success with the step at which SDK handed mandate back to caller
   *          or Failure with a corresponding FailureReason.
   */
  static processMandate(
    mandateContext: MandateContext,
    preferences?: MandatePreferences
  ): Promise<ProcessorResult> {
    return RNTrueLayerPaymentsSDK!!._processMandate(
      mandateContext,
      preferences
    );
  }

  /**
   * Allows to query a payment status
   * @param paymentId
   * @param resourceToken
   */
  static paymentStatus(
    paymentId: string,
    resourceToken: string
  ): Promise<PaymentStatusResult> {
    return RNTrueLayerPaymentsSDK!!._paymentStatus(paymentId, resourceToken);
  }

  /**
   * Allows to query a mandate status
   * @param mandateId
   * @param resourceToken
   */
  static mandateStatus(
    mandateId: string,
    resourceToken: string
  ): Promise<MandateStatusResult> {
    return RNTrueLayerPaymentsSDK!!._mandateStatus(mandateId, resourceToken);
  }
}

export default require('./NativeTrueLayerPaymentsSDK').default;