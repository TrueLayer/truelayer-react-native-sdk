import { MandateStatus } from "./mandates/MandateStatus";
import { PaymentStatus } from "./payments/PaymentStatus";

export { PaymentContext } from "./payments/PaymentContext";

export { PaymentStatus } from "./payments/PaymentStatus";

export { PaymentUseCase } from "./payments/PaymentUseCase";

export { MandateContext } from "./mandates/MandateContext";

export { MandateStatus } from "./mandates/MandateStatus";

export { PaymentPreferences } from "./payments/PaymentPreferences";

export { MandatePreferences } from "./mandates/MandatePreferences";

export { Theme } from "./theme/Theme";

export { AndroidColors } from "./theme/AndroidColors";

export { AndroidTypography } from "./theme/AndroidTypography";

/**
 * Defines available environments
 */
export enum Environment {
  Production = "PRODUCTION",
  Sandbox = "SANDBOX",
}

export enum ResultType {
  Success = "Success",
  Failure = "Failure",
}

export type ProcessorResult =
  | { type: ResultType.Success; step: ProcessorStep }
  | { type: ResultType.Failure; reason: FailureReason };

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

/**
 * Provides more detailed information about the error.
 */
export type StatusFailure = {
  /** The main reason for the failure */
  reason: FailureReason;
  /** HTTP response code (optional) */
  httpResponseCode?: number;
  /** The error message (optional)*/
  errorMessage?: String;
  /** The raw response that was send by the server (optional) */
  rawResponseBody?: String;
  /** If server returned valid error response this will
   * contain a error title (optinal)*/
  title?: String;
  /** If server returned valid error response this will
   * contain a error description (optinal)*/
  description?: String;
  /** Trace ID will allow faster debugging on TrueLayer side (optional) */
  traceId?: String;
  /** If the error was caused by an Exception, the information will be
   * available in here (optional) */
  causeException?: String;
};

export type PaymentStatusResult =
  | { type: ResultType.Success; status: PaymentStatus }
  | { type: ResultType.Failure; failure: StatusFailure };

export type MandateStatusResult =
  | { type: ResultType.Success; status: MandateStatus }
  | { type: ResultType.Failure; failure: StatusFailure };
