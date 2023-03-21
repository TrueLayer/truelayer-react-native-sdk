# How to build and test the DemoApp

## Prerequisites

Since `yarn link/unlink` does not work with react-native. Install [yalc](https://www.npmjs.com/package/yalc) globally. This is a tool that allows you to test local packages without publishing them to npm.

// from the root of the project
// N.B these commands will need to be re-run if you make any changes to the SDK
cd RNTureLayerPaymentsSDK
yarn build
npx yalc publish

// you may be prompted to install a yalc package if so then accept the installation and rerun the above yalc command
```

Install the SDK in the DemoApp
```
// from the root of the project
cd DemoApp
npx yalc add rn-truelayer-payments-sdk
```

## Run the DemoApp

```
// from the root of the project
cd DemoApp
yarn install
yarn start

// For iOS, from the root of the project
cd ios
**NEW REACT ARCHITECTURE**: RCT_NEW_ARCH_ENABLED=1 bundle exec pod install
**OLD REACT ARCHITECTURE**: pod install
cd ..
yarn ios
```


