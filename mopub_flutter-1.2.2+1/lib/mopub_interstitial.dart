import 'package:flutter/services.dart';

import 'mopub_constants.dart';

enum InterstitialAdResult {
  /// Interstitial Ad displayed to the user
  DISPLAYED,

  /// Interstitial Ad dismissed by the user
  DISMISSED,

  /// Interstitial Ad error
  ERROR,

  /// Interstitial Ad loaded
  LOADED,

  /// Interstitial Ad clicked
  CLICKED,
}

class MoPubInterstitialAd {
  //Common channel for all interstitial ads until load
  static const MethodChannel _channel = MethodChannel(INTERSTITIAL_AD_CHANNEL);

  MethodChannel _adChannel;
  final void Function(InterstitialAdResult, dynamic) listener;

  final String adUnitId;

  final bool reloadOnClosed;

  MoPubInterstitialAd(this.adUnitId, this.listener,
      {this.reloadOnClosed = false}) {
    if (listener != null) {
      _adChannel = MethodChannel('${INTERSTITIAL_AD_CHANNEL}_$adUnitId');
      _adChannel.setMethodCallHandler(_handleEvent);
    }
  }

  Future<void> load() async {
    try {
      await _channel.invokeMethod(LOAD_INTERSTITIAL_METHOD, <String, dynamic>{
        'adUnitId': adUnitId,
      });
    } on PlatformException {
      return;
    }
  }

  Future<bool> isReady() async {
    try {
      var result = await _channel
          .invokeMethod(HAS_INTERSTITIAL_METHOD, <String, dynamic>{
        'adUnitId': adUnitId,
      });
      return result;
    } on PlatformException {
      return false;
    }
  }

  Future<void> show() async {
    await _channel.invokeMethod(SHOW_INTERSTITIAL_METHOD, <String, dynamic>{
      'adUnitId': adUnitId,
    });
  }

  void dispose() async {
    // await _channel.invokeMethod(DESTROY_INTERSTITIAL_METHOD, <String, dynamic>{
    //   'adUnitId': adUnitId,
    // });
    // _channel.setMethodCallHandler(null);
  }

  Future<dynamic> _handleEvent(MethodCall call) {
    switch (call.method) {
      case DISPLAYED_METHOD:
        listener(InterstitialAdResult.DISPLAYED, call.arguments);
        break;
      case DISMISSED_METHOD:
        listener(InterstitialAdResult.DISMISSED, call.arguments);
        if (reloadOnClosed) {
          load();
        }
        break;
      case ERROR_METHOD:
        listener(InterstitialAdResult.ERROR, call.arguments);        
        break;
      case LOADED_METHOD:
        listener(InterstitialAdResult.LOADED, call.arguments);
        break;
      case CLICKED_METHOD:
        listener(InterstitialAdResult.CLICKED, call.arguments);
        break;
    }
    return Future.value(true);
  }
}
