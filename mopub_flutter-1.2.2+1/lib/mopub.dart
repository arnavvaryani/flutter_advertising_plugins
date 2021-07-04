import 'dart:async';

import 'mopub_constants.dart';
import 'package:flutter/services.dart';

class MoPub {
  static const MethodChannel _channel = const MethodChannel(MAIN_CHANNEL);

  static Future<void> init(String adUnitId, {bool testMode = false}) async {
    Map<String, dynamic> initValues = {
      "testMode": testMode,
      "adUnitId": adUnitId,
    };

    try {
      var result = await _channel.invokeMethod(INIT_METHOD, initValues);
      print('$result');
    } on PlatformException {
      return;
    }
  }

  static Future<void> dispose() async {
    try {
      await _channel.invokeMethod(DISPOSE_METHOD);
    } on PlatformException {
      return;
    }
  }
}
