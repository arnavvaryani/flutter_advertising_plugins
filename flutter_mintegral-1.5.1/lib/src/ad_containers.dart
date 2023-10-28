import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ad_instance_manager.dart';
import 'ad_listeners.dart';

enum DismissType {invalid, skipped, completed, leaveApp}

/// Contains information about the loaded ad.
///
/// For debugging and logging purposes.
class MBridgeIds {
  /// Constructs a [MBridgeIds] with the [placementId], [unitId] and [bidToken].
  @protected
  const MBridgeIds({
    required this.placementId, required this.unitId, required this.bidToken});

  final String placementId;

  final String unitId;

  final String bidToken;

  @override
  String toString() {
    return '$runtimeType(placementId: $placementId, unitId: $unitId, '
        'bidToken: $bidToken)';
  }
}

/// [AdSize] represents the size of a banner ad.
class AdSize {
  /// Constructs an [AdSize] with the given [width] and [height].
  const AdSize({
    required this.width,
    required this.height,
  });

  /// The vertical span of an ad.
  final int height;

  /// The horizontal span of an ad.
  final int width;

  /// Represents the fixed banner ad size - 320dp by 90dp.
  static const AdSize large = AdSize(width: 320, height: 90);

  /// Represents the fixed banner ad size - 300dp by 250dp.
  static const AdSize medium = AdSize(width: 300, height: 250);

  /// Represents the fixed banner ad size - 320dp by 50dp.
  static const AdSize standard = AdSize(width: 320, height: 50);

  @override
  bool operator ==(Object other) {
    return other is AdSize && width == other.width && height == other.height;
  }

  @override
  int get hashCode => width.hashCode * 31 + height.hashCode;

}

/// The base class for all ads.
///
/// A valid [placementId] and [unitId] is required.
abstract class Ad {
  /// Default constructor, used by subclasses.
  Ad({required this.placementId, required this.unitId});

  final String placementId;

  final String unitId;

  Future<void> onPause() {
    return instanceManager.onPause(this);
  }

  Future<void> onResume() {
    return instanceManager.onResume(this);
  }

  /// Frees the plugin resources associated with this ad.
  Future<void> dispose() {
    return instanceManager.disposeAd(this);
  }

  MBridgeIds? mBridgeIds;
}

/// Base class for mobile [Ad] that has an in-line view.
///
/// A valid [placementId] and [unitId] are required.
abstract class AdWithView extends Ad {
  /// Default constructor, used by subclasses.
  AdWithView({
    required String placementId,
    required String unitId,
    required this.listener})
      : super(placementId: placementId, unitId: unitId);

  /// The [AdWithViewListener] for the ad.
  final AdWithViewListener listener;

  /// Starts loading this ad.
  ///
  /// Loading callbacks are sent to this [Ad]'s [listener].
  Future<void> load();
}

/// An [Ad] that is overlaid on top of the UI.
abstract class AdWithoutView extends Ad {
  /// Default constructor used by subclasses.
  AdWithoutView({required String placementId, required String unitId})
      : super(placementId: placementId, unitId: unitId);
}

/// Displays an [Ad] as a Flutter widget.
///
/// This widget takes ads inheriting from [AdWithView]
/// (e.g. [BannerAd]) and allows them to be added to the Flutter
/// widget tree.
///
/// Must call `load()` first before showing the widget. Otherwise, a
/// [PlatformException] will be thrown.
class AdWidget extends StatefulWidget {
  /// Default constructor for [AdWidget].
  ///
  /// [ad] must be loaded before this is added to the widget tree.
  const AdWidget({Key? key, required this.ad}) : super(key: key);

  /// Ad to be displayed as a widget.
  final AdWithView ad;

  @override
  AdWidgetState createState() => AdWidgetState();
}

class AdWidgetState extends State<AdWidget> {
  bool _adIdAlreadyMounted = false;
  bool _adLoadNotCalled = false;

