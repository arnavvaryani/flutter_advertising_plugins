import Flutter
import UIKit
import MintegralAdSDK

// IMPORTANT: The Mintegral iOS SDK delegate protocol/selector names below follow
// the official MTGSDK 8.x documentation, but could not be compile-verified in this
// environment. Verify each delegate method signature against the SDK headers
// (MTGRewardAdLoadDelegate / MTGRewardAdShowDelegate / MTGNewInterstitialAdDelegate /
// MTGSplashADDelegate / MTGBannerAdViewDelegate) and adjust as needed.

private func ids(_ placementId: String, _ unitId: String, _ bidToken: String = "") -> FLTMBridgeIds {
  FLTMBridgeIds(placementId: placementId, unitId: unitId, bidToken: bidToken)
}

// MARK: - Rewarded video

final class FLTRewardVideoAd: NSObject, FLTOverlayAd, MTGRewardAdLoadDelegate, MTGRewardAdShowDelegate {
  private let adId: Int
  private unowned let manager: FLTAdInstanceManager
  private let placementId: String
  private let unitId: String
  private let rootViewControllerProvider: () -> UIViewController?
  var isRewardPlus: Bool = false

  init(adId: Int, manager: FLTAdInstanceManager, placementId: String, unitId: String,
       rootViewControllerProvider: @escaping () -> UIViewController?) {
    self.adId = adId
    self.manager = manager
    self.placementId = placementId
    self.unitId = unitId
    self.rootViewControllerProvider = rootViewControllerProvider
  }

  func load() {
    MTGRewardAdManager.sharedInstance().loadVideo(
      withPlacementId: placementId, unitId: unitId, delegate: self)
  }

  func show() {
    guard let vc = rootViewControllerProvider() else {
      manager.onFailedToShowFullScreenContent(adId, ids(placementId, unitId), "No root view controller")
      return
    }
    MTGRewardAdManager.sharedInstance().showVideo(
      withPlacementId: placementId, unitId: unitId, userId: nil, userExtra: nil,
      delegate: self, viewController: vc)
  }

  func dispose() {}

  // MARK: MTGRewardAdLoadDelegate
  func onVideoAdLoadSuccess(_ placementId: String?, unitId: String?) {
    manager.onAdLoaded(adId, ids(placementId ?? self.placementId, unitId ?? self.unitId))
  }
  func onVideoAdLoadFailed(_ placementId: String?, unitId: String?, error: Error) {
    manager.onAdFailedToLoad(adId, ids(placementId ?? self.placementId, unitId ?? self.unitId),
                             error.localizedDescription)
  }

  // MARK: MTGRewardAdShowDelegate
  func onVideoAdShowSuccess(_ placementId: String?, unitId: String?) {
    manager.onAdShowedFullScreenContent(adId, ids(placementId ?? self.placementId, unitId ?? self.unitId))
  }
  func onVideoAdShowFailed(_ placementId: String?, unitId: String?, error: Error) {
    manager.onFailedToShowFullScreenContent(adId, ids(placementId ?? self.placementId, unitId ?? self.unitId),
                                            error.localizedDescription)
  }
  func onVideoAdClicked(_ placementId: String?, unitId: String?) {
    manager.onAdClicked(adId, ids(placementId ?? self.placementId, unitId ?? self.unitId))
  }
  func onVideoPlayCompleted(_ placementId: String?, unitId: String?) {
    manager.onAdCompleted(adId, ids(placementId ?? self.placementId, unitId ?? self.unitId))
  }
  func onVideoEndCardShowSuccess(_ placementId: String?, unitId: String?) {
    manager.onAdEndCardShowed(adId, ids(placementId ?? self.placementId, unitId ?? self.unitId))
  }
  func onVideoAdDismissed(_ placementId: String?, unitId: String?, withConverted converted: Bool,
                          withRewardInfo rewardInfo: MTGRewardAdInfo?) {
    let info = FLTRewardInfo(
      isCompleteView: converted,
      rewardName: rewardInfo?.rewardName ?? "",
      rewardAmount: rewardInfo?.rewardAmount ?? "",
      rewardAlertStatus: 0)
    manager.onAdDismissedFullScreenContent(
      adId, ids(placementId ?? self.placementId, unitId ?? self.unitId), rewardInfo: info)
  }
}

