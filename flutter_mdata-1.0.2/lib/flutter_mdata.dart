import 'dart:async';
import 'package:flutter/services.dart';

typedef void IsReadyListener(bool isReady);
typedef void ConsentListener(bool consent);

class MoneDataSDK {
  static MoneDataSDK get instance => _instance;

  final MethodChannel _channel;

  static final MoneDataSDK _instance = MoneDataSDK.private(
    const MethodChannel('monedatasdk'),
  );

  MoneDataSDK.private(MethodChannel channel) : _channel = channel {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  static IsReadyListener _isReadyListener;
  static ConsentListener _consentListener;

  Future<void> init({String apiToken, String oguryToken}) async {
    assert(apiToken != null &&
        apiToken.isNotEmpty &&
        oguryToken != null &&
        oguryToken.isNotEmpty);
    return _channel.invokeMethod("init",
        <String, dynamic>{"api_token": apiToken, "oguryToken": oguryToken});
  }

  Future<void> start() {
    return _channel.invokeMethod("start");
  }

  Future<void> stop() {
    return _channel.invokeMethod("stop");
  }

  Future<void> consent() {
    return _channel.invokeMethod("consent");
  }

  Future _platformCallHandler(MethodCall call) async {
    print(
        "MoneDataSDK _platformCallHandler call ${call.method} ${call.arguments}");

    switch (call.method) {
      case "isReady":
        _isReadyListener(call.arguments);
        break;

      case "consentListener":
        _consentListener(call.arguments);
        break;
      default:
        print('Unknown method ${call.method}');
    }
  }

  void setisReadyListener(IsReadyListener isReadyListener) =>
      _isReadyListener = isReadyListener;

  void setConsentListener(ConsentListener consentListener) =>
      _consentListener = consentListener;
}
