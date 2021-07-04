import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/services.dart';

/// connection result enums for ConnectionResultHandler
enum TJConnectionResult { connected, disconnected }

/// Placement Content State enums for TJPlacementHandler
enum TJContentState {
  contentReady,
  contentDidAppear,
  contentDidDisappear,
  contentRequestSuccess,
  contentRequestFail,
  userClickedAndroidOnly,
}

/// iOS App Tracking Authentication Result enums for getIOSATTAuth
enum IOSATTAuthResult {
  notDetermined,
  restricted,
  denied,
  authorized,
  none,
  iOSVersionNotSupported,
  android
}

/// TJPlacementHandler
/// contentState with Type TapJoyContentState enum
typedef void TJPlacementHandler(
  TJContentState contentState,
  String? placementName,
  String? error,
);

/// ConnectionResultHandler returns connectionResult with Type TapJoyConnectionResult enum
typedef void TJConnectionResultHandler(TJConnectionResult connectionResult);

/// SpendCurrencyHandler returns String currencyName, int amount, String error
/// if function is successful , error is null
/// if function fails, currencyName & amount are null
typedef void TJSpendCurrencyHandler(
    String? currencyName, int? amount, String? error);

/// AwardCurrencyHandler returns String currencyName, int amount, String error
/// if function is successful , error is null
/// if function fails, currencyName & amount are null
typedef void TJAwardCurrencyHandler(
    String? currencyName, int? amount, String? error);

/// GetCurrencyBalanceHandler returns String currencyName, int amount, String error
/// if function is successful , error is null
/// if function fails, currencyName & amount are null
typedef void TJGetCurrencyBalanceHandler(
    String? currencyName, int? amount, String? error);

/// EarnedCurrencyAlertHandler returns String currencyName, int amount, String error
/// In order to notify users that they’ve earned virtual currency since the last time the app queried the user’s currency balance,
/// if function is successful , error is null
/// if function fails, currencyName & amount are null
typedef void TJEarnedCurrencyAlertHandler(
    String? currencyName, int? earnedAmount, String? error);

const MethodChannel _channel = const MethodChannel('flutter_tapjoy');

class TapJoyPlugin {
  static TapJoyPlugin shared = new TapJoyPlugin();

  /// Array of placements that you added.
  final List<TJPlacement> placements = [];

  /// Add placement
  Future<bool?> addPlacement(TJPlacement tjPlacement) async {
    placements.add(tjPlacement);
    return await _createPlacement(tjPlacement);
  }

  /// event handlers
  TJConnectionResultHandler? _connectionResultHandler;
  TJSpendCurrencyHandler? _spendCurrencyHandler;
  TJAwardCurrencyHandler? _awardCurrencyHandler;
  TJGetCurrencyBalanceHandler? _getCurrencyBalanceHandler;
  TJEarnedCurrencyAlertHandler? _earnedCurrencyAlertHandler;

  /// Set connection result handler which returns TapJoyConnectionResult
  void setConnectionResultHandler(TJConnectionResultHandler handler) {
    _connectionResultHandler = handler;
  }

  /// set Spend currency handler which returns String currencyName, int amount, String error
  void setSpendCurrencyHandler(TJSpendCurrencyHandler handler) {
    _spendCurrencyHandler = handler;
  }

  /// set Award currency handler which returns String currencyName, int amount, String error
  void setAwardCurrencyHandler(TJAwardCurrencyHandler handler) {
    _awardCurrencyHandler = handler;
  }

  /// set Get currency Balance handler which returns String currencyName, int amount, String error
  void setGetCurrencyBalanceHandler(TJGetCurrencyBalanceHandler handler) {
    _getCurrencyBalanceHandler = handler;
  }

  /// set Earned currency Alert handler which returns String currencyName, int amount, String error
  void setEarnedCurrencyAlertHandler(TJEarnedCurrencyAlertHandler handler) {
    _earnedCurrencyAlertHandler = handler;
  }

  /// check if connected to TapJoy, returns Bool
  Future<bool?> isConnected() async {
    return await _channel.invokeMethod("isConnected");
  }

  /// get iOS App Tracking Authentication status, returns IOSATTAuthResult enum
  Future<IOSATTAuthResult> getIOSATTAuth() async {
    if (Platform.isIOS) {
      final String? result = await _channel.invokeMethod("getATT");
      switch (result) {
        case "NotDetermined":
          return IOSATTAuthResult.notDetermined;
        case "Restricted":
          return IOSATTAuthResult.restricted;
        case "Denied":
          return IOSATTAuthResult.denied;
        case "Authorized":
          return IOSATTAuthResult.authorized;
        case "NOT":
          return IOSATTAuthResult.iOSVersionNotSupported;
        default:
          return IOSATTAuthResult.none;
      }
    } else {
      return IOSATTAuthResult.android;
    }
  }

  /// constructor method
  TapJoyPlugin() {
    _channel.setMethodCallHandler(_handleMethod);
  }

  /// connect to TapJoy, all fields required.
  Future<bool?> connect(
      {required String androidApiKey,
      required String iOSApiKey,
      required bool debug}) async {
    final bool? connectionResult =
        await _channel.invokeMethod('connectTapJoy', <String, dynamic>{
      'androidApiKey': androidApiKey,
      "iOSApiKey": iOSApiKey,
      "debug": debug,
    });
    return connectionResult;
  }

  /// set user ID
  Future<void> setUserID({required String userID}) async {
    await _channel.invokeMethod('setUserID', <String, dynamic>{
      'userID': userID,
    });
    return;
  }

  Future<bool?> _createPlacement(TJPlacement tjPlacement) async {
    final result =
        await _channel.invokeMethod('createPlacement', <String, dynamic>{
      'placementName': tjPlacement.name,
    });
    return result;
  }

