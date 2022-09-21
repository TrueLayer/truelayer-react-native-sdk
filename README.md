# truelayer-react-native-sdk
React Native SDK for TrueLayer
## Installation

```sh
npm install truelayer-react-native-sdk --save
```

## Usage

```js
import TrueLayerSDK from "truelayer-react-native-sdk";

// ...

const paymentResult = await TruelayerSDK.startPayment(
    PAYMENT_ID,
    RESOURCE_TOKEN,
    'truelayer://react-native-example',
    {
        preferredCountryCode: 'DE',
    },
);

const {result, reason, step} = paymentResult.data;
```

## Example App
The project contains an example app you can run to test the SDK. 

To test the full payment flow you'll need to add `truelayer://react-native-example` to your redirect URIs in your TrueLayer console.

### API Setup
This app uses our [Payments Quickstart API](https://github.com/TrueLayer/payments-quickstart) to simplify the process of creating payments 
and retrieving their status. You will need to setup your own installation of this project to use this app.
Payments Quickstart is a project that will allow you to instantly get up to speed with SDK integration without a need for your own backend to be ready.

>Beware this project is meant to be used for testing only, and the functionality behind (or at least part of it) will need to be implemented on your own backend service.

Add the URL to your local Payments Quickstart API to the config object in the `App.tsx` file in the example project.

### Configuration
The example project can be configured to different payment types by updating the config object in the `App.tsx` file.

```
const config = {
  api: 'http://10.0.2.2:3000',
  paymentType: "eur", // [gbp, eur, preselected]
}
```

To run the app start the Metro server in a terminal.
```
yarn example start
```

In a separate terminal window run the following commands to start either the Android or iOS app.
```
yarn example android

yarn example ios
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