// MARK: - Interstitial (new interstitial)

final class FLTInterstitialAd: NSObject, FLTOverlayAd, MTGNewInterstitialAdDelegate {
  private let adId: Int
  private unowned let manager: FLTAdInstanceManager
  private let placementId: String
  private let unitId: String
  private let rootViewControllerProvider: () -> UIViewController?
  private var adManager: MTGNewInterstitialAdManager?

  init(adId: Int, manager: FLTAdInstanceManager, placementId: String, unitId: String,
       rootViewControllerProvider: @escaping () -> UIViewController?) {
    self.adId = adId
    self.manager = manager
    self.placementId = placementId
    self.unitId = unitId
    self.rootViewControllerProvider = rootViewControllerProvider
  }

  func load() {
    let m = MTGNewInterstitialAdManager(placementId: placementId, unitId: unitId, delegate: self)
    adManager = m
    m.loadAd()
  }

  func show() {
    guard let vc = rootViewControllerProvider() else {
      manager.onFailedToShowFullScreenContent(adId, ids(placementId, unitId), "No root view controller")
      return
    }
    adManager?.show(from: vc)
  }

  func dispose() { adManager = nil }

  // MARK: MTGNewInterstitialAdDelegate
  func newInterstitialAdLoadSuccess(_ adManager: MTGNewInterstitialAdManager) {
    manager.onAdLoaded(adId, ids(placementId, unitId))
  }
  func newInterstitialAdLoadFail(_ error: Error, adManager: MTGNewInterstitialAdManager) {
    manager.onAdFailedToLoad(adId, ids(placementId, unitId), error.localizedDescription)
  }
  func newInterstitialAdShowSuccess(_ adManager: MTGNewInterstitialAdManager) {
    manager.onAdShowedFullScreenContent(adId, ids(placementId, unitId))
  }
  func newInterstitialAdShowFail(_ error: Error, adManager: MTGNewInterstitialAdManager) {
    manager.onFailedToShowFullScreenContent(adId, ids(placementId, unitId), error.localizedDescription)
  }
  func newInterstitialAdClicked(_ adManager: MTGNewInterstitialAdManager) {
    manager.onAdClicked(adId, ids(placementId, unitId))
  }
  func newInterstitialAdDidClosed(_ adManager: MTGNewInterstitialAdManager) {
    let info = FLTRewardInfo(isCompleteView: false, rewardName: "", rewardAmount: "", rewardAlertStatus: 0)
    manager.onAdDismissedFullScreenContent(adId, ids(placementId, unitId), rewardInfo: info)
  }
  func newInterstitialAdPlayCompleted(_ adManager: MTGNewInterstitialAdManager) {
    manager.onAdCompleted(adId, ids(placementId, unitId))
  }
  func newInterstitialAdEndCardShowSuccess(_ adManager: MTGNewInterstitialAdManager) {
    manager.onAdEndCardShowed(adId, ids(placementId, unitId))
  }
}

// MARK: - Splash

final class FLTSplashAd: NSObject, FLTOverlayAd, MTGSplashADDelegate {
  private let adId: Int
  private unowned let manager: FLTAdInstanceManager
  private let placementId: String
  private let unitId: String
  private var splashAD: MTGSplashAD?

  init(adId: Int, manager: FLTAdInstanceManager, placementId: String, unitId: String) {
    self.adId = adId
    self.manager = manager
    self.placementId = placementId
    self.unitId = unitId
  }

  func load() {
    let ad = MTGSplashAD(placementID: placementId, unitID: unitId)
    ad.delegate = self
    splashAD = ad
    ad.preload()
  }

  func show() {
    guard let window = UIApplication.shared.keyWindow else {
      manager.onFailedToShowFullScreenContent(adId, ids(placementId, unitId), "No key window")
      return
    }
    splashAD?.show(in: window, customView: nil)
  }

  func dispose() { splashAD = nil }

