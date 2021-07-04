library adcolony_flutter;

import 'package:flutter/services.dart';

enum AdColonyAdListener {
  onRequestFilled,
  onRequestNotFilled,
  onReward,
  onOpened,
  onClosed,
  onIAPEvent,
  onExpiring,
  onLeftApplication,
  onClicked
}

typedef AdColonyListener(AdColonyAdListener? listener, int? result);

class AdColony {
  static final MethodChannel channel = MethodChannel('AdColony');
  static final Map<String, AdColonyAdListener> adColonyAdListener = {
    'onRequestFilled': AdColonyAdListener.onRequestFilled,
    'onRequestNotFilled': AdColonyAdListener.onRequestNotFilled,
    'onReward': AdColonyAdListener.onReward,
    'onOpened': AdColonyAdListener.onOpened,
    'onClosed': AdColonyAdListener.onClosed,
    'onIAPEvent': AdColonyAdListener.onIAPEvent,
    'onLeftApplication': AdColonyAdListener.onLeftApplication,
    'onClicked': AdColonyAdListener.onClicked,
  };

  static Future<void> init(AdColonyOptions options) async {
    try {
      await channel.invokeMethod('Init', options.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> request(String zone, AdColonyListener listener) async {
    try {
      channel.setMethodCallHandler(
          (MethodCall call) async => handleMethod(call, listener));
      await channel.invokeMethod('Request', {'Id': zone});
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> show() async {
    try {
      await channel.invokeMethod('Show');
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<bool> isLoaded() async {
    try {
      return await channel.invokeMethod('isLoaded');
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<void> handleMethod(
      MethodCall call, AdColonyListener listener) async {
    listener(adColonyAdListener[call.method], call.arguments);
  }
}

class AdColonyOptions {
  final String id;
  final String gdpr;
  final List<String> zones;

  AdColonyOptions(this.id, this.gdpr, this.zones);

  Map<String, dynamic> toJson() =>
      {'Id': this.id, 'Gdpr': this.gdpr, 'Zones': this.zones};
}
