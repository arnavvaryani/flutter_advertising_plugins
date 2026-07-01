import 'dart:async';

import 'package:flutter/services.dart';

/// A reward (transaction) granted to the user, mirroring `TRReward` on both
/// native SDKs. Rewards are delivered as a batched list via [onRewards].
class TRReward {
  TRReward({
    required this.transactionIdentifier,
    required this.placementIdentifier,
    required this.placementTag,
    required this.currencyName,
    required this.rewardAmount,
    required this.payoutEventType,
  });

  /// Unique transaction id. Use this to de-duplicate rewards on your side.
  final String transactionIdentifier;
  final String placementIdentifier;
  final String placementTag;
  final String currencyName;
  final int rewardAmount;
  final String payoutEventType;

  factory TRReward.fromMap(Map<dynamic, dynamic> map) => TRReward(
        transactionIdentifier: map['transactionIdentifier']?.toString() ?? '',
        placementIdentifier: map['placementIdentifier']?.toString() ?? '',
        placementTag: map['placementTag']?.toString() ?? '',
        currencyName: map['currencyName']?.toString() ?? '',
        rewardAmount: (map['rewardAmount'] as num?)?.toInt() ?? 0,
        payoutEventType: map['payoutEventType']?.toString() ?? '',
      );

  @override
  String toString() =>
      'TRReward(transactionIdentifier: $transactionIdentifier, '
      'placementTag: $placementTag, currencyName: $currencyName, '
      'rewardAmount: $rewardAmount)';
}

/// An error surfaced by the native TapResearch SDK.
class TapResearchError {
  TapResearchError(this.code, this.message);
  final String code;
  final String message;

  @override
  String toString() => 'TapResearchError($code, $message)';
}

typedef RewardsListener = void Function(List<TRReward> rewards);
typedef SdkReadyListener = void Function();
typedef ErrorListener = void Function(TapResearchError error);
typedef ContentShownListener = void Function(String placementTag);
typedef ContentDismissedListener = void Function(String placementTag);

/// Flutter wrapper for the TapResearch SDK 3.x.
///
/// Usage:
/// ```dart
/// final tr = TapResearch.instance;
/// tr.setRewardsListener((rewards) { /* credit the user */ });
/// await tr.initialize(apiToken: '...', userIdentifier: 'user-123');
/// if (await tr.canShowContentForPlacement('my_placement')) {
///   await tr.showContentForPlacement('my_placement');
/// }
/// ```
class TapResearch {
  TapResearch._(this._channel) {
    _channel.setMethodCallHandler(_handlePlatformCall);
  }

  static final TapResearch _instance =
      TapResearch._(const MethodChannel('flutter_tapresearch'));

  static TapResearch get instance => _instance;

  final MethodChannel _channel;

  RewardsListener? _rewardsListener;
  SdkReadyListener? _sdkReadyListener;
  ErrorListener? _errorListener;
  ContentShownListener? _contentShownListener;
  ContentDismissedListener? _contentDismissedListener;

  /// Called whenever the SDK delivers one or more rewards.
  void setRewardsListener(RewardsListener listener) =>
      _rewardsListener = listener;

  /// Called once the SDK has finished initializing and is ready to show content.
  void setSdkReadyListener(SdkReadyListener listener) =>
      _sdkReadyListener = listener;

  /// Called when the native SDK reports an error.
  void setErrorListener(ErrorListener listener) => _errorListener = listener;

  /// Called when a content view (survey wall, offer, etc.) is presented.
  void setContentShownListener(ContentShownListener listener) =>
      _contentShownListener = listener;

  /// Called when a content view is dismissed.
  void setContentDismissedListener(ContentDismissedListener listener) =>
      _contentDismissedListener = listener;

  /// Initializes the SDK. Both [apiToken] and [userIdentifier] are required by
  /// the 3.x SDK. Register your listeners (e.g. [setRewardsListener]) before
  /// calling this so you don't miss early callbacks.
  Future<void> initialize({
    required String apiToken,
    required String userIdentifier,
  }) async {
    assert(apiToken.isNotEmpty, 'apiToken must not be empty');
    assert(userIdentifier.isNotEmpty, 'userIdentifier must not be empty');
    await _channel.invokeMethod<void>('initialize', <String, dynamic>{
      'apiToken': apiToken,
      'userIdentifier': userIdentifier,
    });
  }

  /// Whether the SDK has finished initializing.
  Future<bool> isReady() async {
    final ready = await _channel.invokeMethod<bool>('isReady');
    return ready ?? false;
  }

  /// Whether content is currently available for [placementTag].
  Future<bool> canShowContentForPlacement(String placementTag) async {
    final canShow = await _channel.invokeMethod<bool>(
      'canShowContentForPlacement',
      <String, dynamic>{'placementTag': placementTag},
    );
    return canShow ?? false;
  }

  /// Presents content (survey wall, offers, etc.) for [placementTag].
  /// Optional [customParameters] are forwarded to the native SDK.
  Future<void> showContentForPlacement(
    String placementTag, {
    Map<String, dynamic>? customParameters,
  }) async {
    await _channel.invokeMethod<void>(
      'showContentForPlacement',
      <String, dynamic>{
        'placementTag': placementTag,
        'customParameters': customParameters ?? <String, dynamic>{},
      },
    );
  }

  /// Updates the unique user identifier after initialization.
  Future<void> setUserIdentifier(String userIdentifier) async {
    await _channel.invokeMethod<void>(
      'setUserIdentifier',
      <String, dynamic>{'userIdentifier': userIdentifier},
    );
  }

  /// Sends custom user attributes to TapResearch for targeting.
  Future<void> sendUserAttributes(Map<String, dynamic> attributes) async {
    await _channel.invokeMethod<void>(
      'sendUserAttributes',
      <String, dynamic>{'attributes': attributes},
    );
  }

  Future<dynamic> _handlePlatformCall(MethodCall call) async {
    switch (call.method) {
      case 'onRewards':
        final raw = (call.arguments as List<dynamic>?) ?? const [];
        final rewards = raw
            .map((e) => TRReward.fromMap(e as Map<dynamic, dynamic>))
            .toList();
        _rewardsListener?.call(rewards);
        break;
      case 'onSdkReady':
        _sdkReadyListener?.call();
        break;
      case 'onError':
        final args = (call.arguments as Map<dynamic, dynamic>?) ?? const {};
        _errorListener?.call(TapResearchError(
          args['code']?.toString() ?? 'unknown',
          args['message']?.toString() ?? '',
        ));
        break;
      case 'onContentShown':
        _contentShownListener?.call(call.arguments?.toString() ?? '');
        break;
      case 'onContentDismissed':
        _contentDismissedListener?.call(call.arguments?.toString() ?? '');
        break;
      default:
        // Unknown callback — ignore so older/newer native layers stay compatible.
        break;
    }
  }
}
