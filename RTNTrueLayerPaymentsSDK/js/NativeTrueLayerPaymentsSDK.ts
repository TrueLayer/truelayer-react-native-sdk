import type { TurboModule } from 'react-native/Libraries/TurboModule/RCTExport';
import { TurboModuleRegistry } from 'react-native';

export type ProcessorPrefferences = {
  preferredCountryCode?: string;
  paymentUseCase?: string;
}

export function createProcessorPreferences(
    preferredCountryCode?: string,
    paymentUseCase?: PaymentUseCase
) {
  return {
    preferredCountryCode: preferredCountryCode,
    paymentUseCase: paymentUseCase
  }
}

export enum PaymentUseCase {
  Default = 'Default',
  Send = 'Send',
  SignUpPlus = 'SignUpPlus'
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

export enum ProcessorResultType {
  Success = 'Success',
  Failure = 'Failure'
}

export type ProcessorResult =
    | { type: ProcessorResultType.Success, step: PaymentStep }
    | { type: ProcessorResultType.Failure, reason: FailureReason };

export enum PaymentStep {
  Redirect= 'Redirect',
  Wait = 'Wait',
  Authoried = 'Authorized',
  Successful = 'Successful',
  Settled = 'Settled',
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
