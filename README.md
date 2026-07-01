# Flutter Advertising Plugins

This repo contains the source code for Flutter plugins for various mobile ad-networks and monetization SDKs, developed by Arnav Varyani.

Flutter plugins enable access to platform-specific APIs using a platform channel.
For more information about plugins, and how to use them, see
[https://flutter.io/platform-plugins/](https://flutter.io/platform-plugins/).

## Plugin status

The underlying SDKs these plugins wrap have changed over time — some vendors now
ship their own official Flutter plugins, some SDKs have been deprecated, and others
have been acquired or rebranded. The table below reflects the current status
(as of mid-2026) so you can pick the right integration path.

| Plugin | SDK status | Owner | Official Flutter plugin? | Recommendation |
|---|---|---|---|---|
| `flutter_tapresearch` / `trsurveys` | ✅ Active (Android SDK updated 2026) | TapResearch (independent) | ❌ None — real gap | **Maintained.** No official Flutter SDK exists, so this plugin fills a genuine need. |
| `flutter_mintegral` | ✅ Active | Mintegral / Mobvista | ❌ No first-party SDK (only Google's `gma_mediation_mintegral` adapter) | **Maintained** for projects needing direct (non-mediated) integration. |
| `flutter_inbrain` | ✅ Active | Dynata | ✅ `inbrain_surveys` (verified) | Use the official plugin. |
| `flutter_tapjoy` | ✅ Active (now "Unity Offerwall") | Unity (acquired via ironSource) | ✅ `tapjoy_offerwall` (verified) | Use the official plugin. |
| `flutter_ayetstudios` | ✅ Active | ayeT-Studios GmbH | ⚠️ `ayet_sdk_v2` (unverified publisher) | Prefer the vendor's v2 wrapper. |
| `adcolony_flutter` | ☠️ Deprecated (SDK frozen at 4.9.0, 2022) | Sold to Digital Turbine → Affle | ❌ None | **Deprecated.** SDK is end-of-life; not recommended for new projects. |
| `flutter_mdata` | ⚠️ Rebranded | Monedata → Wavebrook (NetSignal SDK) | — | **Legacy.** Underlying product has been rebranded. |

**Actively maintained going forward:** `flutter_tapresearch` / `trsurveys` and `flutter_mintegral`.
The remaining plugins are either superseded by an official vendor plugin or wrap a
deprecated/rebranded SDK, and are kept here for reference.

## Maintained plugins — latest versions

Both maintained plugins have been brought current (v2.0.0) and migrated to
**Swift Package Manager** on iOS (no CocoaPods).

| Plugin | Version | Android SDK | iOS SDK (SPM) | Platforms | PR |
|---|---|---|---|---|---|
| `flutter_tapresearch` | `2.0.0` | `com.tapresearch:tapsdk:3.7.2` | `TapResearchSDK 3.8.0--beta03` | Android + iOS | [#27](https://github.com/arnavvaryani/flutter_advertising_plugins/pull/27) |
| `flutter_mintegral` | `2.0.0` | `com.mbridge.msdk.oversea:*:16.9.91` | `MintegralAdSDK 8.1.5` | Android + iOS | [#28](https://github.com/arnavvaryani/flutter_advertising_plugins/pull/28) |

Common requirements: Android `minSdk 23` / `compileSdk 35`, iOS `12.0+`, Flutter `3.24+`.

### Official vendor plugins (for the superseded ones)

- `flutter_tapjoy` → [`tapjoy_offerwall`](https://pub.dev/packages/tapjoy_offerwall)
- `flutter_inbrain` → [`inbrain_surveys`](https://pub.dev/packages/inbrain_surveys)
- `flutter_ayetstudios` → [`ayet_sdk_v2`](https://pub.dev/packages/ayet_sdk_v2)
- `flutter_mintegral` (mediation alternative) → [`gma_mediation_mintegral`](https://pub.dev/packages/gma_mediation_mintegral)

## Issues

Please check existing issues and file any new issues, bugs, or feature requests at
[https://github.com/AnavrinApps/flutter_plugins/issues](https://github.com/AnavrinApps/flutter_plugins/issues).
