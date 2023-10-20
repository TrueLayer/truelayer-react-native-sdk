# TrueLayer Payments SDK

TrueLayer's React Native SDK allows you to quickly add open banking payments to your app. The SDK integrates with TrueLayer's Payments API, making it simple to get up and running.

The SDK presents native screens that allow your users to select their bank and consent to the payment. The user is then redirected to their banking app or website to authorise the payment. It also handles the network requests and errors.

## Table of Contents

1. [How to Install the SDK](#how-to-install-the-sdk)
2. [Setup](#setup)
   1. [Prerequisites](#prerequisites)
      1. [Setting Up Your Backend](#setting-up-your-backend)
      2. [Minimum Versions](#minimum-versions)
   2. [Android specific setup](#android-specific-setup)
   3. [Additional setup to use the SDK with Expo](#additional-setup-to-use-the-sdk-with-expo)
   4. [Using the SDK with Expo](#using-the-sdk-with-expo)
3. [How to Use the SDK](#how-to-use-the-sdk)
4. [How to setup the DemoApp](#how-to-setup-the-demoapp)

## How to Install the SDK

Using Yarn:

`yarn add rn-truelayer-payments-sdk`

Using npm:

`npm install rn-truelayer-payments-sdk --save`

In your iOS folder, run the Cocoapods install command:

- If using the [New Architecture](https://reactnative.dev/docs/new-architecture-intro), run:

	```
	RCT_NEW_ARCH_ENABLED=1 bundle exec pod install
	```
- If using the old architecture, run:

	```
	bundle exec pod install
	```

## Setup

### Prerequisites

#### Setting Up Your Backend

- Create an account in the [TrueLayer console](https://console.truelayer.com/).
  Follow [this guide](https://docs.truelayer.com/docs/get-started-with-truelayer) to set it up correctly.

- You need a backend which is able to retrieve an access token and create a payment on behalf of the user. This is to enforce security on the client, avoiding the need to store static secrets in your app. The API documentation can be found [here](https://docs.truelayer.com/).

Finally, your app should setup a payment. Once the payment has been setup, it is possible to delegate all the remaining parts of the process to the SDK. To set up a payment, the backend should:

1. [Authenticate with TrueLayer](https://docs.truelayer.com/docs/retrieve-a-token-in-your-server-for-payments-v3).
2. [Create a Payment](https://docs.truelayer.com/docs/single-payments-for-payments-v3).
3. Return the payment identifier and the resource token to the app.

#### Payments Quickstart

Alternatively, you can use our [open source server](https://github.com/TrueLayer/payments-quickstart).

#### Minimum Versions

- Xcode 14.x and iOS 14.0.
- Android 5.0 (API level 21)

### Android specific setup

Enable Core Library Desugaring and update packing options to remove excess LICENSE-MIT files.

In order to be able to run on API level below 26 the SDK requires your application to have core library desugaring enabled. Without this the SDK will crash. 

```groovy
android {
    // this part will enable core library desugaing
    compileOptions {
        coreLibraryDesugaringEnabled true
    }
    
    // this part will remove excess LICENSE-MIT files
    packagingOptions {
        resources {
            pickFirsts += ['META-INF/LICENSE-MIT']
        }
    }
}

dependencies {
    // Add to your projects `build.gradle`.
    // We are currently using following version of desuga libraries
    coreLibraryDesugaring "com.android.tools:desugar_jdk_libs:1.2.2"
}
```

### Additional setup to use the SDK with Expo

In your `app.json` file you need to add the following configuration for `expo-build-properties`

```json
{
  "expo": {
    "plugins": [
      [
        "expo-build-properties",
        {
          "android": {
            "compileSdkVersion": 33,
            "targetSdkVersion": 33,
            "buildToolsVersion": "33.0.0",
            "packagingOptions": {
              "exclude": ["META-INF/LICENSE-MIT"]
            }
          },
          "ios": {
            "deploymentTarget": "14.0"
          }
        }
      ]
    ]        
  }
}
```

### Using the SDK with Expo

The React Native SDK is a wrapper around a native mobile TrueLayer Payments SDK. It is not possible to use it with Expo for web.
It is also not possible to use the SDK withing Expo Go app. In order to test the SDK you will have to build the Android and iOS app.
You can do that by running the following commands:

For Android
```text
npx expo prebuild
npx expo run:android
```
For iOS
```text
npx expo prebuild
npx expo run:ios
```

## How to Use the SDK

1.  Import the SDK:

```typescript
import {
  TrueLayerPaymentsSDKWrapper,
  Environment,
  PaymentUseCase,
  ResultType,
} from "rn-truelayer-payments-sdk";
```

2.  Configure the SDK with the given environment (`Environment.Sandbox` or `Environment.Production`):

```typescript
TrueLayerPaymentsSDKWrapper.configure(Environment.Sandbox).then(
  () => {
    console.log("Configure success");
  },
  (reason) => {
    console.log("Configure failed " + reason);
  }
);
```

3.  Checkout [Documentation](docs/DOCUMENTATION.md).


## How to setup the DemoApp
Go to [DemoApp](DemoApp/README.md) for more information.
