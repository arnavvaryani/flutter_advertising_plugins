# flutter_tapresearch

A plugin made in Flutter for TapResearch Surveys for Android & iOS 

# Installation

- Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  flutter_tapresearch: "<LATEST_VERSION>"

```

- Install it - You can install packages from the command line:

```sh
flutter pub get
```

# Issues 
Please open an issue on my flutter_plugins github regarding any of my dependencies.

Note: Few methods are not supported on iOS.

# Example
Please check the example repo for complete implementation.

# Pull Requests
Feel free to contribute and send me a pull request.

# Android specific guidelines
Add this to your proguard before you release your app.

```sh
  -keep class com.tapr.** { *; }
  -keep interface com.tapr.** { *; }
```