  @override
  void initState() {
    super.initState();
    final int? adId = instanceManager.adIdFor(widget.ad);
    if (adId != null) {
      if (instanceManager.isWidgetAdIdMounted(adId)) {
        _adIdAlreadyMounted = true;
      }
      instanceManager.mountWidgetAdId(adId);
    } else {
      _adLoadNotCalled = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    final int? adId = instanceManager.adIdFor(widget.ad);
    if (adId != null) {
      instanceManager.unmountWidgetAdId(adId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_adIdAlreadyMounted) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('This AdWidget is already in the Widget tree'),
        ErrorHint(
            'If you placed this AdWidget in a list, make sure you create a new instance '
                'in the builder function with a unique ad object.'),
        ErrorHint(
            'Make sure you are not using the same ad object in more than one AdWidget.'),
      ]);
    }
    if (_adLoadNotCalled) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary(
            'AdWidget requires Ad.load to be called before AdWidget is inserted into the tree'),
        ErrorHint(
            'Parameter ad is not loaded. Call Ad.load before AdWidget is inserted into the tree.'),
      ]);
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      AdSize? size;
      if (widget.ad is BannerAd) {
        size = (widget.ad as BannerAd).size;
      }
      return SizedBox(
        width: size?.width.toDouble(),
        height: size?.height.toDouble(),
        child: AndroidView(
          viewType: '${instanceManager.channel.name}/ad_widget',
          layoutDirection: TextDirection.ltr,
          creationParams: instanceManager.adIdFor(widget.ad),
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    }

    return UiKitView(
      viewType: '${instanceManager.channel.name}/ad_widget',
      creationParams: instanceManager.adIdFor(widget.ad),
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}

/// A banner ad.
///
/// This ad can either be overlaid on top of all flutter widgets as a static
/// view or displayed as a typical Flutter widget. To display as a widget,
/// instantiate an [AdWidget] with this as a parameter.
class BannerAd extends AdWithView {
  /// Creates a [BannerAd].
  ///
  /// A valid [placementId], [unitId], nonnull [listener], and nonnull size is required.
  BannerAd({
    required this.size,
    required String placementId,
    required String unitId,
    required this.listener,
  }) : super(placementId: placementId, unitId: unitId, listener: listener);

  /// Represents the size of a banner ad.
  final AdSize size;

  /// A listener for receiving events in the ad lifecycle.
  @override
  // ignore: overridden_fields
  final BannerAdListener listener;

  @override
  Future<void> load() async {
    await instanceManager.loadBannerAd(this);
  }

  /// Returns the AdSize of the associated platform ad object.
  ///
  /// The dimensions of the [AdSize] returned here may differ from [size],
  /// depending on what type of [AdSize] was used.
  /// The future will resolve to null if [load] has not been called yet.
  Future<AdSize?> getPlatformAdSize() async {
    return await instanceManager.getAdSize(this);
  }
}

/// A full-screen app open ad for the Mintegral Plugin.
class SplashAd extends AdWithoutView {

  SplashAd._({
    required String placementId,
    required String unitId,
    required this.adLoadCallback,
  })  : super(placementId: placementId, unitId: unitId);

  /// Listener for ad load events.
  final SplashAdLoadCallback adLoadCallback;

  /// Callbacks to be invoked when ads show and dismiss full screen content.
  SplashContentCallback<SplashAd>? splashContentCallback;

  static Future<void> load({
    required String placementId,
    required String unitId,
    required SplashAdLoadCallback adLoadCallback,
  }) async {
    SplashAd splashAd = SplashAd._(
      placementId: placementId,
      unitId: unitId,
      adLoadCallback: adLoadCallback,
    );

    await instanceManager.loadSplashAd(splashAd);
  }

  /// Display this on top of the application.
  ///
  /// Set [splashContentCallback] before calling this method to be
  /// notified of events that occur when showing the ad.
  Future<void> show() {
    return instanceManager.showAdWithoutView(this);
  }
}

/// A full-screen interstitial ad for the Mintegral Plugin.
class InterstitialAd extends AdWithoutView {
  /// Creates an [InterstitialAd].
  ///
  /// A valid [placementId] and [unitId] from the Mintegral dashboard,
  /// and a nonnull [adLoadCallback] is required.
  InterstitialAd._({
    required String placementId,
    required String unitId,
    required this.adLoadCallback,
  }) : super(placementId: placementId, unitId: unitId);

  /// Callback to be invoked when the ad finishes loading.
  final InterstitialAdLoadCallback adLoadCallback;

  /// Callbacks to be invoked when ads show and dismiss full screen content.
  FullScreenContentCallback<InterstitialAd>? fullScreenContentCallback;

  /// Loads an [InterstitialAd] with the given [placementId] and [unitId].
  static Future<void> load({
    required String placementId,
    required String unitId,
    required InterstitialAdLoadCallback adLoadCallback,
  }) async {
    InterstitialAd ad = InterstitialAd._(
      placementId: placementId,
      unitId: unitId,
      adLoadCallback: adLoadCallback,
    );

    await instanceManager.loadInterstitialAd(ad);
  }

  /// Displays this on top of the application.
  ///
  /// Set [fullScreenContentCallback] before calling this method to be
  /// notified of events that occur when showing the ad.
  Future<void> show() {
    return instanceManager.showAdWithoutView(this);
  }
}

/// An [Ad] where a user has the option of interacting with in exchange for in-app rewards.
///
/// Because the video assets are so large, it's a good idea to start loading an
/// ad well in advance of when it's likely to be needed.
class RewardVideoAd extends AdWithoutView {

  RewardVideoAd._({
    required String placementId,
    required String unitId,
    required this.rewardedAdLoadCallback,
    this.isRewardPlus,
  })  : super(placementId: placementId, unitId: unitId);

  /// Callbacks for events that occur when attempting to load an ad.
  final RewardedAdLoadCallback rewardedAdLoadCallback;

  /// Callbacks to be invoked when ads show and dismiss full screen content.
  FullScreenContentCallback<RewardVideoAd>? fullScreenContentCallback;

  /// Accepting the advertisement of Reward plus
  final bool? isRewardPlus;

  /// Loads a [RewardVideoAd] using an [AdRequest].
  static Future<void> load({
    required String placementId,
    required String unitId,
    required RewardedAdLoadCallback rewardedAdLoadCallback,
    bool? isRewardPlus,
  }) async {
    RewardVideoAd rewardVideoAd = RewardVideoAd._(
      placementId: placementId,
      unitId: unitId,
      rewardedAdLoadCallback: rewardedAdLoadCallback,
      isRewardPlus: isRewardPlus,
    );

    await instanceManager.loadRewardVideoAd(rewardVideoAd);
  }

  /// Display this on top of the application.
  ///
  /// Set [fullScreenContentCallback] before calling this method to be
  /// notified of events that occur when showing the ad.
  Future<void> show() {
    return instanceManager.showAdWithoutView(this);
  }
}

/// Credit information about a reward received from a [RewardVideoAd] or
/// [InterstitialAd].
class RewardInfo {
  /// Default constructor for [RewardInfo].
  ///
  /// This is mostly used to return [RewardInfo]s for a [RewardVideoAd] or
  /// [InterstitialAd] and shouldn't be needed to be used directly.
  RewardInfo(
      this.isCompleteView,
      this.rewardName,
      this.rewardAmount,
      this.rewardAlertStatus);

  final bool isCompleteView;

  final String rewardName;

  final String rewardAmount;

  final int rewardAlertStatus;

  @override
  String toString() {
    return '$runtimeType(isCompleteView: $isCompleteView, '
        'rewardName: $rewardName, '
        'rewardAmount: $rewardAmount, '
        'rewardAlertStatus: $rewardAlertStatus)';
  }
}
