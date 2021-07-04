import 'package:flutter/services.dart';

import 'mopub_constants.dart';

enum RewardedVideoAdResult {
  /// Rewarded video error.
  ERROR,

  /// Rewarded video loaded successfully.
  LOADED,

  /// Rewarded video clicked.
  CLICKED,

  /// Rewarded video played till the end. Use it to reward the user.
  GRANT_REWARD,

  /// Rewarded video displayed
  VIDEO_DISPLAYED,

  /// Rewarded video closed.
  VIDEO_CLOSED,
}

class MoPubRewardedVideoAd {
  static const MethodChannel _channel = MethodChannel(REWARDED_VIDEO_CHANNEL);

  MethodChannel _adChannel;
  final void Function(RewardedVideoAdResult, dynamic) listener;

  final String adUnitId;

  final bool reloadOnClosed;

  MoPubRewardedVideoAd(this.adUnitId, this.listener,
      {this.reloadOnClosed = false}) {
    if (listener != null) {
      _adChannel = MethodChannel('${REWARDED_VIDEO_CHANNEL}_$adUnitId');
      _adChannel.setMethodCallHandler(_handleEvent);
    }
  }

  Future<void> load() async {
    try {
      await _channel.invokeMethod(LOAD_REWARDED_VIDEO_METHOD, <String, dynamic>{
        'adUnitId': adUnitId,
      });
    } on PlatformException {
      return false;
    }
  }

  Future<bool> isReady() async {
    try {
      var result = await _channel
          .invokeMethod(HAS_REWARDED_VIDEO_METHOD, <String, dynamic>{
        'adUnitId': adUnitId,
      });
      return result;
    } on PlatformException {
      return false;
    }
  }

  Future<void> show() async {
    try {
      await _channel.invokeMethod(SHOW_REWARDED_VIDEO_METHOD, <String, dynamic>{
        "adUnitId": adUnitId,
      });
    } on PlatformException {
      return false;
    }
  }

  Future<dynamic> _handleEvent(MethodCall call) {
    print('Flutter mopub rewarded method ${call.method}');
    switch (call.method) {
      case GRANT_REWARD:
        if (listener != null)
          listener(RewardedVideoAdResult.GRANT_REWARD, call.arguments);
        break;
      case DISPLAYED_METHOD:
        if (listener != null)
          listener(RewardedVideoAdResult.VIDEO_DISPLAYED, call.arguments);
        break;
      case DISMISSED_METHOD:
        if (listener != null)
          listener(RewardedVideoAdResult.VIDEO_CLOSED, call.arguments);
        if (reloadOnClosed) {
          load();
        }
        break;
      case LOADED_METHOD:
        if (listener != null)
          listener(RewardedVideoAdResult.LOADED, call.arguments);
        break;
      case CLICKED_METHOD:
        if (listener != null)
          listener(RewardedVideoAdResult.CLICKED, call.arguments);
        break;
      case ERROR_METHOD:
      case REWARDED_PLAYBACK_ERROR:
      default:
        if (listener != null)
          listener(RewardedVideoAdResult.ERROR, call.arguments);        
        break;
    }
    return Future.value(true);
  }
}
