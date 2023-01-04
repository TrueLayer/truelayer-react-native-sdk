import { TurboModule, TurboModuleRegistry } from "react-native";

import { ProcessorResult, PaymentStatus, MandateStatus, PaymentStatusResult, MandateStatusResult } from "./models/types";

/**
 * ReactNative raw interface. Do not use directly. Use TrueLayerPaymentsSDKWrapper class instead.
 *
 * The raw interface and the wrappers were created to overcome a TypeScript limitations
 * of the raw interface. The react native bridge has only limitted support for TypeScript.
 * In order to deliver fully type safe interface we've created a TrueLayerPaymentsSDKWrapper which then
 * calls into the bridge.
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
    preferences?: {
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
    preferences?: {
      preferredCountryCode?: string;
    }
  ): Promise<ProcessorResult>;

  /**
   * ReactNative raw interface. Do not use directly. Use TrueLayerPaymentsSDKWrapper class instead.
   */
  _paymentStatus(
    paymentId: string,
    resourceToken: string
  ): Promise<PaymentStatusResult>;

  /**
   * ReactNative raw interface. Do not use directly. Use TrueLayerPaymentsSDKWrapper class instead.
   */
  _mandateStatus(
    mandateId: string,
    resourceToken: string
  ): Promise<MandateStatusResult>;
}

export default TurboModuleRegistry.get<Spec>(
  "RTNTrueLayerPaymentsSDK"
) as Spec | null;
