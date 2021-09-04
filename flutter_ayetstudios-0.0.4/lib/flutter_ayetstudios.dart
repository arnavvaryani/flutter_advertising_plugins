import 'dart:async';
import 'package:flutter/services.dart';

typedef void UserBalanceChanged(int balance);
typedef void UserAvailableBalance(int balance);
typedef void UserPendingBalance(int balance);
typedef void InitializationFailed(int failed);
typedef void DeductUserBalance(int success);

class AyeTStudios {
  static AyeTStudios get instance => _instance;
  final MethodChannel _channel;

  static final AyeTStudios _instance = AyeTStudios.private(
    const MethodChannel('flutter_ayetstudios'),
  );

  AyeTStudios.private(MethodChannel channel) : _channel = channel {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  static UserBalanceChanged _userBalanceChanged;
  static DeductUserBalance _deductUserBalance;
  static UserAvailableBalance _userAvailableBalance;
  static UserPendingBalance _userPendingBalance;
  static InitializationFailed _initializationFailed;

  Future<void> init({String uid}) async {
    return _channel.invokeMethod("init", <String, dynamic>{
      'uid': uid,
    });
  }

  Future<void> show(String placement) {
    return _channel.invokeMethod("show", <String, dynamic>{
      'placement': placement,
    });
  }

  Future<void> deduct(int amount) {
    return _channel.invokeMethod("deduct", <String, dynamic>{
      'amount': amount,
    });
  }

  Future _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "userBalanceChanged":
        _userBalanceChanged(call.arguments);
        print("userBalanceChanged");
        break;
      case "userAvailableBalance":
        _userAvailableBalance(call.arguments);
        print("userAvailableBalance");
        break;
      case "userPendingBalance":
        _userPendingBalance(call.arguments);
        print("userPendingBalance");
        break;
      case "initializationFailed":
        _initializationFailed(call.arguments);
        print("initializationFailed");
        break;
      case "deductUserBalance":
        _deductUserBalance(call.arguments);
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

  void setInitilizationFailedListener(
          InitializationFailed initializationFailed) =>
      _initializationFailed = initializationFailed;
  void setDeductUserBalanceListener(DeductUserBalance deductUserBalance) =>
      _deductUserBalance = deductUserBalance;
}
