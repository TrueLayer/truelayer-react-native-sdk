import RTNTrueLayerPaymentsSDK from "./NativeTrueLayerPaymentsSDK";
import {
  PaymentContext,
  PaymentPreferences,
  MandateContext,
  MandatePreferences,
  Environment,
  ProcessorResult,
  PaymentStatus,
  MandateStatus,
} from "./models/types";

/**
 * Main TrueLayer interface to process payments and mandates.
 * In order to use TrueLayerSDK please make sure that you will
 * call configure() (only once) before attemping
 * to call any other funcions otherwise you will
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
    return RTNTrueLayerPaymentsSDK!!._configure(environment);
  }

  /**
   * Processes payment for a given context
   * @param paymentContext context of a payment to process
   * @param prefereces (optional) extra preferences
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
    prefereces?: PaymentPreferences
  ): Promise<ProcessorResult> {
    return RTNTrueLayerPaymentsSDK!!._processPayment(
      paymentContext,
      prefereces
    );
  }

  /**
   * Processes mandate (recurring payment) for a given context
   * @param paymentContext context of a mandate to process
   * @param prefereces (optional) extra preferences
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
    prefereces?: MandatePreferences
  ): Promise<ProcessorResult> {
    return RTNTrueLayerPaymentsSDK!!._processMandate(
      mandateContext,
      prefereces
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
  ): Promise<PaymentStatus> {
    return RTNTrueLayerPaymentsSDK!!._paymentStatus(paymentId, resourceToken);
  }

  /**
   * Allows to query a mandate status
   * @param mandateId
   * @param resourceToken
   */
  static mandateStatus(
    mandateId: string,
    resourceToken: string
  ): Promise<MandateStatus> {
    return RTNTrueLayerPaymentsSDK!!._mandateStatus(mandateId, resourceToken);
  }
}
