# Documentation

This a high level documentation on how to use the React Native TrueLayer SDK.

Once your app has obtained the payment (or mandate) identifier and resource token from the backend (see [Setup](../README.md)), you can use the React Native SDK to process the payment.

## Single Payment

### Creating a payment

Refer to our [payment-quickstart](https://github.com/TrueLayer/payments-quickstart)

### Processing a Single Payment

```
TrueLayerPaymentsSDKWrapper.processPayment(
  {
    paymentId: // Your payment ID,
    resourceToken: // Your payment token,
    redirectUri: // Your redirect URI,
  },
  {
    paymentUseCase: PaymentUseCase.Default,
  },
).then(result => {
  switch (result.type) {
    case ResultType.Success:
      console.log(`processPayment success at step: ${result.step}`)
      break
    case ResultType.Failure:
      console.log(`processPayment failure reason: ${result.reason}`)
      break
  }
})
```

The parameters used in `PaymentContext` are explained below:

- `paymentId`: the payment identifier retrieved from your backend.
- `resourceToken`: the payment token retrieved from your backend.
- `redirectUri`: the destination where the user should be redirected once the authorization flow is done outside of the app (bank website, HPP). This is usually your app's redirect URI.

The parameters used in the `PaymentPreferences` are explained below:

  - `preferredCountryCode`: the preferred country to use when displaying the providers. If the country is invalid, or does not include any providers, the value will fallback to the user's locale.
  - `paymentUseCase`: dictates the wording to display to the user when sending a payment, to clarify what the payment is used for. For example, for SignUp+, use `PaymentUseCase.SignUpPlus`. For a standard payment, use `PaymentUseCase.Default`.

### Getting Payment Status

In order to get the status of a payment, the SDK offers the following method:

```
TrueLayerPaymentsSDKWrapper.paymentStatus(
  // Your payment identifier,
  // Your payment resource token,
).then(result => {
  switch (result.type) {
    case ResultType.Success:
      console.log(`paymentStatus success with status: ${result.status}`)
      break
    case ResultType.Failure:
      console.log(`paymentStatus failed with the following reason: ${result.failure}`)
      break
  }
})
```

This should be treated as the favorite source of truth for the status of the payment.

#### Status

| `PaymentStatus` | Description |
| ------------- | ------------- 
| `AuthorizationRequired` | The payment requires authorisation.
| `Authorizing` | The user is authorizing the payment.
| `Authorized` | The payment has been authorized by the bank.
| `Executed` | The payment has been executed.
| `Settled` | The funds have reached the destination.
| `Failed` | The payment failed. This can be due to various reasons.

## Mandate

### Processing a Mandate

```
TrueLayerPaymentsSDKWrapper.processMandate({
  mandateId: // Your mandate identifier,
  resourceToken: // Your mandate resource token,
  redirectUri: // Your redirect URI,
}).then(result => {
  switch (result.type) {
    case ResultType.Success:
      console.log(`processMandate success at step: ${result.step}`)
      break
    case ResultType.Failure:
      console.log(`processMandate failed with reason: ${result.reason}`)
      break
  }
})
```

The parameters used in `MandateContext` are explained below:

- `mandateId`: the mandate identifier retrieved from your backend.
- `resourceToken`: the mandate token retrieved from your backend.
- `redirectUri`: the destination where the user should be redirected once the authorization flow is done outside of the app (bank website, HPP). This is usually your app's redirect URI.

The parameters used in the `MandatePreferences` are explained below:

  - `preferredCountryCode`: the preferred country to use when displaying the providers. If the country is invalid, or does not include any providers, the value will fallback to the user's locale.

### Getting Mandate Status

In order to get the status of a mandate, the SDK offers the following method:

```
TrueLayerPaymentsSDKWrapper.mandateStatus(
  // Your mandate identifier,
  // Your mandate resource token
).then(result => {
  switch (result.type) {
    case ResultType.Success:
      console.log(`mandateStatus success: ${result.status}`)
      break
    case ResultType.Failure:
      console.log(`mandateStatus failed with the following reason: ${result.failure}`)
      break
  }
})
```

This should be treated as the favorite source of truth for the status of the mandate.

#### Status

| `MandateStatus` | Description |
| ------------- | ------------- 
| `AuthorizationRequired` | The mandate requires authorisation.
| `Authorizing` | The user is authorizing the mandate.
| `Authorized` | The user has authorized the mandate with their bank.
| `Revoked` | The mandate has been revoked and is no longer valid.
| `Failed` | The mandate failed. Click [here](https://docs.truelayer.com/docs/mandate-statuses#more-about-failed-mandates) for more information.

## Handling the `ProcessorResult`

The `processPayment` and `processMandate` methods return a `ProcessorResult` type. This contains `Success` and `Failure` cases, explained below.
 
#### Success

| `ProcessorStep` | Description |
| ------------- | ------------- 
| `Executed` | The bank confirmed the payment or mandate.
| `Authorized` | The user authorized the payment or mandate with the bank.
| `Redirect` | The user has been redirected to the bank to authorize the payment or mandate.
| `Settled` | The funds have reached the destination.
| `Wait` | The SDK flow is complete, but a decoupled authorisation action is still pending with the user and/or the bank.

#### Failure

| `FailureReason` | Description |
| ------------- | -------------
| `ProcessorContextNotAvailable` | The context provided to the SDK is invalid.
| `NoInternet` | There was an issue while connecting to the internet. Either the user is offline, or the request timed out.
| `CommunicationIssue` | There was an issue communicating with the server.
| `ConnectionSecurityIssue` | The token used to make the payment or mandate is not authorized to undergo such operation.
| `PaymentFailed` | The payment or mandate is in a failed state. Click here for more information: [payments](https://docs.truelayer.com/docs/payment-statuses-for-payments-v3#more-about-failed-payments) or [mandates](https://docs.truelayer.com/docs/mandate-statuses#more-about-failed-mandates).
| `WaitAbandoned` | The user abandoned the payment on the wait screen.
| `Unknown`| The `SDK` encountered an unexpected behavior.
| `UserAborted` | The user canceled the payment or mandate.
