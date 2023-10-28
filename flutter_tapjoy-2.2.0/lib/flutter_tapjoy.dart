import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';

enum TJConnectionResult { connected, disconnected }

enum TJContentState {
  contentReady,
  contentDidAppear,
  contentDidDisappear,
  contentRequestSuccess,
  contentRequestFail,
  userClickedAndroidOnly,
}

enum IOSATTAuthResult {
  notDetermined,
  restricted,
  denied,
  authorized,
  none,
  iOSVersionNotSupported,
  android
}

typedef TJPlacementHandler = void Function(
  TJContentState contentState,
  String? placementName,
  String? error,
);

typedef TJConnectionResultHandler = void Function(
    TJConnectionResult connectionResult);
typedef TJSpendCurrencyHandler = void Function(
    String? currencyName, int? amount, String? error);
typedef TJAwardCurrencyHandler = void Function(
    String? currencyName, int? amount, String? error);
typedef TJGetCurrencyBalanceHandler = void Function(
    String? currencyName, int? amount, String? error);
typedef TJEarnedCurrencyAlertHandler = void Function(
    String? currencyName, int? earnedAmount, String? error);

class TapJoyPlugin {
  static final TapJoyPlugin shared = TapJoyPlugin();

  final List<TJPlacement> placements = [];
  final MethodChannel _channel = const MethodChannel('flutter_tapjoy');

  TJConnectionResultHandler? _connectionResultHandler;
  TJSpendCurrencyHandler? _spendCurrencyHandler;
  TJAwardCurrencyHandler? _awardCurrencyHandler;
  TJGetCurrencyBalanceHandler? _getCurrencyBalanceHandler;
  TJEarnedCurrencyAlertHandler? _earnedCurrencyAlertHandler;

