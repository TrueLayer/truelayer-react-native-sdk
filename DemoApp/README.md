# Building and Testing the DemoApp

## Prerequisites

Since `yarn link/unlink` doesn't work with React Native, you need to install
[yalc](https://www.npmjs.com/package/yalc). Yalc is a tool that enables
you to test local packages without publishing them to npm.

```sh
npx yalc --version
```

You may be prompted to install yalc. If so, accept the installation and then continue with the steps below.

## To install and publish the SDK using yalc, follow these steps:

1. Navigate to the root of the RNTrueLayerPaymentsSDK project:

```sh
cd RNTrueLayerPaymentsSDK
yarn install
yarn build
```

2. Publish the project using yalc:

```sh
npx yalc publish
```

3. Build and watch for changes in the SDK project:

```sh
yarn yalc:watch
```

If you are prompted to install a yalc package, accept the installation and rerun
the `yarn yalc:watch` command.

## To install the SDK in the DemoApp, follow these steps:

1. Navigate to the root of the DemoApp project:

```sh
cd DemoApp
```

2. Add the SDK using yalc:

```sh
npx yalc add rn-truelayer-payments-sdk
```

## Running the DemoApp

1. Navigate to the root of the DemoApp project:

```sh
cd DemoApp
```

2. Install the dependencies:

```sh
yarn install
```

3. Start the development server:

```sh
yarn start
```

4. For iOS, navigate to the ios directory from the root of the DemoApp project:

```sh
cd ios
```

5. Install the necessary pods:

- For the new React architecture
  ```sh
  RCT_NEW_ARCH_ENABLED=1 bundle exec pod install
  ```



- For the old React architecture:
  ```sh
  pod install
  ```

6. Navigate back to the root of the DemoApp project and run the DemoApp on iOS:
```sh
yarn ios
```
