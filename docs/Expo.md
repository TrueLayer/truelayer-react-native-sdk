## Integration example

An integration example can be found in the `ExpoDemoApp`. This exaple is limitted only to the SDK initialization, but presents how the SDK needs to be integrated into the project.
The full example of how the SDK can be used can be found in the pure react-native `DemoApp`.

## Updating build scripts

In your `app.json` file you need to add the following configuration for `expo-build-properties`

```json
{
  "expo": {
    "plugins": [
      [
        "expo-build-properties",
        {
          "android": {
            "compileSdkVersion": 35,
            "targetSdkVersion": 35,
            "buildToolsVersion": "35.0.0",
            "kotlinVersion": "1.9.25",
            "packagingOptions": {
              "pickFirst": ["META-INF/LICENSE-MIT"],
              "excludes" : "/META-INF/{AL2.0,LGPL2.1}"
            }
          }
        }
      ],
      // This is just an exaple how you can add a custom plugin
      // should you wish to use the Automatic gradle script updates.
      // This is explained futher down in this document.
      [
        "./plugins/withCustomAppBuildGradle.js"
      ]
    ]        
  }
}
```

For the above to work you need to have `expo-build-properties` package installed. If you don't, install it with:

`npx expo install expo-build-properties`

## Updating Android gradle scripts

There are two ways of updating the scripts

### Manual

Update the `android/app/build.gradle` to contain the elements below

```groovy
android {
    // this part will enable core library desugaing
    compileOptions {
        coreLibraryDesugaringEnabled true
    }
}

dependencies {
    // Add to your projects `build.gradle`.
    // We are currently using following version of desuga libraries
    coreLibraryDesugaring "com.android.tools:desugar_jdk_libs:2.1.3"
}
```

### Automatic

Use a custom plugin for your `app.json`. An example script and setup can be found in the `ExpoDemoApp`. Exaple plugin is [here](../ExpoDemoApp/plugins/withCustomAppBuildGradle.js)

## Using the SDK with Expo

The React Native SDK is a wrapper around a native mobile TrueLayer Payments SDK. It is not possible to use it with Expo for web.
It is also not possible to use the SDK within the Expo Go app. To test the SDK, you must build the Android and iOS apps.
You can do that by running the following commands:

For Android
```text
npx expo prebuild
npx expo run android
```
For iOS
```text
npx expo prebuild
npx expo run ios
```