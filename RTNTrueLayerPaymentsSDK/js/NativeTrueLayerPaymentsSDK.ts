import { TurboModule, TurboModuleRegistry } from "react-native";

import { ProcessorResult, PaymentStatus, MandateStatus } from "./models/types";

/**
 * ReactNative raw interface. Do not use directly. Use TrueLayerPaymentsSDKWrapper class instead.
 */
interface Spec extends TurboModule {
  /**
   * ReactNative raw interface. Do not use directly. Use TrueLayerPaymentsSDKWrapper class instead.
   */
  _configure(environment: string): Promise<void>;

  /**
   * ReactNative raw interface. Do not use directly. Use TrueLayerPaymentsSDKWrapper class instead.
   */
  _processPayment(
    paymentContext: {
      paymentId: string;
      resourceToken: string;
      redirectUri: string;
    },
    prefereces?: {
      preferredCountryCode?: string;
      paymentUseCase: string;
    }
  ): Promise<ProcessorResult>;

  /**
   * ReactNative raw interface. Do not use directly. Use TrueLayerPaymentsSDKWrapper class instead.
   */
  _processMandate(
    mandateContext: {
      mandateId: string;
      resourceToken: string;
      redirectUri: string;
    },
    prefereces?: {
      preferredCountryCode?: string;
    }
  ): Promise<ProcessorResult>;

  /**
   * ReactNative raw interface. Do not use directly. Use TrueLayerPaymentsSDKWrapper class instead.
   */
  _paymentStatus(
    paymentId: string,
    resourceToken: string
  ): Promise<PaymentStatus>;

  /**
   * ReactNative raw interface. Do not use directly. Use TrueLayerPaymentsSDKWrapper class instead.
   */
  _mandateStatus(
    mandateId: string,
    resourceToken: string
  ): Promise<MandateStatus>;
}

export default TurboModuleRegistry.get<Spec>(
  "RTNTrueLayerPaymentsSDK"
) as Spec | null;
