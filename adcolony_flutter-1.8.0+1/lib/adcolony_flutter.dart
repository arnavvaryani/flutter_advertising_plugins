import 'package:flutter/foundation.dart';
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
  onClicked,
}

typedef AdColonyListener = Function(AdColonyAdListener? listener, int? result);

class AdColony {
  static const MethodChannel channel = MethodChannel('AdColony');

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
      debugPrint(e.toString());
    }
  }

  static Future<void> request(String zone, AdColonyListener listener) async {
    try {
      channel.setMethodCallHandler((MethodCall call) async {
        await handleMethod(call, listener);
      });
      await channel.invokeMethod('Request', {'Id': zone});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> show() async {
    try {
      await channel.invokeMethod('Show');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<bool> isLoaded() async {
    try {
      return await channel.invokeMethod('isLoaded');
    } catch (e) {
      debugPrint(e.toString());
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

  Map<String, dynamic> toJson() => {'Id': id, 'Gdpr': gdpr, 'Zones': zones};
}
