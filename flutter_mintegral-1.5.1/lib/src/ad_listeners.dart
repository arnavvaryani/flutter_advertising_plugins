import 'package:flutter/foundation.dart';

import 'ad_containers.dart';

/// The callback type to handle an event occurring for an [Ad].
typedef AdEventCallback = void Function(Ad ad);

/// The callback type to handle an error loading an [Ad].
typedef AdErrorCallback = void Function(Ad ad, String error);

/// Generic callback type for an event occurring on an Ad.
typedef GenericAdEventCallback<Ad> = void Function(Ad ad);

/// A callback type for when dismissed a splash ad.
typedef SplashAdDismissedCallback<Ad> = void Function(Ad ad, DismissType type);

/// A callback type for when dismissed a rewarded ad.
typedef RewardedAdDismissedCallback<Ad> = void Function(Ad ad, RewardInfo rewardInfo);

/// A callback type for when an error occurs loading a full screen ad.
typedef FullScreenAdLoadErrorCallback = void Function(String error);

/// Shared event callbacks used in Banner ads.
abstract class AdWithViewListener {
  /// Default constructor for [AdWithViewListener], meant to be used by subclasses.
  @protected
  const AdWithViewListener({
    this.onAdLoaded,
    this.onAdFailedToLoad,
    this.onAdImpression,
    this.onAdClicked,
    this.onAdClosed,
    this.onAdLeftApplication,
  });

  /// Called when the ad has been successfully loaded.
  final AdEventCallback? onAdLoaded;

  /// Called when an error occurs while attempting to load an ad.
  final AdErrorCallback? onAdFailedToLoad;

  /// Called when the ad is first rendered on device.
  /// Please use this callback to track impressions.
  final AdEventCallback? onAdImpression;

  /// Called when the user has clicked the ad.
  final AdEventCallback? onAdClicked;

  /// Called when the ad is closed.
  final AdEventCallback? onAdClosed;

  /// Called when leaved app after clicked the ad.
  final AdEventCallback? onAdLeftApplication;
}

/// A listener for receiving notifications for the lifecycle of a [BannerAd].
class BannerAdListener extends AdWithViewListener {
  /// Constructs a [BannerAdListener] that notifies for the provided event callbacks.
  ///
  /// Typically you will override [onAdLoaded] and [onAdFailedToLoad]:
  /// ```dart
  /// BannerAdListener(
  ///   onAdLoaded: (ad) {
  ///     // Ad successfully loaded - display an AdWidget with the banner ad.
  ///   },
  ///   onAdFailedToLoad: (ad, error) {
  ///     // Ad failed to load - log the error and dispose the ad.
  ///   },
  ///   ...
  /// )
  /// ```
  const BannerAdListener({
    AdEventCallback? onAdLoaded,
    AdErrorCallback? onAdFailedToLoad,
    AdEventCallback? onAdImpression,
    AdEventCallback? onAdClicked,
    AdEventCallback? onAdClosed,
    AdEventCallback? onAdLeftApplication,
  }) : super(
    onAdLoaded: onAdLoaded,
    onAdFailedToLoad: onAdFailedToLoad,
    onAdImpression: onAdImpression,
    onAdClicked: onAdClicked,
    onAdClosed: onAdClosed,
    onAdLeftApplication: onAdLeftApplication,
  );
}

/// Callback events for for splash ads.
class SplashContentCallback<Ad> {
  /// Construct a new [SplashContentCallback].
  ///
  /// [Ad.dispose] should be called from [onAdFailedToShowFullScreenContent]
  /// and [onAdDismissedFullScreenContent], in order to free up resources.
  const SplashContentCallback({
    this.onAdShowedFullScreenContent,
    this.onAdFailedToShowFullScreenContent,
    this.onAdDismissedFullScreenContent,
    this.onAdClicked,
  });

  /// Called when an ad shows full screen content.
  final GenericAdEventCallback<Ad>? onAdShowedFullScreenContent;

