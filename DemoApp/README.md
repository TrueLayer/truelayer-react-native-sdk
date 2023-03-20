# How to build and test the DemoApp

## Prerequisites

Since `yarn link/unlink` does not work with react-native. Install `yalc` globally. This is a tool that allows you to test local packages without publishing them to npm.
```
yarn add -g yalc
```

Build the SDK
```
// from the root of the project
// N.B these commands will need to be re-run if you make any changes to the SDK
cd RNTureLayerPaymentsSDK
yarn build
yalc publish
```

Install the SDK in the DemoApp
```
// from the root of the project
cd DemoApp
yalc add rn-truelayer-payments-sdk
```

## Run the DemoApp

```
// from the root of the project
cd DemoApp
yarn install
yarn start

// For iOS, from the root of the project
cd ios
pod install
cd ..
yarn ios
```


