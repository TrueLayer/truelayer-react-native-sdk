
# react-native-true-layer-payments-sdk

## Getting started

`$ npm install react-native-true-layer-payments-sdk --save`

### Mostly automatic installation

`$ react-native link react-native-true-layer-payments-sdk`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-true-layer-payments-sdk` and add `RNTrueLayerPaymentsSdk.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNTrueLayerPaymentsSdk.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.truelayer.payments.RNTrueLayerPaymentsSdkPackage;` to the imports at the top of the file
  - Add `new RNTrueLayerPaymentsSdkPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-true-layer-payments-sdk'
  	project(':react-native-true-layer-payments-sdk').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-true-layer-payments-sdk/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-true-layer-payments-sdk')
  	```


## Usage
```javascript
import RNTrueLayerPaymentsSdk from 'react-native-true-layer-payments-sdk';

// TODO: What to do with the module?
RNTrueLayerPaymentsSdk;
```
  