  /// Called when an ad dismisses full screen content.
  final SplashAdDismissedCallback<Ad>? onAdDismissedFullScreenContent;

  /// Called when an ad is clicked.
  final GenericAdEventCallback<Ad>? onAdClicked;

  /// Called when ad fails to show full screen content.
  final void Function(Ad ad, String error)? onAdFailedToShowFullScreenContent;
}

/// Callback events for for full screen ads, such as Rewarded and Interstitial.
class FullScreenContentCallback<Ad> {
  /// Construct a new [FullScreenContentCallback].
  ///
  /// [Ad.dispose] should be called from [onAdFailedToShowFullScreenContent]
  /// and [onAdDismissedFullScreenContent], in order to free up resources.
  const FullScreenContentCallback({
    this.onAdShowedFullScreenContent,
    this.onAdFailedToShowFullScreenContent,
    this.onAdDismissedFullScreenContent,
    this.onAdClicked,
    this.onAdCompleted,
    this.onAdEndCardShowed,
  });

  /// Called when an ad shows full screen content.
  final GenericAdEventCallback<Ad>? onAdShowedFullScreenContent;

  /// Called when an ad dismisses full screen content.
  final RewardedAdDismissedCallback<Ad>? onAdDismissedFullScreenContent;

  /// Called when an ad is clicked.
  final GenericAdEventCallback<Ad>? onAdClicked;

  /// Called when an ad is completed.
  final GenericAdEventCallback<Ad>? onAdCompleted;

  /// Called when an ad shows end card.
  final GenericAdEventCallback<Ad>? onAdEndCardShowed;

  /// Called when ad fails to show full screen content.
  final void Function(Ad ad, String error)? onAdFailedToShowFullScreenContent;
}

/// Generic parent class for ad load callbacks.
abstract class FullScreenAdLoadCallback<T> {
  /// Default constructor for [FullScreenAdLoadCallback[, used by subclasses.
  const FullScreenAdLoadCallback({
    required this.onAdLoaded,
    required this.onAdFailedToLoad,
  });

  /// Called when the ad successfully loads.
  final GenericAdEventCallback<T> onAdLoaded;

  /// Called when an error occurs loading the ad.
  final FullScreenAdLoadErrorCallback onAdFailedToLoad;
}

/// This class holds callbacks for loading a [RewardVideoAd].
class RewardedAdLoadCallback extends FullScreenAdLoadCallback<RewardVideoAd> {
  /// Construct a [RewardedAdLoadCallback].
  const RewardedAdLoadCallback({
    required GenericAdEventCallback<RewardVideoAd> onAdLoaded,
    required FullScreenAdLoadErrorCallback onAdFailedToLoad,
  }) : super(onAdLoaded: onAdLoaded, onAdFailedToLoad: onAdFailedToLoad);
}

/// This class holds callbacks for loading a [InterstitialAd].
class InterstitialAdLoadCallback extends FullScreenAdLoadCallback<InterstitialAd> {
  /// Construct a [InterstitialAdLoadCallback].
  const InterstitialAdLoadCallback({
    required GenericAdEventCallback<InterstitialAd> onAdLoaded,
    required FullScreenAdLoadErrorCallback onAdFailedToLoad,
  }) : super(onAdLoaded: onAdLoaded, onAdFailedToLoad: onAdFailedToLoad);
}

/// This class holds callbacks for loading an [SplashAd].
class SplashAdLoadCallback extends FullScreenAdLoadCallback<SplashAd> {
  /// Construct an [SplashAdLoadCallback].
  const SplashAdLoadCallback({
    required GenericAdEventCallback<SplashAd> onAdLoaded,
    required FullScreenAdLoadErrorCallback onAdFailedToLoad,
  }) : super(onAdLoaded: onAdLoaded, onAdFailedToLoad: onAdFailedToLoad);
}