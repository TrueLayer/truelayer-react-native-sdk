# CHANGELOG
All notable changes to this project will be documented in this file. To know better on how to write and maintain a changelog, refer to [this link](https://keepachangelog.com/en/1.0.0/).

## [2.3.0]

### Changed

- Updated the underlying Android SDK to version [3.9.0](https://docs.truelayer.com/docs/android-sdk-release-history).
- Updated the underlying iOS SDK to version [3.9.0](https://docs.truelayer.com/docs/ios-sdk-release-history).

## [2.2.1]

### Changed

- Updated the underlying Android SDK to version [3.2.2](https://docs.truelayer.com/docs/android-sdk-release-history).
- Updated the underlying iOS SDK to version [3.2.2](https://docs.truelayer.com/docs/ios-sdk-release-history).

## [2.2.0]

### Changed

- Updated the underlying iOS SDK to version [3.2.1](https://github.com/TrueLayer/TrueLayer-iOS-SDK/releases/tag/3.2.1).
- Updated the underlying Android SDK to version [3.2.1](https://docs.truelayer.com/docs/android-sdk-release-history).

## [2.1.0]

### Added

The `ProcessorResult` type has new property `resultShown`. If you are using the result screen has been show to the user as a part of the payment flow, whe `resultShown` property will indicate what user have seen.

### Changed

- Updated the underlying iOS SDK to version [3.1.0](https://github.com/TrueLayer/TrueLayer-iOS-SDK/releases/tag/3.1.0).
- Updated the underlying Android SDK to version [3.1.0](https://docs.truelayer.com/docs/android-sdk-release-history).

## [2.0.0]

### Added

- `shouldPresentResultScreen` to `PaymentPreferences` and `MandatePreferences`. When this is enabled, a result screen is displayed at the end of the authorization flow. When the user is redirected back from the bank, it is recommended to re-invoke the SDK to display the result screen, to show the user the status of their payment or mandate. This is enabled by default.
- `waitTimeMillis` to `PaymentPreferences` and `MandatePreferences`. This is the maximum timeout for the payment or mandate result screen, until a final status. Once reached, the user is shown a button to dismiss the SDK and return to your app.
- New `FailureReason` cases. These more accurately reflect the reasons returned from TrueLayer Payments API V3.

### Changed

- Updated the underlying iOS SDK to version [3.0.1](https://github.com/TrueLayer/TrueLayer-iOS-SDK/releases/tag/3.0.1).
- Updated the underlying Android SDK to version [3.0.1](https://docs.truelayer.com/docs/android-sdk-release-history).

### Removed

- `paymentUseCase` from `PaymentPreferences`. To enable Signup+ for a payment, refer to the API documentation when creating a payment.

## [1.4.0]

### Changed

- Updated the underlying iOS SDK to version [2.7.1](https://github.com/TrueLayer/TrueLayer-iOS-SDK/releases/tag/2.7.1).
- Updated the underlying Android SDK to version [2.6.0](https://docs.truelayer.com/docs/android-sdk-release-history).


## [1.3.1]

### Added

- New error `InvalidRedirectURI`.

### Fixed

- Compiltation errors when compiling the iOS SDK.

## [1.3.0]

### Added

- New error `ProviderOffline` when a provider is unavailable.

### Changed

- Updated the underlying iOS SDK to version [2.5.0](https://github.com/TrueLayer/TrueLayer-iOS-SDK/releases/tag/2.5.0).
- Updated the underlying Android SDK to version [2.4.0](https://docs.truelayer.com/docs/android-sdk-release-history).

### Fixed

- Error when running version 1.1.0 ([#35](https://github.com/TrueLayer/truelayer-react-native-sdk/issues/35)).

## [1.2.0]

### Added

- Support for Signup+.

### Changed

- Updated export for typescript types
- Android SDK support target lowered to API level 21. Please check the [readme](README.md) for an extra, mandatory `build.gradle` setup to avoid crashes.
- Updated the underlying iOS SDK to version [2.4.0](https://github.com/TrueLayer/TrueLayer-iOS-SDK/releases/tag/2.4.0).
- Updated the underlying Android SDK to version [2.3.0](https://docs.truelayer.com/docs/android-sdk-release-history).


## [1.1.0]

### Added

- Support for color customisation on iOS and Android.
- Support for font customisation on iOS and Android.

### Changed

- Updated the underlying iOS SDK to version [2.3.0](https://github.com/TrueLayer/TrueLayer-iOS-SDK/releases/tag/2.3.0).
- Updated the underlying Android SDK to version [2.2.1](https://docs.truelayer.com/docs/android-sdk-release-history).

## [1.0.0]

### Added
- Support for single payment processing
- Support for mandate processing
- Support for single payment status
- Support for mandate status
- Support for the following languages:
  - Dutch
  - English
  - Finnish
  - French
  - German
  - Italian
  - Polish
  - Portuguese
  - Spanish
