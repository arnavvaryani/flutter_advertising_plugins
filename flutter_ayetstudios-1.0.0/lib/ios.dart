import 'dart:async';
import 'package:flutter/services.dart';

typedef void UserBalanceChanged(int balance);
typedef void UserAvailableBalance(int balance);
typedef void UserPendingBalance(int balance);

class AyeTStudiosIOS {
  static AyeTStudiosIOS get instance => _instance;
  final MethodChannel _channel;

  static final AyeTStudiosIOS _instance = AyeTStudiosIOS.private(
    const MethodChannel('ios_native'),
  );

  AyeTStudiosIOS.private(MethodChannel channel) : _channel = channel {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  static UserBalanceChanged? _userBalanceChanged;
  static UserAvailableBalance? _userAvailableBalance;
  static UserPendingBalance? _userPendingBalance;

  Future<void> init({String? uid, appKey}) async {
    return _channel.invokeMethod("init", <String, dynamic>{
      'appKey': appKey,
      'uid': uid,
    });
  }

  void sdkLogEnable() async {
    return _channel.invokeMethod("sdkLogEnable");
  }

  void userAvailableBalance() async {
    return _channel.invokeMethod("userAvailableBalance");
  }

  void userPendingBalance() async {
    return _channel.invokeMethod("userPendingBalance");
  }

  Future<void> show(String placement) {
    return _channel.invokeMethod("show", <String, dynamic>{
      'placement': placement,
    });
  }

  Future _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "userBalanceChanged":
        _userBalanceChanged!(call.arguments);
        print("userBalanceChanged");
        break;
      case "userAvailableBalance":
        _userAvailableBalance!(call.arguments);
        print("userAvailableBalance");
        break;
      case "userPendingBalance":
        _userPendingBalance!(call.arguments);
        print("userPendingBalance");
        break;
      default:
        print('Unknown method ${call.method} ');
    }
  }

  void setUserBalanceChanged(UserBalanceChanged userBalanceChanged) =>
      _userBalanceChanged = userBalanceChanged;

  void setUserAvailableBalance(UserAvailableBalance userAvailableBalance) =>
      _userAvailableBalance = userAvailableBalance;

  void setUserPendingBalance(UserAvailableBalance userPendingBalance) =>
      _userPendingBalance = userPendingBalance;
}
