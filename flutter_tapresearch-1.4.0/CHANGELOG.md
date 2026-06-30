## 2.0.0
Major update: migrated to the TapResearch SDK 3.x.

**Breaking changes** — the 2.x placement / survey-wall API has been removed and
replaced with the 3.x content model:
- `configure()` + `setUniqueUserIdentifier()` + `initPlacement()` →
  `initialize(apiToken:, userIdentifier:)` (the SDK now requires a user
  identifier at init).
- Numeric placement IDs → string **placement tags**.
- `showSurveyWall()` → `showContentForPlacement(tag)`, gated by
  `canShowContentForPlacement(tag)`.
- Single reward callback (`DidReceiveRewardListener(int)`) → batched
  `setRewardsListener((List<TRReward>) {...})` with a full `TRReward` model.
- New listeners: `setSdkReadyListener`, `setErrorListener`,
  `setContentShownListener`, `setContentDismissedListener`.
- Removed navigation-bar styling and debug-mode methods (not part of the 3.x
  public API).

Other:
- Android: `com.tapr:tapresearch:2.4.1` → `com.tapresearch:tapsdk:3.7.2`,
  rewritten in Kotlin, minSdk 23, compileSdk 35, AGP 8, dropped `jcenter()`.
- iOS: implemented for real against the TapResearch 3.x SDK (`TapResearchSDK`);
  the previous iOS bridge was a non-functional stub. Integrates via **Swift
  Package Manager** (no CocoaPods / podspec).
- Dart 3 / Flutter 3.24+ (required for iOS SPM support).

## 1.4.0
Dependencies update
## 1.3.0
Null safety added
## 1.2.0+1
Bug fix
## 1.2.0
Support for iOS added, documentation, example and README updated.