  Future<Null> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'connectionSuccess':
        if (this._connectionResultHandler != null) {
          this._connectionResultHandler!(TJConnectionResult.connected);
        }
        break;
      case 'connectionFail':
        if (this._connectionResultHandler != null) {
          this._connectionResultHandler!(TJConnectionResult.disconnected);
        }
        break;
      case 'requestSuccess':
        String? placementName = call.arguments["placementName"];
        TJPlacement? tjPlacement = placements
            .firstWhereOrNull((element) => element.name == placementName);

        if (tjPlacement != null) {
          if (tjPlacement._handler != null) {
            tjPlacement._handler!(
                TJContentState.contentRequestSuccess, placementName, null);
          } else {}
        }
        break;
      case 'requestFail':
        String? placementName = call.arguments["placementName"];
        TJPlacement? tjPlacement = placements
            .firstWhereOrNull((element) => element.name == placementName);
        String? error = call.arguments["error"];
        if (tjPlacement != null) {
          if (tjPlacement._handler != null) {
            tjPlacement._handler!(
                TJContentState.contentRequestFail, placementName, error);
          } else {}
        }
        break;
      case 'contentReady':
        String? placementName = call.arguments["placementName"];
        TJPlacement? tjPlacement = placements
            .firstWhereOrNull((element) => element.name == placementName);

        if (tjPlacement != null) {
          if (tjPlacement._handler != null) {
            tjPlacement._handler!(
                TJContentState.contentReady, placementName, null);
          } else {}
        }
        break;
      case 'contentDidAppear':
        String? placementName = call.arguments["placementName"];
        TJPlacement? tjPlacement = placements
            .firstWhereOrNull((element) => element.name == placementName);

        if (tjPlacement != null) {
          if (tjPlacement._handler != null) {
            tjPlacement._handler!(
                TJContentState.contentDidAppear, placementName, null);
          } else {}
        }
        break;
      case 'clicked':
        String? placementName = call.arguments["placementName"];
        TJPlacement? tjPlacement = placements
            .firstWhereOrNull((element) => element.name == placementName);

        if (tjPlacement != null) {
          if (tjPlacement._handler != null) {
            tjPlacement._handler!(
                TJContentState.userClickedAndroidOnly, placementName, null);
          } else {}
        }
        break;
      case 'contentDidDisAppear':
        String? placementName = call.arguments["placementName"];
        TJPlacement? tjPlacement = placements
            .firstWhereOrNull((element) => element.name == placementName);

        if (tjPlacement != null) {
          if (tjPlacement._handler != null) {
            tjPlacement._handler!(
                TJContentState.contentDidDisappear, placementName, null);
          } else {}
        }
        break;
      case 'onGetCurrencyBalanceResponse':
        int? balance = call.arguments["balance"];
        String? currencyName = call.arguments["currencyName"];
        String? error = call.arguments["error"];
        if (this._getCurrencyBalanceHandler != null) {
          this._getCurrencyBalanceHandler!(currencyName, balance, error);
        }
        break;
      case 'onSpendCurrencyResponse':
        int? balance = call.arguments["balance"];
        String? currencyName = call.arguments["currencyName"];
        String? error = call.arguments["error"];
        if (this._spendCurrencyHandler != null) {
          this._spendCurrencyHandler!(currencyName, balance, error);
        }
        break;
      case 'onAwardCurrencyResponse':
        int? balance = call.arguments["balance"];
        String? currencyName = call.arguments["currencyName"];
        String? error = call.arguments["error"];
        if (this._awardCurrencyHandler != null) {
          this._awardCurrencyHandler!(currencyName, balance, error);
        }
        break;
      case 'onEarnedCurrency':
        int? earnedAmount = call.arguments["earnedAmount"];
        String? currencyName = call.arguments["currencyName"];
        String? error = call.arguments["error"];
        if (this._earnedCurrencyAlertHandler != null) {
          this._earnedCurrencyAlertHandler!(currencyName, earnedAmount, error);
        }
        break;
      default:
        break;
    }
    return null;
  }

  /// get currency balance, does NOT return, set setGetCurrencyBalanceHandler to get notified with result
  Future<void> getCurrencyBalance() async {
    await _channel.invokeMethod('getCurrencyBalance');
  }

  /// spend currency balance, does NOT return, set setSpendCurrencyHandler to get notified with result
  Future<void> spendCurrency(int amount) async {
    await _channel.invokeMethod('spendCurrency', <String, dynamic>{
      'amount': amount,
    });
  }

  /// award currency balance, does NOT return, set setAwardCurrencyHandler to get notified with result
  Future<void> awardCurrency(int amount) async {
    await _channel.invokeMethod('awardCurrency', <String, dynamic>{
      'amount': amount,
    });
  }
}

class TJPlacement {
  /// placement name, Required
  final String name;
  TJPlacementHandler? _handler;

  /// set handler for placement to get notified for events with enum TapJoyContentState
  void setHandler(TJPlacementHandler myHandler) {
    _handler = myHandler;
  }

  ///constructor method, placement name is required
  TJPlacement({required this.name}) {
//
  }

  /// request content for placement, does NOT return, set placement handler with placement.setHandler to get notified for contentState
  Future<void> requestContent() async {
    await _channel.invokeMethod('requestContent', <String, dynamic>{
      'placementName': name,
    });
  }

  /// show content for placement, does NOT return, set placement handler with placement.setHandler to get notified for contentState
  Future<void> showPlacement() async {
    await _channel.invokeMethod('showPlacement', <String, dynamic>{
      'placementName': name,
    });
  }
}
