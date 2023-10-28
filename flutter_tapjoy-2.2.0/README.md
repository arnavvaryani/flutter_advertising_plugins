# Tapjoy Flutter Plugin Documentation

The Tapjoy Flutter plugin allows you to integrate Tapjoy's advertising and monetization features into your Flutter applications. This documentation provides an overview of the plugin's usage and functionalities.

## Table of Contents

1. [Installation](#installation)
2. [Getting Started](#getting-started)
3. [Configuration](#configuration)
4. [User ID](#user-id)
5. [Placements](#placements)
6. [Currency Balance](#currency-balance)
7. [iOS App Tracking Transparency](#ios-app-tracking-transparency)

## Installation

To use the Tapjoy Flutter plugin in your Flutter project, follow these steps:

1. Open your project's `pubspec.yaml` file.
2. Add `flutter_tapjoy` as a dependency:

   ```yaml
   dependencies:
     flutter_tapjoy: ^x.x.x
   ```

3. Run the command `flutter packages get` to fetch the package.

## Getting Started

To start using the Tapjoy plugin in your Flutter application, follow these steps:

1. Import the necessary packages in your Dart file:

   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter_tapjoy/flutter_tapjoy.dart';
   ```

2. Initialize the Tapjoy plugin and connect to Tapjoy in the `initState()` method of your widget:

   ```dart
   @override
   void initState() {
     super.initState();
     TapJoyPlugin.shared.connect(
       androidApiKey: "YOUR_ANDROID_API_KEY",
       iOSApiKey: "YOUR_IOS_API_KEY",
       debug: true,
     );
   }
   ```

   Replace `"YOUR_ANDROID_API_KEY"` and `"YOUR_IOS_API_KEY"` with your actual Tapjoy API keys. Set the `debug` parameter to `true` for testing purposes.

3. Set up the Tapjoy plugin for handling connection results, currency balance, and placements. This can be done in the `initState()` method as well:

   ```dart
   @override
   void initState() {
     super.initState();
     // Set connection result handler
     TapJoyPlugin.shared.setConnectionResultHandler(_connectionResultHandler);

     // Set currency handlers
     TapJoyPlugin.shared.setGetCurrencyBalanceHandler(_currencyHandler);
     TapJoyPlugin.shared.setAwardCurrencyHandler(_currencyHandler);
     TapJoyPlugin.shared.setSpendCurrencyHandler(_currencyHandler);
     TapJoyPlugin.shared.setEarnedCurrencyAlertHandler(_currencyHandler);

     // Set contentState handler for each placement
     myPlacement.setHandler(_placementHandler);
     myPlacement2.setHandler(_placementHandler);

     // Add placements
     TapJoyPlugin.shared.addPlacement(myPlacement);
     TapJoyPlugin.shared.addPlacement(myPlacement2);
   }
   ```

   In the code above, `_connectionResultHandler`, `_currencyHandler`, and `_placementHandler` are placeholder methods that you need to define to handle the corresponding events.

4. Implement the necessary UI and button callbacks to interact with Tapjoy functionalities. For example, you can use the `ElevatedButton` widget to request content, show placements, or perform other actions:

   ```dart
   ElevatedButton(
     onPressed: myPlacement.requestContent,
     child: const Text("Request Content for Placement"),
   ),
   ```

   Replace `myPlacement` with the actual placement you want to request content for.

## Configuration

The Tapjoy Flutter plugin provides configuration options to connect to Tapjoy and enable debugging. Use the `TapJoyPlugin.shared.connect()` method to configure the plugin:

```dart
TapJoyPlugin.shared.connect({
  androidApiKey: String,
  iOSApiKey: String,
  debug: bool,
});
```

- `androidApiKey` (required): Your Tapjoy Android API key.
- `iOSApiKey` (required): Your Tapjoy iOS API key.
- `debug` (optional): Set to `true` to enable debug mode. Default is `false`.

## User ID

You can set a user ID to identify the user associated with Tapjoy interactions. Use the `TapJoyPlugin.shared.setUserID()` method to set the user ID:

```dart
TapJoyPlugin.shared.setUserID({userID: String});
```

- `userID` (required): The unique identifier for the user.

## Placements

Tapjoy placements represent locations in your application where you want to show content, such as rewarded ads or offers. The Tapjoy plugin allows you to add placements, request content, and handle placement events.

### Adding Placements

Use the `TapJoyPlugin.shared.addPlacement()` method to add a placement:

```dart
TapJoyPlugin.shared.addPlacement({placement: TJPlacement});
```

- `placement` (required): An instance of `TJPlacement` representing the placement to add.

### Requesting Content for a Placement

To request content for a placement, call the `requestContent()` method on the corresponding `TJPlacement` instance:

```dart
myPlacement.requestContent();
```

Replace `myPlacement` with the actual placement you want to request content for.

### Handling Placement Events

You can handle events related to Tapjoy placements, such as content readiness, appearance, disappearance, and request success/failure. Set the handler for each placement using the `setHandler()` method:

```dart
placement.setHandler({handler: Function});
```

- `handler` (required): The function that will be called when placement events occur. It should have the following signature:

  ```dart
  void handler(TJContentState contentState, String? name, String? error)
  ```

  - `contentState` (required): The current content state of the placement.
  - `name` (optional): The name of the placement.
  - `error` (optional): Any error message associated with the event.

## Currency Balance

The Tapjoy plugin provides methods to manage the user's currency balance, such as retrieving the balance, awarding currency, and spending currency. You can set handlers to receive currency-related events.

### Retrieving Currency Balance

To retrieve the user's currency balance, call the `getCurrencyBalance()` method:

```dart
TapJoyPlugin.shared.getCurrencyBalance();
```

The currency balance will be returned via the currency balance handler.

### Handling Currency Balance Events

To handle currency balance events, set the handler using the `setGetCurrencyBalanceHandler()` method:

```dart
TapJoyPlugin.shared.setGetCurrencyBalanceHandler({handler: Function});
```

- `handler` (required): The function that will be called when currency balance events occur. It should have the following signature:

  ```dart
  void handler(String? currencyName, int? amount, String? error)
  ```

  - `currencyName` (optional): The name of the currency.
  - `amount` (optional): The amount of the currency.
  - `error` (optional): Any error message associated with the event.

### Awarding Currency

To award currency to the user, call the `awardCurrency()` method:

```dart
TapJoyPlugin.shared.awardCurrency({amount: int});
```

- `amount` (required): The amount of currency to award.

The currency balance will be returned via the currency balance handler.

### Spending Currency

To spend currency from the user's balance, call the `spendCurrency()` method:

```dart
Tap

JoyPlugin.shared.spendCurrency({amount: int});
```

- `amount` (required): The amount of currency to spend.

The currency balance will be returned via the currency balance handler.

## iOS App Tracking Transparency

If your Flutter application targets iOS and you want to access the App Tracking Transparency (ATT) authorization status, you can use the Tapjoy plugin to retrieve it.

### Retrieving iOS App Tracking Transparency Authorization

To retrieve the iOS App Tracking Transparency (ATT) authorization status, call the `getIOSATTAuth()` method:

```dart
TapJoyPlugin.shared.getIOSATTAuth();
```

The authorization status will be returned as a value of the `IOSATTAuthResult` enum.

### Handling iOS ATT Authorization Result

To handle the iOS ATT authorization result, set the handler using the `setIOSATTAuthResultHandler()` method:

```dart
TapJoyPlugin.shared.setIOSATTAuthResultHandler({handler: Function});
```

- `handler` (required): The function that will be called when the iOS ATT authorization result is received. It should have the following signature:

  ```dart
  void handler(IOSATTAuthResult result)
  ```

  - `result` (required): The iOS ATT authorization result, represented by the `IOSATTAuthResult` enum.

---
