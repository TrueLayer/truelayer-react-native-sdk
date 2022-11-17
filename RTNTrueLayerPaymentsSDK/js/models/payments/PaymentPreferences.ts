import {PaymentUseCase} from './PaymentUseCase';

export type PaymentPreferences = {
    preferredCountryCode?: string;
    paymentUseCase: PaymentUseCase;
}
