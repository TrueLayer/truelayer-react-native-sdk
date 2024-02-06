import { PaymentUseCase } from "./PaymentUseCase";

export type PaymentPreferences = {
  preferredCountryCode?: string;
  /**
  * @deprecated The parameter should not be used
  */
  paymentUseCase: PaymentUseCase;
};
