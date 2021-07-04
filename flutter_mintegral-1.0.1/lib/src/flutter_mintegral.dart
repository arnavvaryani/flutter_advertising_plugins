import 'dart:async';
import 'package:flutter/services.dart';

enum FlutterMintegralListener {
  onInitSuccess,
  onInitFailure,
  onRewardLoadSuccess,
  onRewardVideoLoadSuccess,
  onRewardVideoLoadFail,
  onRewardVideoShowFail,
  onRewardAdShow,
  onRewardAdClose,
  onRewardVideoAdClicked,
  onRewardVideoComplete,
  onRewardEndcardShow,
  onInterstitalLoadSuccess,
  onInterstitialVideoLoadSuccess,
  onInterstitalVideoLoadFail,
  onInterstitalShowFail,
  onInterstitalAdShow,
  onInterstitalAdClose,
  onInterstitalVideoClicked,
  onInterstitalVideoComplete,
  onInterstitalAdCloseWithIVReward,
  onInterstitalAdCloseStatusNotShown,
  onInterstitalAdCloseStatusClickContinue,
  onInterstitalAdCloseStatusClickCancel,
  onInterstitalEndcardShow,
  onInteractivelLoadSuccess,
  onInterActiveMaterialLoadSuccess,
  onInteractiveLoadFail,
  onInteractiveShowSuccess,
  onInteractiveShowFail,
  onInteractiveClosed,
  onInteractiveAdClick,
  onInteractivePlayingComplete,
  onBannerLoadFailed,
  onBannerLoadSuccess,
  onBannerClick,
  onBannerLeaveApp,
  onBannerFullScreen,
  onBannercloseFullScreen,
  onBannerLogImpression,
  onBannerClose,
}
typedef FlutterMintegralAdListener(FlutterMintegralListener? listener);

class Mintegral {
  static const MethodChannel _channel =
      const MethodChannel('flutter_mintegral');

  static final Map<String, FlutterMintegralListener> flutterMintegralListener =
      {
    'onInitSuccess': FlutterMintegralListener.onInitSuccess,
    'onInitFailure': FlutterMintegralListener.onInitFailure,
    'onRewardLoadSuccess': FlutterMintegralListener.onRewardLoadSuccess,
    'onRewardVideoLoadSuccess':
        FlutterMintegralListener.onRewardVideoLoadSuccess,
    'onRewardVideoLoadFail': FlutterMintegralListener.onRewardVideoLoadFail,
    'onRewardVideoShowFail': FlutterMintegralListener.onRewardVideoShowFail,
    'onRewardAdShow': FlutterMintegralListener.onRewardAdShow,
    'onRewardAdClose': FlutterMintegralListener.onRewardAdClose,
    'onRewardVideoAdClicked': FlutterMintegralListener.onRewardVideoAdClicked,
    'onRewardVideoComplete': FlutterMintegralListener.onRewardVideoComplete,
    'onRewardEndcardShow': FlutterMintegralListener.onRewardEndcardShow,
    'onInterstitalLoadSuccess':
        FlutterMintegralListener.onInterstitalLoadSuccess,
    'onInterstitialVideoLoadSuccess':
        FlutterMintegralListener.onInterstitialVideoLoadSuccess,
    'onInterstitalVideoLoadFail':
        FlutterMintegralListener.onInterstitalVideoLoadFail,
    'onInterstitalShowFail': FlutterMintegralListener.onInterstitalShowFail,
    'onInterstitalAdShow': FlutterMintegralListener.onInterstitalAdShow,
    'onInterstitalAdClose': FlutterMintegralListener.onInterstitalAdClose,
    'onInterstitalVideoClicked,':
        FlutterMintegralListener.onInterstitalVideoClicked,
    'onInterstitalVideoComplete':
        FlutterMintegralListener.onInterstitalVideoComplete,
    'onInterstitalAdCloseWithIVReward':
        FlutterMintegralListener.onInterstitalAdCloseWithIVReward,
    'onInterstitalAdCloseStatusNotShown':
        FlutterMintegralListener.onInterstitalAdCloseStatusNotShown,
    'onInterstitalAdCloseStatusClickContinue':
        FlutterMintegralListener.onInterstitalAdCloseStatusClickContinue,
    'onInterstitalAdCloseStatusClickCancel':
        FlutterMintegralListener.onInterstitalAdCloseStatusClickCancel,
    'onInterstitalEndcardShow':
        FlutterMintegralListener.onInterstitalEndcardShow,
    'onInteractivelLoadSuccess':
        FlutterMintegralListener.onInteractivelLoadSuccess,
    'onInterActiveMaterialLoadSuccess':
        FlutterMintegralListener.onInterActiveMaterialLoadSuccess,
    'onInteractiveLoadFail': FlutterMintegralListener.onInteractiveLoadFail,
    'onInteractiveShowSuccess':
        FlutterMintegralListener.onInteractiveShowSuccess,
    'onInteractiveShowFail': FlutterMintegralListener.onInteractiveShowFail,
    'onInteractiveClosed': FlutterMintegralListener.onInteractiveClosed,
    'onInteractiveAdClick': FlutterMintegralListener.onInteractiveAdClick,
    'onInteractivePlayingComplete':
        FlutterMintegralListener.onInteractivePlayingComplete,
    'onBannerLoadFailed': FlutterMintegralListener.onBannerLoadFailed,
    'onBannerLoadSuccess': FlutterMintegralListener.onBannerLoadSuccess,
    'onBannerClick': FlutterMintegralListener.onBannerClick,
    'onBannerLeaveApp': FlutterMintegralListener.onBannerLeaveApp,
    'onBannerFullScreen': FlutterMintegralListener.onBannerFullScreen,
    'onBannercloseFullScreen': FlutterMintegralListener.onBannercloseFullScreen,
    'onBannerLogImpression': FlutterMintegralListener.onBannerLogImpression,
    'onBannerClose': FlutterMintegralListener.onBannerClose,
  };

