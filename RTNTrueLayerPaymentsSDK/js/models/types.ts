export { PaymentContext } from "./payments/PaymentContext";

export { PaymentStatus } from "./payments/PaymentStatus";

export { PaymentUseCase } from "./payments/PaymentUseCase";

export { MandateContext } from "./mandates/MandateContext";

export { MandateStatus } from "./mandates/MandateStatus";

export { PaymentPreferences } from "./payments/PaymentPreferences";

export { MandatePreferences } from "./mandates/MandatePreferences";

/**
 * Defines available environments
 */
export enum Environment {
  Production = "PRODUCTION",
  Sandbox = "SANDBOX",
}

export enum ProcessorResultType {
  Success = "Success",
  Failure = "Failure",
}

export type ProcessorResult =
  | { type: ProcessorResultType.Success; step: ProcessorStep }
  | { type: ProcessorResultType.Failure; reason: FailureReason };

export enum ProcessorStep {
  Redirect = "Redirect",
  Wait = "Wait",
  Authorized = "Authorized",
  Executed = "Executed",
  Settled = "Settled",
}

export type FailureReason =
  | "NoInternet"
  | "UserAborted"
  | "CommunicationIssue"
  | "ConnectionSecurityIssue"
  | "PaymentFailed"
  | "WaitAbandoned"
  | "ProcessorContextNotAvailable"
  | "Unknown";
