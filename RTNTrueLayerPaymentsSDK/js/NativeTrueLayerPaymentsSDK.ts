import type { TurboModule } from 'react-native/Libraries/TurboModule/RCTExport';
import { TurboModuleRegistry } from 'react-native';

export type ProcessorPrefferences = {
  prefferedCountryCode?: string;
  paymentUseCase?: string;
}

export enum PaymentUseCase {
  Default,
  useCase,
  SignUpPlus
};

export type PaymentContext = {
  paymentId: string,
  resourceToken: string,
  redirectUri: string,
}

export type MandateContext = {
  mandateId: string,
  resourceToken: string,
  redirectUri: string,
}

export type ProcessorResult =
    | { type: 'Success', step: PaymentStep }
    | { type: 'Failure', reason: FailureReason };

export enum PaymentStep {
  Redirect,
  Wait,
  Authoried,
  Successful,
  Settled,
}

export type FailureReason = 'NoInternet'
    | 'UserAborted'
    | 'UserAbortedFailedToNotifyBackend'
    | 'CommunicationIssue'
    | 'ConnectionSecurityIssue'
    | 'PaymentFailed'
    | 'WaitAbandoned'
    | 'WaitTokenExpired'
    | 'ProcessorContextNotAvailable'
    | 'Unknown';

export interface Spec extends TurboModule {
  configureSDK(): string;
  processPayment(
      paymentContext: PaymentContext,
      prefereces: ProcessorPrefferences,
  ): Promise<ProcessorResult>;

  processMandate(
      mandateContext: MandateContext,
      prefereces: ProcessorPrefferences,
  ): Promise<ProcessorResult>;
}

export default TurboModuleRegistry.get<Spec>(
  'RTNTrueLayerPaymentsSDK'
) as Spec | null;