import Flutter
import UIKit
import TapResearchSDK

/// Flutter bridge for the TapResearch iOS SDK 3.x.
///
/// The 3.x SDK requires an api token and a user identifier at initialization,
/// uses string placement tags, and delivers rewards as a batched array via the
/// `TapResearchSDKDelegate`. Content show/dismiss events arrive via the
/// `TapResearchContentDelegate` passed to `showContent`.
public class FlutterTapresearchPlugin: NSObject, FlutterPlugin,
    TapResearchSDKDelegate, TapResearchContentDelegate {

  private static var channel: FlutterMethodChannel?
  private var sdkReady = false

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flutter_tapresearch", binaryMessenger: registrar.messenger())
    let instance = FlutterTapresearchPlugin()
    FlutterTapresearchPlugin.channel = channel
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    switch call.method {
    case "initialize":
      guard let token = args["apiToken"] as? String, !token.isEmpty else {
        result(FlutterError(code: "no_api_token",
                            message: "A null/empty api token was provided", details: nil))
        return
      }
      guard let userId = args["userIdentifier"] as? String, !userId.isEmpty else {
        result(FlutterError(code: "no_user_id",
                            message: "A null/empty user identifier was provided", details: nil))
        return
      }
      TapResearch.initialize(withAPIToken: token, userIdentifier: userId, sdkDelegate: self) {
        [weak self] error in
        if let error = error {
          self?.invokeError(error)
        }
      }
      result(nil)

    case "isReady":
      result(sdkReady)

    case "canShowContentForPlacement":
      let tag = args["placementTag"] as? String ?? ""
      let canShow = TapResearch.canShowContent(forPlacement: tag) { [weak self] error in
        if let error = error { self?.invokeError(error) }
      }
      result(canShow)

    case "showContentForPlacement":
      let tag = args["placementTag"] as? String ?? ""
      let custom = args["customParameters"] as? [String: Any] ?? [:]
      TapResearch.showContent(forPlacement: tag, delegate: self, customParameters: custom) {
        [weak self] error in
        if let error = error { self?.invokeError(error) }
      }
      result(nil)

    case "setUserIdentifier":
      let userId = args["userIdentifier"] as? String ?? ""
      TapResearch.setUserIdentifier(userId)
      result(nil)

    case "sendUserAttributes":
      let attrs = args["attributes"] as? [String: Any] ?? [:]
      _ = TapResearch.sendUserAttributes(attributes: attrs, clearPreviousAttributes: false)
      result(nil)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - TapResearchSDKDelegate

  public func onTapResearchDidReceiveRewards(_ rewards: [TRReward]) {
    let mapped = rewards.map { rewardMap($0) }
    FlutterTapresearchPlugin.channel?.invokeMethod("onRewards", arguments: mapped)
  }

  public func onTapResearchDidError(_ error: NSError) {
    invokeError(error)
  }

  public func onTapResearchSdkReady() {
    sdkReady = true
    FlutterTapresearchPlugin.channel?.invokeMethod("onSdkReady", arguments: nil)
  }

  public func onTapResearchQuickQuestionResponse(_ qqPayload: TRQQDataPayload) {
    // Quick Questions are not yet surfaced to Dart. Hook added for forward
    // compatibility; wire up an "onQuickQuestionResponse" call here when needed.
  }

  // MARK: - TapResearchContentDelegate

  public func onTapResearchContentShown(forPlacement placementTag: String) {
    FlutterTapresearchPlugin.channel?.invokeMethod("onContentShown", arguments: placementTag)
  }

  public func onTapResearchContentDismissed(forPlacement placementTag: String) {
    FlutterTapresearchPlugin.channel?.invokeMethod("onContentDismissed", arguments: placementTag)
  }

  // MARK: - Helpers

  private func rewardMap(_ reward: TRReward) -> [String: Any] {
    return [
      "transactionIdentifier": reward.transactionIdentifier,
      "placementIdentifier": reward.placementIdentifier,
      "placementTag": reward.placementTag,
      "currencyName": reward.currencyName,
      "rewardAmount": reward.rewardAmount,
      "payoutEventType": reward.payoutEventType,
    ]
  }

  private func invokeError(_ error: NSError) {
    FlutterTapresearchPlugin.channel?.invokeMethod(
      "onError",
      arguments: ["code": String(error.code), "message": error.localizedDescription])
  }
}