  static Future<void> initSdk({
    String? appId,
    String? appKey,
    /**
      * for EU-GDPR
      * false: MIntegralConstans.IS_SWITCH_ON
      */
    bool isProtectGDPR = true,
    /**
      * If set to TRUE, the server will not display personalized ads based on the user's personal information.
      * When receiving the user's request, and will not synchronize the user's information to other third-party partners.
      */
    bool isProtectCCPA = false,
  }) async {
    assert(appId != null &&
        appId.isNotEmpty &&
        appKey != null &&
        appKey.isNotEmpty);
    Map map = {
      "appId": appId,
      "appKey": appKey,
      "isProtectGDPR": isProtectGDPR,
      "isProtectCCPA": isProtectCCPA,
    };
    await _channel.invokeMethod('initAdSDK', map);
  }

  static Future<void> startSplashAd({
    String? adUnitId,
    String? placementId,
    String? launchBackgroundId,
  }) async {
    assert(adUnitId != null && placementId != null);
    Map map = {
      "adUnitId": adUnitId,
      "placementId": placementId,
      "launchBackgroundId": launchBackgroundId,
    };
    await _channel.invokeMethod('startSplashAd', map);
  }

  static Future<void> setListeners(FlutterMintegralAdListener listener) async {
    _channel.setMethodCallHandler(
        (MethodCall call) async => handleMethod(call, listener));
  }

  static Future<void> loadInteractiveAD({
    String? adUnitId,
    String? placementId,
  }) async {
    assert(adUnitId != null && placementId != null);
    Map map = {
      "adUnitId": adUnitId,
      "placementId": placementId,
    };
    await _channel.invokeMethod('loadInteractiveAD', map);
  }

  static Future<void> showInterstitialVideoAD() async {
    await _channel.invokeMethod('showInterstitialVideoAD');
  }

  static Future<void> showRewardedVideoAD({
    String? userId,
    String? rewardId,
  }) async {
    Map map = {
      "userId": userId ?? '',
      "rewardId": rewardId ?? '1',
    };
    await _channel.invokeMethod('showRewardedVideoAD', map);
  }

  static Future<void> showInteractiveAD() async {
    await _channel.invokeMethod('showInteractiveAD');
  }

  static Future<void> loadInterstitialVideoAD({
    String? adUnitId,
    String? placementId,
  }) async {
    assert(adUnitId != null && placementId != null);
    Map map = {
      "adUnitId": adUnitId,
      "placementId": placementId,
    };
    await _channel.invokeMethod('loadInterstitialVideoAD', map);
  }

  static Future<void> loadRewardVideoAD({
    String? adUnitId,
    String? placementId,
    String? userId,
    String? rewardId,
    bool? closeButton,
    int? refreshTime,
  }) async {
    assert(adUnitId != null && placementId != null);
    Map map = {
      "adUnitId": adUnitId,
      "closeButton": closeButton,
      "refreshTime": refreshTime,
      "placementId": placementId,
      "userId": userId,
      "rewardId": rewardId,
    };
    await _channel.invokeMethod('loadRewardVideoAD', map);
  }

  static Future<void> showBannerAD(
      {String? adUnitId,
      String? placementId,
      int? height,
      int? width,
      bool? closeButton,
      int? refreshTime,
      int? bannerType}) async {
    assert(adUnitId != null && placementId != null);
    Map map = {
      "adUnitId": adUnitId,
      "placementId": placementId,
      "height": height,
      "width": width,
      "closeButton": closeButton,
      "refreshTime": refreshTime,
      "bannerType": bannerType,
    };
    await _channel.invokeMethod('showBannerAD', map);
  }

  static Future<void> handleMethod(
      MethodCall call, FlutterMintegralAdListener listener) async {
    listener(flutterMintegralListener[call.method]);
  }

  static Future<void> disposeBannerAD({required String adUnitId}) async {
    Map map = {
      "adUnitId": adUnitId,
    };
    await _channel.invokeMethod('disposeBannerAD', map);
  }
}
