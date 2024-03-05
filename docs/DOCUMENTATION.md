# Documentation

This a high level documentation on how to use the React Native TrueLayer SDK.

Once your app has obtained the payment (or mandate) identifier and resource token from the backend (see [Setup](../README.md)), you can use the React Native SDK to process the payment.

> Note: when processing a single payment or mandate, ensure the top-most view that is visible *remains* in memory. It should not be hidden or deallocated while the SDK is displayed. The iOS SDK keeps a reference to this view to dismiss itself when the flow is complete.

## Single Payment

### Creating a payment

Refer to our [payment-quickstart](https://github.com/TrueLayer/payments-quickstart)

### Processing a Single Payment

```typescript
TrueLayerPaymentsSDKWrapper.processPayment({
  paymentId: "", // Your payment ID,
  resourceToken: "", // Your payment token,
  redirectUri: "", // Your redirect URI,
}).then((result) => {
  switch (result.type) {
    case ResultType.Success:
      console.log(`processPayment success at step: ${result.step}`);
      break;
    case ResultType.Failure:
      console.log(`processPayment failure reason: ${result.reason}`);
      break;
  }
});
```

The parameters used in `PaymentContext` are explained below:

- `paymentId`: the payment identifier retrieved from your backend.
- `resourceToken`: the payment token retrieved from your backend.
- `redirectUri`: the destination where the user should be redirected once the authorization flow is done outside of the app (bank website, HPP). This is usually your app's redirect URI.

The parameters used in the `PaymentPreferences` are explained below:

- `preferredCountryCode`: the preferred country to use when displaying the providers. If the country is invalid, or does not include any providers, the value will fallback to the user's locale.
- `shouldPresentResultScreen`: true if the result screen should be presented before the final redirect to the merchant app. Default is true.
- `waitTimeMillis`: the total time the result screen will wait to get a final status of the payment. Default is 3 seconds. Minimum is 2 seconds. Maximum is 10 seconds.

### Handle redirects and display the payment result
At the end of a redirect flow the bank app will relaunch your app with the redirect-uri you provided on the console.

In your activity that launches when a deep link is triggered, you can fetch the redirect parameters from the url which will include the `payment_id`.

Whenever you are redirected to your app, you should reinvoke the SDK, until you receive a success or error callback.

By default the SDK offers a payment result screen, which displays the result of the payment and advises the user on what to do in case of a failed payment. If you disable the payment result screen, you can use the success or error callback to render a screen for your user when they return to your app.

### 1.x.x to 2.0.0 migration Guide
The `paymentUseCase` has been deprecated and now payments must be configured for SignUp+ on creation with the `related_products.signup_plus` property.

### Getting Payment Status

In order to get the status of a payment, the SDK offers the following method:

```typescript
TrueLayerPaymentsSDKWrapper.paymentStatus({
  paymentId: "", // Your payment ID,
  resourceToken: "", // Your payment token
}).then((result) => {
  switch (result.type) {
    case ResultType.Success:
      console.log(`paymentStatus success with status: ${result.status}`);
      break;
    case ResultType.Failure:
      console.log(
        `paymentStatus failed with the following reason: ${result.failure}`
      );
      break;
  }
});
```

This should be treated as the favorite source of truth for the status of the payment.

#### Status

| `PaymentStatus`         | Description                                             |
| ----------------------- | ------------------------------------------------------- |
| `AuthorizationRequired` | The payment requires authorisation.                     |
| `Authorizing`           | The user is authorizing the payment.                    |
| `Authorized`            | The payment has been authorized by the bank.            |
| `Executed`              | The payment has been executed.                          |
| `Settled`               | The funds have reached the destination.                 |
| `Failed`                | The payment failed. This can be due to various reasons. |

## Mandate

### Processing a Mandate

```typescript
TrueLayerPaymentsSDKWrapper.processMandate({
  mandateId: "", // Your mandate identifier,
  resourceToken: "", // Your mandate resource token,
  redirectUri: "", // Your redirect URI,
}).then((result) => {
  switch (result.type) {
    case ResultType.Success:
      console.log(`processMandate success at step: ${result.step}`);
      break;
    case ResultType.Failure:
      console.log(`processMandate failed with reason: ${result.reason}`);
      break;
  }
});
```

The parameters used in `MandateContext` are explained below:

- `mandateId`: the mandate identifier retrieved from your backend.
- `resourceToken`: the mandate token retrieved from your backend.
- `redirectUri`: the destination where the user should be redirected once the authorization flow is done outside of the app (bank website, HPP). This is usually your app's redirect URI.

The parameters used in the `MandatePreferences` are explained below:

- `preferredCountryCode`: the preferred country to use when displaying the providers. If the country is invalid, or does not include any providers, the value will fallback to the user's locale.
- `shouldPresentResultScreen`: true if the result screen should be presented before the final redirect to the merchant app. Default is true.
- `waitTimeMillis`: the total time the result screen will wait to get a final status of the payment. Default is 3 seconds. Minimum is 2 seconds. Maximum is 10 seconds.

### Handle redirects and display the mandate result
At the end of a redirect flow the bank app will relaunch your app with the redirect-uri you provided on the console.

In your activity that launches when a deep link is triggered, you can fetch the redirect parameters from the url which will include the `mandate_id`.

Whenever you are redirected to your app, you should reinvoke the SDK, until you receive a success or error callback.

By default the SDK offers a mandate result screen, which displays the result of the mandate and advises the user on what to do in case of a failed mandate. If you disable the mandate result screen, you can use the success or error callback to render a screen for your user when they return to your app.

### Getting Mandate Status

In order to get the status of a mandate, the SDK offers the following method:

```typescript
TrueLayerPaymentsSDKWrapper.mandateStatus({
  mandateId: "", // Your mandate identifier,
  resourceToken: "", // Your mandate resource token,
}).then((result) => {
  switch (result.type) {
    case ResultType.Success:
      console.log(`mandateStatus success: ${result.status}`);
      break;
    case ResultType.Failure:
      console.log(
        `mandateStatus failed with the following reason: ${result.failure}`
      );
      break;
  }
});
```

This should be treated as the favorite source of truth for the status of the mandate.

#### Status

| `MandateStatus`         | Description                                                                                                                         |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `AuthorizationRequired` | The mandate requires authorisation.                                                                                                 |
| `Authorizing`           | The user is authorizing the mandate.                                                                                                |
| `Authorized`            | The user has authorized the mandate with their bank.                                                                                |
| `Revoked`               | The mandate has been revoked and is no longer valid.                                                                                |
| `Failed`                | The mandate failed. Click [here](https://docs.truelayer.com/docs/mandate-statuses#more-about-failed-mandates) for more information. |

## Handling the `ProcessorResult`

The `processPayment` and `processMandate` methods return a `ProcessorResult` type. This contains `Success` and `Failure` cases, explained below.

#### Success

| `ProcessorStep` | Description                                                                                                    |
| --------------- | -------------------------------------------------------------------------------------------------------------- |
| `Executed`      | The bank confirmed the payment or mandate.                                                                     |
| `Authorized`    | The user authorized the payment or mandate with the bank.                                                      |
| `Redirect`      | The user has been redirected to the bank to authorize the payment or mandate.                                  |
| `Settled`       | The funds have reached the destination.                                                                        |
| `Wait`          | The SDK flow is complete, but a decoupled authorisation action is still pending with the user and/or the bank. |

#### Failure

| `FailureReason`                | Description                                                                                                                                                                                                                                                                       |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ProcessorContextNotAvailable` | The context provided to the SDK is invalid.                                                                                                                                                                                                                                       |
| `NoInternet`                   | There was an issue while connecting to the internet. Either the user is offline, or the request timed out.                                                                                                                                                                        |
| `CommunicationIssue`           | There was an issue communicating with the server.                                                                                                                                                                                                                                 |
| `ConnectionSecurityIssue`      | The token used to make the payment or mandate is not authorized to undergo such operation.                                                                                                                                                                                        |
| `PaymentFailed`                | The payment or mandate is in a failed state. Click here for more information: [payments](https://docs.truelayer.com/docs/payment-statuses-for-payments-v3#more-about-failed-payments) or [mandates](https://docs.truelayer.com/docs/mandate-statuses#more-about-failed-mandates). |
| `WaitAbandoned`                | The user abandoned the payment on the wait screen.                                                                                                                                                                                                                                |
| `Unknown`                      | The `SDK` encountered an unexpected behavior.                                                                                                                                                                                                                                     |
| `UserAborted`                  | The user canceled the payment or mandate.                                                                                                                                                                                                                                         |
| `ProviderOffline`                  | The pre-selected provider was offline.                                                                                                                                                                                                                                   |
| `InvalidRedirectURI`                  | The redirect URI passed to the SDK is invalid.                                                                                                                                                                                                                                   |
## Customising the UI
You can customise the colors and fonts used within the SDK. Customisation options are unique for iOS and Android and must be passed when processing a payment or mandate.

### Android
Customising the look of the SDK on Android devices requires passing a theme with the following options.

```
const androidTheme =  {
  lightColors: {
    primary: "#FF32a852",
    background: "#888888",
    surface: "#888888",
    error: "#000000"
  },
  darkColors: {
    primary: "#888888",
    background: "#000000",
    error: "#cccccc"
  },
  typography: {
    bodyLarge: {
      font: "rainbow_2000"
    }
  }
}

const theme =  {
  android: androidTheme
}
```

That theme is then provided to the configure method.
```
TrueLayerPaymentsSDKWrapper.configure(Environment.Sandbox, theme).then(
  () => {
    log('Configure success')
  },
  reason => {
    log('Configure failed ' + reason)
  },
)
```

Colors require a hexcode and supports both `RGB` and `ARGB`.

Fonts support both `.ttf` and `.otf` formats and must be placed in the `android/app/src/main/res/font` folder. The file must be named in snake case to be recognised. Then you simply use the name of the file (without the extension) in your theme object.

### iOS
Customising the look of the SDK on iOS devices requires passing a theme with the following options.

```
const iOSTheme =  {
  lightColors: {
    backgroundPrimary: "#131313",
    ...
  },
  darkColors: {
    contentSecondary: "#ABABAB",
    ...
  },
  fontFamilyName: "Kanit"
}

const theme =  {
  ios: iOSTheme,
}
```

That theme is then provided to the configure method.
```
TrueLayerPaymentsSDKWrapper.configure(Environment.Sandbox, theme).then(
  () => {
    log('Configure success')
  },
  reason => {
    log('Configure failed ' + reason)
  },
)
```

Colors are expected to be a hexcode. They may start with the pound sign (#) but that is not necessary. It supports hexcodes of 3, 4 and 6 digits.

The font (.ttf) should be added to the project and referenced in the `.plist` file, and then only the family name should be passed to the SDK. In case the SDK fails to fetch it it will fallback to the native iOS font.