  // MARK: MTGSplashADDelegate
  func splashADPreloadSuccess(_ splashAD: MTGSplashAD) {
    manager.onAdLoaded(adId, ids(placementId, unitId))
  }
  func splashADPreloadFail(_ error: Error, splashAD: MTGSplashAD) {
    manager.onAdFailedToLoad(adId, ids(placementId, unitId), error.localizedDescription)
  }
  func splashADShowSuccess(_ splashAD: MTGSplashAD) {
    manager.onAdShowedFullScreenContent(adId, ids(placementId, unitId))
  }
  func splashADShowFail(_ error: Error, splashAD: MTGSplashAD) {
    manager.onFailedToShowFullScreenContent(adId, ids(placementId, unitId), error.localizedDescription)
  }
  func splashADClicked(_ splashAD: MTGSplashAD) {
    manager.onAdClicked(adId, ids(placementId, unitId))
  }
  func splashADDidClose(_ splashAD: MTGSplashAD, withType type: Int) {
    // type: 1 skipped, 2 completed, 3 leaveApp (mirrors Android DismissType mapping).
    manager.onAdDismissedFullScreenContent(adId, ids(placementId, unitId), type: type)
  }
}

// MARK: - Banner (platform view)

final class FLTBannerAd: NSObject, FLTAd, MTGBannerAdViewDelegate {
  private let adId: Int
  private unowned let manager: FLTAdInstanceManager
  private let placementId: String
  private let unitId: String
  let size: FLTAdSize
  private let rootViewControllerProvider: () -> UIViewController?
  private(set) var bannerView: MTGBannerAdView?

  init(adId: Int, manager: FLTAdInstanceManager, placementId: String, unitId: String,
       size: FLTAdSize, rootViewControllerProvider: @escaping () -> UIViewController?) {
    self.adId = adId
    self.manager = manager
    self.placementId = placementId
    self.unitId = unitId
    self.size = size
    self.rootViewControllerProvider = rootViewControllerProvider
  }

  func load() {
    let adSize = CGSize(width: size.width, height: size.height)
    let view = MTGBannerAdView(
      bannerAdViewWithAdSize: adSize, placementId: placementId, unitId: unitId,
      rootViewController: rootViewControllerProvider())
    view.delegate = self
    view.autoRefreshTime = 0
    bannerView = view
    view.loadBannerAd()
  }

  func dispose() { bannerView = nil }

  // MARK: MTGBannerAdViewDelegate
  func adViewLoadSuccess(_ adView: MTGBannerAdView) {
    manager.onAdLoaded(adId, ids(placementId, unitId))
  }
  func adViewLoadFailedWithError(_ error: Error, adView: MTGBannerAdView) {
    manager.onAdFailedToLoad(adId, ids(placementId, unitId), error.localizedDescription)
  }
  func adViewWillLogImpression(_ adView: MTGBannerAdView) {
    manager.onAdImpression(adId, ids(placementId, unitId))
  }
  func adViewDidClicked(_ adView: MTGBannerAdView) {
    manager.onAdClicked(adId, ids(placementId, unitId))
  }
  func adViewClosed(_ adView: MTGBannerAdView) {
    manager.onAdClosed(adId, ids(placementId, unitId))
  }
  func adViewWillLeaveApplication(_ adView: MTGBannerAdView) {
    manager.onAdLeftApplication(adId, ids(placementId, unitId))
  }
}

// MARK: - Platform view factory (mirrors MintegralAdsViewFactory.java)

final class FLTMintegralAdViewFactory: NSObject, FlutterPlatformViewFactory {
  private unowned let manager: FLTAdInstanceManager

  init(manager: FLTAdInstanceManager) {
    self.manager = manager
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    FlutterStandardMessageCodec(readerWriter: FLTAdReaderWriter())
  }

  func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?)
    -> FlutterPlatformView {
    let adId = (args as? Int) ?? -1
    let banner = (manager.ad(for: adId) as? FLTBannerAd)?.bannerView
    return FLTPlatformView(view: banner ?? UIView(frame: frame))
  }
}

final class FLTPlatformView: NSObject, FlutterPlatformView {
  private var _view: UIView
  init(view: UIView) {
    _view = view
  }
  func view() -> UIView { _view }
}
