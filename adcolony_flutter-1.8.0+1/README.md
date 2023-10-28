# AdColony Flutter Plugin Documentation

The AdColony Flutter plugin provides integration with the AdColony advertising platform for Flutter applications. This plugin allows you to display interstitial and rewarded video ads, as well as banners, in your Flutter app.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Initialization](#initialization)
  - [Requesting and Showing Ads](#requesting-and-showing-ads)
  - [Banner Ads](#banner-ads)
- [API Reference](#api-reference)
  - [AdColony](#adcolony)
  - [AdColonyOptions](#adcolonyoptions)
  - [AdColonyAdListener](#adcolonyadlistener)
  - [BannerView](#bannerview)
  - [BannerSizes](#bannersizes)
  - [BannerController](#bannercontroller)

## Installation

To use the AdColony Flutter plugin in your Flutter project, follow these steps:

1. Add the `adcolony_flutter` dependency to your `pubspec.yaml` file:

   ```yaml
   dependencies:
     adcolony_flutter: ^1.8.0
   ```

2. Run `flutter pub get` to fetch the plugin dependencies.

3. Import the AdColony Flutter plugin in your Dart code:

   ```dart
   import 'package:adcolony_flutter/adcolony_flutter.dart';
   ```

## Usage

### Initialization

Before using any features of the AdColony plugin, you need to initialize it with your AdColony app ID, GDPR consent string, and zone IDs. You should call the `AdColony.init()` method with an instance of `AdColonyOptions` containing the required configuration.

Example initialization:

```dart
AdColony.init(AdColonyOptions('app4f4659d279be4554ad', '0', ['zoneId1', 'zoneId2']));
```

Make sure to replace `'app4f4659d279be4554ad'` with your AdColony app ID, `'0'` with your GDPR consent string, and `['zoneId1', 'zoneId2']` with the list of zone IDs relevant to your application.

### Requesting and Showing Ads

To request and show ads, use the `AdColony.request()` method. Pass the desired zone ID and an optional listener callback function.

Example requesting an interstitial ad:

```dart
AdColony.request('zoneId1', (AdColonyAdListener? event, int? reward) {
  if (event == AdColonyAdListener.onRequestFilled) {
    if (AdColony.isLoaded()) {
      AdColony.show();
    }
  }
  if (event == AdColonyAdListener.onReward) {
    // Handle rewarded ad completion
  }
});
```

Replace `'zoneId1'` with the appropriate zone ID for the ad you want to display. You can handle different events, such as `onRequestFilled` and `onReward`, according to your requirements.

### Banner Ads

To display banner ads in your Flutter app, use the `BannerView` widget. Provide the necessary parameters, including the listener callback and the desired banner size.

Example usage of `BannerView`:

```dart
BannerView(
  listener,
  BannerSizes.banner,
  'zoneId2',
  onCreated: (BannerController controller) {
    // Optional: Perform actions when the banner is created
  },
)
```

Replace `'zoneId2'` with the relevant zone ID for the banner ad. The `listener` is the callback function for handling ad events, and `onCreated` is an optional callback function triggered when the banner is created.

## API Reference

### AdColony

The main class of the AdColony Flutter plugin. It provides methods for initializing the plugin, requesting and showing ads, and checking ad availability.

**Methods:**

- `init(AdColonyOptions options)`: Initializes the AdColony plugin with the provided options.
- `request(String zone, AdColonyListener listener)`: Requests an ad for the specified zone ID.
- `show()`: Shows the currently loaded ad.
- `isLoaded()`: Checks if an ad is currently loaded.

### AdColonyOptions

Represents the configuration options for initializing the AdColony plugin.

**Constructor:**

- `AdColonyOptions(String id, String gdpr, List<String> zones)`: Creates an instance of `AdColonyOptions` with the provided app ID, GDPR consent string, and zone IDs.

### AdColonyAdListener

An enum representing various ad event types. These events can be used to handle different ad-related actions.

**Events:**

- `onRequestFilled`
- `onRequestNotFilled`
- `onReward`
- `onOpened`
- `onClosed`
- `onIAPEvent`
- `onExpiring`
- `onLeftApplication`
- `onClicked`

### BannerView

A widget for displaying banner ads in your Flutter app.

**Constructor:**

- `BannerView(

AdColonyListener? listener, BannerSizes size, String id, {required BannerCreatedCallback onCreated})`: Creates a `BannerView` widget with the specified parameters.

**Properties:**

- `listener`: The callback function for handling ad events.
- `size`: The size of the banner ad (one of `BannerSizes.banner`, `BannerSizes.leaderboard`, `BannerSizes.skyscraper`, `BannerSizes.medium`).
- `id`: The zone ID for the banner ad.
- `onCreated`: An optional callback function triggered when the banner is created.

### BannerSizes

An enum representing different banner ad sizes.

**Sizes:**

- `banner`
- `leaderboard`
- `skyscraper`
- `medium`

### BannerController

A controller class for managing banner ads.

**Methods:**

- `loadAd()`: Loads the banner ad.

**Troubleshooting:**
If you encounter any issues while integrating or using the AdColony Flutter plugin, refer to the official AdColony documentation for guidance.

**Note:**
This plugin is not affiliated with or endorsed by AdColony.
Make sure to replace the app keys, zone IDs, and other placeholders with your own values.
Listeners may not work properly on all devices and OS versions.

**TODO:**
Support for banner ads on iOS.
Improve listeners to work consistently across all platforms.
