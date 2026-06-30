import Flutter
import UIKit
import MintegralAdSDK

// MARK: - Models (mirror the Android FlutterMBridgeIds / FlutterRewardInfo / FlutterAdSize)

final class FLTMBridgeIds {
  let placementId: String
  let unitId: String
  let bidToken: String
  init(placementId: String, unitId: String, bidToken: String) {
    self.placementId = placementId
    self.unitId = unitId
    self.bidToken = bidToken
  }
}

final class FLTRewardInfo {
  let isCompleteView: Bool
  let rewardName: String
  let rewardAmount: String
  let rewardAlertStatus: Int
  init(isCompleteView: Bool, rewardName: String, rewardAmount: String, rewardAlertStatus: Int) {
    self.isCompleteView = isCompleteView
    self.rewardName = rewardName
    self.rewardAmount = rewardAmount
    self.rewardAlertStatus = rewardAlertStatus
  }
}

final class FLTAdSize {
  let width: Int
  let height: Int
  init(width: Int, height: Int) {
    self.width = width
    self.height = height
  }
}

// MARK: - Custom codec (type bytes MUST match AdMessageCodec.java: 128/129/130)

private let valueMBridgeIds: UInt8 = 128
private let valueRewardInfo: UInt8 = 129
private let valueAdSize: UInt8 = 130

final class FLTAdReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
    case valueMBridgeIds:
      return FLTMBridgeIds(
        placementId: readValue() as? String ?? "",
        unitId: readValue() as? String ?? "",
        bidToken: readValue() as? String ?? "")
    case valueRewardInfo:
      return FLTRewardInfo(
        isCompleteView: readValue() as? Bool ?? false,
        rewardName: readValue() as? String ?? "",
        rewardAmount: readValue() as? String ?? "",
        rewardAlertStatus: (readValue() as? NSNumber)?.intValue ?? 0)
    case valueAdSize:
      return FLTAdSize(
        width: (readValue() as? NSNumber)?.intValue ?? 0,
        height: (readValue() as? NSNumber)?.intValue ?? 0)
    default:
      return super.readValue(ofType: type)
    }
  }
}

final class FLTAdWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let ids = value as? FLTMBridgeIds {
      writeByte(valueMBridgeIds)
      writeValue(ids.placementId)
      writeValue(ids.unitId)
      writeValue(ids.bidToken)
    } else if let info = value as? FLTRewardInfo {
      writeByte(valueRewardInfo)
      writeValue(info.isCompleteView)
      writeValue(info.rewardName)
      writeValue(info.rewardAmount)
      writeValue(info.rewardAlertStatus)
    } else if let size = value as? FLTAdSize {
      writeByte(valueAdSize)
      writeValue(size.width)
      writeValue(size.height)
    } else {
      super.writeValue(value)
    }
  }
}

final class FLTAdReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return FLTAdReader(data: data)
  }
  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return FLTAdWriter(data: data)
  }
}

// MARK: - Ad protocol

protocol FLTAd: AnyObject {
  func load()
  func dispose()
}

/// Ads that are shown over the app (rewarded, interstitial, splash).
protocol FLTOverlayAd: FLTAd {
  func show()
}

// MARK: - Instance manager (mirrors AdInstanceManager.java)

final class FLTAdInstanceManager {
  private let channel: FlutterMethodChannel
  private var ads: [Int: FLTAd] = [:]
  weak var rootViewController: UIViewController?

  init(channel: FlutterMethodChannel) {
    self.channel = channel
  }

  func ad(for adId: Int) -> FLTAd? { ads[adId] }

  func trackAd(_ ad: FLTAd, adId: Int) {
    ads[adId] = ad
  }

  func disposeAd(_ adId: Int) {
    ads[adId]?.dispose()
    ads.removeValue(forKey: adId)
  }

  func disposeAllAds() {
    ads.values.forEach { $0.dispose() }
    ads.removeAll()
  }

  @discardableResult
  func showAd(_ adId: Int) -> Bool {
    guard let overlay = ads[adId] as? FLTOverlayAd else { return false }
    overlay.show()
    return true
  }

  // Event senders — keys mirror AdInstanceManager.java exactly.