  TapJoyPlugin() {
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<bool?> connect({
    required String androidApiKey,
    required String iOSApiKey,
    required bool debug,
  }) async {
    final bool? connectionResult =
        await _channel.invokeMethod('connectTapJoy', {
      'androidApiKey': androidApiKey,
      'iOSApiKey': iOSApiKey,
      'debug': debug,
    });
    return connectionResult;
  }

  Future<IOSATTAuthResult> getIOSATTAuth() async {
    if (Platform.isIOS) {
      final String? result = await _channel.invokeMethod('getATT');
      switch (result) {
        case 'NotDetermined':
          return IOSATTAuthResult.notDetermined;
        case 'Restricted':
          return IOSATTAuthResult.restricted;
        case 'Denied':
          return IOSATTAuthResult.denied;
        case 'Authorized':
          return IOSATTAuthResult.authorized;
        case 'NOT':
          return IOSATTAuthResult.iOSVersionNotSupported;
        default:
          return IOSATTAuthResult.none;
      }
    } else {
      return IOSATTAuthResult.android;
    }
  }

  void setConnectionResultHandler(TJConnectionResultHandler handler) {
    _connectionResultHandler = handler;
  }

  void setSpendCurrencyHandler(TJSpendCurrencyHandler handler) {
    _spendCurrencyHandler = handler;
  }

  void setAwardCurrencyHandler(TJAwardCurrencyHandler handler) {
    _awardCurrencyHandler = handler;
  }

  void setGetCurrencyBalanceHandler(TJGetCurrencyBalanceHandler handler) {
    _getCurrencyBalanceHandler = handler;
  }

  void setEarnedCurrencyAlertHandler(TJEarnedCurrencyAlertHandler handler) {
    _earnedCurrencyAlertHandler = handler;
  }

  Future<bool?> isConnected() async {
    return await _channel.invokeMethod('isConnected');
  }

  Future<void> addPlacement(TJPlacement tjPlacement) async {
  placements.add(tjPlacement);
  await _createPlacement(tjPlacement);
}

Future<void> setUserID({required String userID}) async {
  await _channel.invokeMethod('setUserID', <String, dynamic>{
    'userID': userID,
  });
}

  Future<void> _createPlacement(TJPlacement tjPlacement) async {
    await _channel.invokeMethod('createPlacement', {
      'placementName': tjPlacement.name,
    });
  }

  Future<void> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'connectionSuccess':
        if (_connectionResultHandler != null) {
          _connectionResultHandler!(TJConnectionResult.connected);
        }
        break;
      case 'connectionFail':
        if (_connectionResultHandler != null) {
          _connectionResultHandler!(TJConnectionResult.disconnected);
        }
        break;
      case 'requestSuccess':
        final String? placementName = call.arguments['placementName'];
        final TJPlacement? tjPlacement = placements
            .firstWhereOrNull((element) => element.name == placementName);

        if (tjPlacement != null && tjPlacement.handler != null) {
          tjPlacement.handler!(
              TJContentState.contentRequestSuccess, placementName, null);
        }
        break;
      case 'requestFail':
        final String? placementName = call.arguments['placementName'];
        final TJPlacement? tjPlacement = placements
            .firstWhereOrNull((element) => element.name == placementName);
        final String? error = call.arguments['error'];

        if (tjPlacement != null && tjPlacement.handler != null) {
          tjPlacement.handler!(
              TJContentState.contentRequestFail, placementName, error);
        }
        break;
      case 'contentReady':
        final String? placementName = call.arguments['placementName'];
        final TJPlacement? tjPlacement = placements
            .firstWhereOrNull((element) => element.name == placementName);

        if (tjPlacement != null && tjPlacement.handler != null) {
          tjPlacement.handler!(
              TJContentState.contentReady, placementName, null);
        }
        break;
      case 'contentDidAppear':
        final String? placementName = call.arguments['placementName'];
        final TJPlacement? tjPlacement = placements
            .firstWhereOrNull((element) => element.name == placementName);

        if (tjPlacement != null && tjPlacement.handler != null) {
          tjPlacement.handler!(
              TJContentState.contentDidAppear, placementName, null);
        }
        break;
      case 'clicked':
        final String? placementName = call.arguments['placementName'];
        final TJPlacement? tjPlacement = placements
            .firstWhereOrNull((element) => element.name == placementName);

        if (tjPlacement != null && tjPlacement.handler != null) {
          tjPlacement.handler!(
              TJContentState.userClickedAndroidOnly, placementName, null);
        }
        break;
      case 'contentDidDisAppear':
        final String? placementName = call.arguments['placementName'];
        final TJPlacement? tjPlacement = placements
            .firstWhereOrNull((element) => element.name == placementName);

        if (tjPlacement != null && tjPlacement.handler != null) {
          tjPlacement.handler!(
              TJContentState.contentDidDisappear, placementName, null);
        }
        break;
      case 'onGetCurrencyBalanceResponse':
        final int? balance = call.arguments['balance'];
        final String? currencyName = call.arguments['currencyName'];
        final String? error = call.arguments['error'];

        if (_getCurrencyBalanceHandler != null) {
          _getCurrencyBalanceHandler!(currencyName, balance, error);
        }
        break;
      case 'onSpendCurrencyResponse':
        final int? balance = call.arguments['balance'];
        final String? currencyName = call.arguments['currencyName'];
        final String? error = call.arguments['error'];

        if (_spendCurrencyHandler != null) {
          _spendCurrencyHandler!(currencyName, balance, error);
        }
        break;
      case 'onAwardCurrencyResponse':
        final int? balance = call.arguments['balance'];
        final String? currencyName = call.arguments['currencyName'];
        final String? error = call.arguments['error'];

        if (_awardCurrencyHandler != null) {
          _awardCurrencyHandler!(currencyName, balance, error);
        }
        break;
      case 'onEarnedCurrency':
        final int? earnedAmount = call.arguments['earnedAmount'];
        final String? currencyName = call.arguments['currencyName'];
        final String? error = call.arguments['error'];

        if (_earnedCurrencyAlertHandler != null) {
          _earnedCurrencyAlertHandler!(currencyName, earnedAmount, error);
        }
        break;
      default:
        break;
    }
  }

Future<void> getCurrencyBalance() async {
await _channel.invokeMethod('getCurrencyBalance');
}

Future<void> spendCurrency(int amount) async {
await _channel.invokeMethod('spendCurrency', {
'amount': amount,
});
}

Future<void> awardCurrency(int amount) async {
await _channel.invokeMethod('awardCurrency', {
'amount': amount,
});
}
}

class TJPlacement {
final String name;
TJPlacementHandler? handler;

void setHandler(TJPlacementHandler myHandler) {
handler = myHandler;
}

TJPlacement({required this.name});

Future<void> requestContent() async {
await TapJoyPlugin.shared._channel.invokeMethod('requestContent', {
'placementName': name,
});
}

Future<void> showPlacement() async {
await TapJoyPlugin.shared._channel.invokeMethod('showPlacement', {
'placementName': name,
});
}
}
