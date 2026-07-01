# flutter_mintegral

A Flutter plugin for the **Mintegral (Mobvista)** ad SDK — direct integration
(not via AdMob mediation). Supports **rewarded video, interstitial, banner, and
splash** ad formats on **Android and iOS**.

## Getting started

```yaml
dependencies:
  flutter_mintegral: ^2.0.0
```

### Android setup

The Mintegral SDK is hosted on Mintegral's own Maven repository (not Maven
Central). The plugin's `build.gradle` already declares it; no extra app-level
configuration is required. Requirements: `minSdkVersion 23`, `compileSdk 35`.

### Usage

```dart
import 'package:flutter_mintegral/flutter_mintegral.dart';

await Mintegral.instance.initialize(
  appId: 'YOUR_APP_ID',
  appKey: 'YOUR_APP_KEY',
  onInitSuccess: () => print('Mintegral ready'),
  onInitFail: (error) => print('Init failed: $error'),
);
```

See `example/` for rewarded, interstitial, banner, and splash usage.

## Bundled SDK versions

| Platform | Dependency | Version |
|---|---|---|
| Android | `com.mbridge.msdk.oversea:reward` / `mbbid` / `mbsplash` / `mbbanner` / `newinterstitial` | `16.9.91` |
| Android | `androidx.appcompat:appcompat` | `1.6.1` |
| Android | `androidx.recyclerview:recyclerview` | `1.3.2` |
| Android | Android Gradle Plugin | `8.1.0` |
| iOS | `MintegralAdSDK` (Swift Package) | `8.1.5` |

> Android and iOS Mintegral SDKs are versioned independently (16.x vs 8.x).
> Requirements: Android `minSdk 23` / `compileSdk 35`, iOS `12.0+`, Flutter `3.24+`.

### iOS setup

Requires iOS 12.0+. The plugin integrates via **Swift Package Manager** (the
Mintegral SDK is distributed as a Swift package). Enable SPM in your app:

```sh
flutter config --enable-swift-package-manager
```

The plugin's `Package.swift` declares the required `-ObjC` linker flag. For App
Store submission you must also configure SKAdNetwork IDs and an
`NSUserTrackingUsageDescription` (ATT) per Mintegral's iOS integration guide.

## Issues & Pull Requests

Please file issues and PRs at
[github.com/arnavvaryani/flutter_advertising_plugins](https://github.com/arnavvaryani/flutter_advertising_plugins).
iOS support contributions are especially welcome.
