import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

typedef void SurveyWallOpenedListener();
typedef void SurveyWallDismissedListener();
typedef void DidReceiveRewardListener(int? reward);
typedef void IsSurveyWallAvailableListener(int? surveyAvailable);

class TapResearch {
  static TapResearch get instance => _instance;

  final MethodChannel _channel;

  static final TapResearch _instance = TapResearch.private(
    const MethodChannel('flutter_tapresearch'),
  );

  TapResearch.private(MethodChannel channel) : _channel = channel {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  static late SurveyWallOpenedListener _surveyWallOpenedListener;
  static late SurveyWallDismissedListener _surveyWallDismissedListener;
  static late DidReceiveRewardListener _didReceiveRewardListener;
  static late IsSurveyWallAvailableListener _isSurveyWallAvailableListener;

  Future<void> configure({String? apiToken}) async {
    assert(apiToken != null && apiToken.isNotEmpty);
    return _channel.invokeMethod("configure", <String, dynamic>{
      'api_token': apiToken,
    });
  }

  Future<void> initPlacement({String? placementId}) async {
    return _channel.invokeMethod("initPlacement", <String, dynamic>{
      'placement_id': placementId,
    });
  }

  Future<void> showSurveyWall() async {
    try {
      await _channel.invokeMethod('showSurveyWall');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setUniqueUserIdentifier(String uid) async {
    try {
      await _channel.invokeMethod('setUniqueUserIdentifier', <String, dynamic>{
        'user_id': uid,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setRewardListener() async {
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('setRewardListener');
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> setNavigationBarText(String navBarText) async {
    try {
      await _channel.invokeMethod('setNavigationBarText', <String, dynamic>{
        'navBarText': navBarText,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setDebugMode(bool mode) async {
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('setDebugMode', <String, dynamic>{
          'mode': mode,
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> setNavigationBarColor(
      {String? hexColor,
      double? red,
      double? green,
      double? blue,
      double? alpha}) async {
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('setNavigationBarColor', <String, dynamic>{
          'navColor': hexColor,
        });
      } catch (e) {
        print(e.toString());
      }
    } else if (Platform.isIOS) {
      try {
        await _channel.invokeMethod('setNavigationBarColor', <String, dynamic>{
          'red': red,
          'green': green,
          'blue': blue,
          'alpha': alpha
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> setNavigationBarTextColor(
      {String? hexColor,
      double? red,
      double? green,
      double? blue,
      double? alpha}) async {
    if (Platform.isAndroid) {
      try {
        await _channel
            .invokeMethod('setNavigationBarTextColor', <String, dynamic>{
          'navBarColor': hexColor,
        });
      } catch (e) {
        print(e.toString());
      }
    } else if (Platform.isIOS) {
      try {
        await _channel.invokeMethod(
            'setNavigationBarTextColor', <String, dynamic>{
          'red': red,
          'green': green,
          'blue': blue,
          'alpha': alpha
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future _platformCallHandler(MethodCall call) async {
    print(
        "TapResearch _platformCallHandler call ${call.method} ${call.arguments}");

    switch (call.method) {
      case "tapResearchSurveyWallOpened":
        _surveyWallOpenedListener();
        break;

      case "tapResearchSurveyWallDismissed":
        _surveyWallDismissedListener();
        break;

      case "tapResearchDidReceiveReward":
        _didReceiveRewardListener(call.arguments);
        break;

      case "isSurveyWallAvailable":
        if (Platform.isAndroid) {
          _isSurveyWallAvailableListener(call.arguments);
        }
        break;
      default:
        print('Unknown method ${call.method} ');
    }
  }

  void setSurveyWallOpenedListener(
          SurveyWallOpenedListener surveyWallOpenedListener) =>
      _surveyWallOpenedListener = surveyWallOpenedListener;

  void setSurveyWallDismissedListener(
          SurveyWallDismissedListener surveyWallDismissedListener) =>
      _surveyWallDismissedListener = surveyWallDismissedListener;

  void setDidReceiveRewardListener(
          DidReceiveRewardListener didReceiveRewardListener) =>
      _didReceiveRewardListener = didReceiveRewardListener;

  void setIsSurveyWallAvailableListener(
          IsSurveyWallAvailableListener isSurveyWallAvailableListener) =>
      _isSurveyWallAvailableListener = isSurveyWallAvailableListener;
}
