import { TurboModule, TurboModuleRegistry } from "react-native";

import {
  ProcessorResult,
  PaymentStatusResult,
  MandateStatusResult
} from "./models/types";

/**
 * ReactNative raw interface. Do not use directly. Use TrueLayerPaymentsSDKWrapper class instead.
 *
 * The raw interface and the wrappers were created to overcome a TypeScript limitations
 * of the raw interface. The react native bridge has only limited support for TypeScript.
 * In order to deliver fully type safe interface we've created a TrueLayerPaymentsSDKWrapper which then
 * calls into the bridge.
 */
interface Spec extends TurboModule {
  /**
   * ReactNative raw interface. Do not use directly. Use TrueLayerPaymentsSDKWrapper class instead.
   */
  _configure(
    environment: string,
    theme?: {
      android?: {
        lightColors?: {
          primary?: string;
          background?: string;
          onBackground?: string;
          surface?: string;
          onSurface?: string;
          error?: string;
        };
        darkColors?: {
          primary?: string;
          background?: string;
          onBackground?: string;
          surface?: string;
          onSurface?: string;
          error?: string;
        };
        typography?: {
          bodyLarge?: {
            font?: string
          };
          bodyMedium?: {
            font?: string
          };
          bodySmall?: {
            font?: string
          };
          titleLarge?: {
            font?: string
          };
          titleMedium?: {
            font?: string
          };
          headlineSmall?: {
            font?: string
          };
          labelLarge?: {
            font?: string
          };
        }
      },
      ios?: {
        lightColors?: {
          backgroundPrimary?: string;
          backgroundSecondary?: string;
          backgroundActionPrimary?: string;
          backgroundCell?: string;
          contentPrimary?: string;
          contentSecondary?: string;
          contentPrimaryInverted?: string;
          contentAction?: string;
          contentError?: string;
          separator?: string;
          uiElementBorder?: string;
        },
        darkColors?: {
          backgroundPrimary?: string;
          backgroundSecondary?: string;
          backgroundActionPrimary?: string;
          backgroundCell?: string;
          contentPrimary?: string;
          contentSecondary?: string;
          contentPrimaryInverted?: string;
          contentAction?: string;
          contentError?: string;
          separator?: string;
          uiElementBorder?: string;
        },
        fontFamilyName?: string
      }
    }
  ): Promise<void>;

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
      shouldPresentResultScreen?: boolean;
      waitTimeMillis?: number;
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
      shouldPresentResultScreen?: boolean;
      waitTimeMillis?: number;
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
  "RNTrueLayerPaymentsSDK"
) as Spec | null;