  func onAdLoaded(_ adId: Int, _ ids: FLTMBridgeIds) {
    send(adId, "onAdLoaded", ["mBridgeIds": ids])
  }
  func onAdFailedToLoad(_ adId: Int, _ ids: FLTMBridgeIds, _ error: String) {
    send(adId, "onAdFailedToLoad", ["mBridgeIds": ids, "loadAdError": error])
  }
  func onAdImpression(_ adId: Int, _ ids: FLTMBridgeIds) {
    send(adId, "onAdImpression", ["mBridgeIds": ids])
  }
  func onAdClicked(_ adId: Int, _ ids: FLTMBridgeIds) {
    send(adId, "onAdClicked", ["mBridgeIds": ids])
  }
  func onAdClosed(_ adId: Int, _ ids: FLTMBridgeIds) {
    send(adId, "onAdClosed", ["mBridgeIds": ids])
  }
  func onAdCompleted(_ adId: Int, _ ids: FLTMBridgeIds) {
    send(adId, "onAdCompleted", ["mBridgeIds": ids])
  }
  func onAdEndCardShowed(_ adId: Int, _ ids: FLTMBridgeIds) {
    send(adId, "onAdEndCardShowed", ["mBridgeIds": ids])
  }
  func onFailedToShowFullScreenContent(_ adId: Int, _ ids: FLTMBridgeIds, _ error: String) {
    send(adId, "onFailedToShowFullScreenContent", ["mBridgeIds": ids, "error": error])
  }
  func onAdShowedFullScreenContent(_ adId: Int, _ ids: FLTMBridgeIds) {
    send(adId, "onAdShowedFullScreenContent", ["mBridgeIds": ids])
  }
  func onAdDismissedFullScreenContent(_ adId: Int, _ ids: FLTMBridgeIds, rewardInfo: FLTRewardInfo) {
    send(adId, "onAdDismissedFullScreenContent", ["mBridgeIds": ids, "rewardInfo": rewardInfo])
  }
  func onAdDismissedFullScreenContent(_ adId: Int, _ ids: FLTMBridgeIds, type: Int) {
    send(adId, "onAdDismissedFullScreenContent", ["mBridgeIds": ids, "type": type])
  }
  func onAdLeftApplication(_ adId: Int, _ ids: FLTMBridgeIds) {
    send(adId, "onAdLeftApplication", ["mBridgeIds": ids])
  }

  private func send(_ adId: Int, _ eventName: String, _ extra: [String: Any]) {
    var arguments: [String: Any] = ["adId": adId, "eventName": eventName]
    extra.forEach { arguments[$0] = $1 }
    // Method-channel messages must be sent on the main thread.
    DispatchQueue.main.async { [weak self] in
      self?.channel.invokeMethod("onAdEvent", arguments: arguments)
    }
  }
}

// MARK: - Plugin

public class FlutterMintegralPlugin: NSObject, FlutterPlugin {
  private let manager: FLTAdInstanceManager

  init(manager: FLTAdInstanceManager) {
    self.manager = manager
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let codec = FlutterStandardMethodCodec(readerWriter: FLTAdReaderWriter())
    let channel = FlutterMethodChannel(
      name: "flutter_mintegral", binaryMessenger: registrar.messenger(), codec: codec)
    let manager = FLTAdInstanceManager(channel: channel)
    let instance = FlutterMintegralPlugin(manager: manager)
    registrar.addMethodCallDelegate(instance, channel: channel)

    let factory = FLTMintegralAdViewFactory(manager: manager)
    registrar.register(factory, withId: "flutter_mintegral/ad_widget")
  }

  private func rootViewController() -> UIViewController? {
    if let root = manager.rootViewController { return root }
    return UIApplication.shared.keyWindow?.rootViewController
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    let adId = args["adId"] as? Int ?? -1

    switch call.method {
    case "_init":
      manager.disposeAllAds()
      result(nil)

    case "initialize":
      guard let appId = args["appId"] as? String, let appKey = args["appKey"] as? String else {
        result(["initializationStatus": false, "error": "Missing appId/appKey"])
        return
      }
      // iOS init is synchronous (no success/fail callback on MTGSDK).
      MTGSDK.sharedInstance().setAppID(appId, apiKey: appKey)
      result(["initializationStatus": true])

    case "loadRewardVideoAd":
      let ad = FLTRewardVideoAd(
        adId: adId, manager: manager,
        placementId: args["placementId"] as? String ?? "",
        unitId: args["unitId"] as? String ?? "",
        rootViewControllerProvider: { [weak self] in self?.rootViewController() })
      ad.isRewardPlus = args["isRewardPlus"] as? Bool ?? false
      manager.trackAd(ad, adId: adId)
      ad.load()
      result(nil)

    case "loadInterstitialAd":
      let ad = FLTInterstitialAd(
        adId: adId, manager: manager,
        placementId: args["placementId"] as? String ?? "",
        unitId: args["unitId"] as? String ?? "",
        rootViewControllerProvider: { [weak self] in self?.rootViewController() })
      manager.trackAd(ad, adId: adId)
      ad.load()
      result(nil)

    case "loadSplashAd":
      let ad = FLTSplashAd(
        adId: adId, manager: manager,
        placementId: args["placementId"] as? String ?? "",
        unitId: args["unitId"] as? String ?? "")
      manager.trackAd(ad, adId: adId)
      ad.load()
      result(nil)

    case "loadBannerAd":
      let size = args["size"] as? FLTAdSize ?? FLTAdSize(width: 320, height: 50)
      let ad = FLTBannerAd(
        adId: adId, manager: manager,
        placementId: args["placementId"] as? String ?? "",
        unitId: args["unitId"] as? String ?? "",
        size: size,
        rootViewControllerProvider: { [weak self] in self?.rootViewController() })
      manager.trackAd(ad, adId: adId)
      ad.load()
      result(nil)

    case "showAdWithoutView":
      if manager.showAd(adId) {
        result(nil)
      } else {
        result(FlutterError(code: "AdShowError", message: "Ad failed to show.", details: nil))
      }

    case "disposeAd":
      manager.disposeAd(adId)
      result(nil)

    case "getAdSize":
      if let banner = manager.ad(for: adId) as? FLTBannerAd {
        result(banner.size)
      } else {
        result(nil)
      }

    case "onPause", "onResume":
      // No-op on iOS (parity with Android's empty implementations).
      result(nil)

    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
