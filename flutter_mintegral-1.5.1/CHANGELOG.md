## 0.0.1
New dependency, in testing
## 0.0.2+1
SDK updated
## 0.0.3
Bug fixes
## 0.1.0
Banner Ad fixed, Callbacks for ads added
## 0.1.1
Load and show method seperated
## 1.0.0 
Migrated to null safety
## 1.0.1
Rewarded ad bug fix
## 1.0.2+1
Dependency update
## 1.1.0
Dependency update
## 1.1.1
Dependency update
## 1.2.0
Dependency update
## 1.2.1
Dependency update
## 1.3.0
Dependency update
## 1.4.0
Breaking Change - Now dependency only supports Splash and Rewarded Ads as per new SDK (Need help to add other ad formats in future versions). iOS Support can be added in future if anybody can help with a pull request. 
## 1.5.0
New ad formats in Android, dependency update
## 1.5.0+1 
Dependency update
## 1.5.1
Plugin update
## 2.0.0
Modernization (Android):
- Mintegral overseas SDK 16.4.31 → 16.9.91 (reward, mbbid, mbsplash, mbbanner, newinterstitial).
- AGP 7.2.2 → 8.1.0 with `namespace`; removed the manifest `package` attribute.
- minSdk 19 → 23 (required by SDK 16.x); compileSdk 33 → 35.
- Bumped androidx.appcompat / recyclerview.
- Dart 3 / Flutter 3.3+; flutter_lints ^3.
- Removed a stray nested `flutter_mintegral/` plugin skeleton.

iOS (new):
- Implemented the iOS side (previously a `getPlatformVersion` stub) against the
  Mintegral iOS SDK 8.1.5 via **Swift Package Manager** (`MintegralAdSDK`).
- Parity for rewarded video, interstitial, splash, and banner — same method
  channel, custom codec (types 128/129/130), and event names as Android.
- Requires the `-ObjC` linker flag (declared in the plugin's Package.swift) and
  Flutter 3.24+.