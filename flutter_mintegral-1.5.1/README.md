# flutter_mintegral

A Flutter plugin for the **Mintegral (Mobvista)** ad SDK — direct integration
(not via AdMob mediation). Supports **rewarded video, interstitial, banner, and
splash** ad formats.

> **Android only for now.** A native iOS implementation (via Swift Package
> Manager) is planned for a follow-up release; the iOS side is currently a stub.

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

## Issues & Pull Requests

Please file issues and PRs at
[github.com/arnavvaryani/flutter_advertising_plugins](https://github.com/arnavvaryani/flutter_advertising_plugins).
iOS support contributions are especially welcome.
