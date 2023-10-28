import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

typedef OnRewardListener = void Function(int? quantity);
typedef SurveyAvailableListener = void Function(int? survey);
typedef RewardCenterOpenedListener = void Function();
typedef RewardCenterClosedListener = void Function();

class TheoremReach {
  static TheoremReach get instance => _instance;

  final MethodChannel _channel;

  static final TheoremReach _instance = TheoremReach.private(
    const MethodChannel('theoremreach'),
  );

  TheoremReach.private(MethodChannel channel) : _channel = channel {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  static late OnRewardListener _onRewardListener;
  static late SurveyAvailableListener _surveyAvailableListener;
  static late RewardCenterOpenedListener _rewardCenterOpenedListener;
  static late RewardCenterClosedListener _rewardCenterClosedListener;

  Future<void> init({String? apiToken, String? userId}) async {
    assert(apiToken != null && apiToken.isNotEmpty);
    return _channel.invokeMethod(
        "init", <String, dynamic>{"api_token": apiToken, "user_id": userId});
  }

  Future<void> show({String? placementID}) {
    return _channel
        .invokeMethod("show", <String, dynamic>{"placementID": placementID});
  }

  Future<void> setNavBarText({String? text}) {
    return _channel
        .invokeMethod('setNavBarText', <String, dynamic>{'text': text});
  }

  Future<void> setNavBarColor({String? color}) {
    return _channel
        .invokeMethod('setNavBarColor', <String, dynamic>{'color': color});
  }

  Future<void> setNavBarTextColor({String? textColor}) {
    return _channel.invokeMethod(
        'setNavBarTextColor', <String, dynamic>{'text_color': textColor});
  }

  Future _platformCallHandler(MethodCall call) async {
    debugPrint(
        "TheoremReach _platformCallHandler call ${call.method} ${call.arguments}");

    switch (call.method) {
      case "onReward":
        _onRewardListener(call.arguments);
        break;

      case "theoremReachSurveyAvailable":
        _surveyAvailableListener(call.arguments);
        break;

      case "onRewardCenterOpened":
        _rewardCenterOpenedListener();
        break;

      case "onRewardCenterClosed":
        _rewardCenterClosedListener();
        break;
      default:
        debugPrint('Unknown method ${call.method}');
    }
  }

  void setOnRewardListener(OnRewardListener onRewardListener) =>
      _onRewardListener = onRewardListener;

  void setSurveyAvaiableListener(
          SurveyAvailableListener surveyAvailableListener) =>
      _surveyAvailableListener = surveyAvailableListener;

  void setRewardCenterOpened(
          RewardCenterOpenedListener rewardCenterOpenedListener) =>
      _rewardCenterOpenedListener = rewardCenterOpenedListener;

  void setRewardCenterClosed(
          RewardCenterClosedListener rewardCenterClosedListener) =>
      _rewardCenterClosedListener = rewardCenterClosedListener;
}
