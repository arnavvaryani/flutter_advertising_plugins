# flutter_tapresearch

A Flutter plugin for the **TapResearch SDK 3.x** (content, surveys & rewards) on Android & iOS.

> **v2.0.0 is a breaking change.** It migrates from the legacy 2.x placement /
> survey-wall API to the 3.x content model. See the [CHANGELOG](CHANGELOG.md)
> for the full migration notes.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_tapresearch: "<LATEST_VERSION>"
```

```sh
flutter pub get
```

### Android

The TapResearch Android SDK is hosted on a custom Artifactory (not Maven
Central). The plugin's `build.gradle` already adds the repository; no extra app
configuration is required. Requirements: `minSdkVersion 23`, `compileSdk 35`.

Add to your ProGuard rules before releasing:

```sh
-keep class com.tapresearch.** { *; }
-keep interface com.tapresearch.** { *; }
```

### iOS

Requires iOS 12.0+. This plugin integrates via **Swift Package Manager** (no
CocoaPods). Make sure SPM is enabled for your app:

```sh
flutter config --enable-swift-package-manager
```

Flutter then resolves the TapResearch iOS SDK (`TapResearchSDK`) from its Swift
package automatically — no `pod install` step.

## Usage

```dart
import 'package:flutter_tapresearch/flutter_tapresearch.dart';

final tr = TapResearch.instance;

// Register listeners BEFORE initialize so early callbacks aren't missed.
tr.setRewardsListener((rewards) {
  for (final r in rewards) {
    // Credit the user. Use r.transactionIdentifier to de-duplicate.
    print('Got ${r.rewardAmount} ${r.currencyName}');
  }
});
tr.setSdkReadyListener(() => print('SDK ready'));
tr.setErrorListener((error) => print('Error: $error'));

// Both token and user identifier are required by the 3.x SDK.
await tr.initialize(apiToken: 'YOUR_API_TOKEN', userIdentifier: 'user-123');

// Show content for a placement tag (after the SDK is ready).
if (await tr.canShowContentForPlacement('my_placement')) {
  await tr.showContentForPlacement('my_placement');
}
```

See [`example/lib/main.dart`](example/lib/main.dart) for a complete app.

## Bundled SDK versions

| Platform | Dependency | Version |
|---|---|---|
| Android | `com.tapresearch:tapsdk` | `3.7.2` |
| Android | Android Gradle Plugin | `8.1.0` |
| iOS | `TapResearchSDK` (Swift Package) | `3.8.0--beta03` |

> Requirements: Android `minSdk 23` / `compileSdk 35`, iOS `12.0+`, Flutter `3.24+`.
> The iOS package currently exposes only a beta SPM tag; bump to a stable tag
> once one is published.

| Method | Description |
|---|---|
| `initialize({apiToken, userIdentifier})` | Initialize the SDK (both required). |
| `isReady()` | Whether the SDK finished initializing. |
| `canShowContentForPlacement(tag)` | Whether content is available for a tag. |
| `showContentForPlacement(tag, {customParameters})` | Present content. |
| `setUserIdentifier(id)` | Update the user identifier after init. |
| `sendUserAttributes(map)` | Send custom targeting attributes. |
| `setRewardsListener` / `setSdkReadyListener` / `setErrorListener` / `setContentShownListener` / `setContentDismissedListener` | Register callbacks. |

## Issues & Pull Requests

Please file issues and PRs at
[github.com/arnavvaryani/flutter_advertising_plugins](https://github.com/arnavvaryani/flutter_advertising_plugins).
