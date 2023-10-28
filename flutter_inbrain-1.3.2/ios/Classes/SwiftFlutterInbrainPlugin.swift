import Flutter
import UIKit
import InBrainSurveys_SDK_Swift

public class SwiftFlutterInbrainPlugin: NSObject, FlutterPlugin, InBrainDelegate  {
    
    let channel: FlutterMethodChannel!
      init(channel: FlutterMethodChannel) {
          self.channel = channel
      }
    
    let inBrain: InBrain = InBrain.shared
    var points : Float = 0;
    
    public func didFailToReceiveRewards(error: Error) {
        channel.invokeMethod("didFailToReceiveRewards", arguments: error)
    }
    
    public func didReceiveInBrainRewards(rewardsArray: [InBrainReward]) {
        if rewardsArray.isEmpty { return }
        for reward in rewardsArray {
            points += reward.amount
        }
        let ids = rewardsArray.map { $0.transactionId }
        inBrain.confirmRewards(txIdArray: ids)
        channel.invokeMethod("didRecieveInBrainRewards", arguments: points)
    }
    
    public func surveysClosed() {
        channel.invokeMethod("surveyClosed", arguments: points)
        print("Surveys closed")
    }
    
    public func surveysClosedFromPage() {
        channel.invokeMethod("surveyClosedFromPage", arguments: points)
        print("Surveys closed From Page")
    }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_inbrain", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterInbrainPlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
     case "init":
     if let args = call.arguments as? Dictionary<String, Any>,
                let api_client_id = args["apiClientId"] as? String, let api_secret = args["apiSecret"] as? String, let is_S2S = args["isS2S"] as? Bool, let user_id = args["userId"] as? String {
      inBrain.setInBrain(apiClientID: api_client_id,
                           apiSecret: api_secret,
                           isS2S: is_S2S)
        inBrain.set(userID: user_id)
        inBrain.setLanguage(value: "en-us")
        inBrain.checkForAvailableSurveys { hasSurveys, _  in
             guard hasSurveys else { return }
            self.channel.invokeMethod("onSurveysAvailable", arguments: hasSurveys)
         }
                }    
      break;
      case "showSurveys":
       inBrain.checkForAvailableSurveys { [weak self] hasSurveys, _  in
            guard hasSurveys else { return }
            self?.inBrain.showSurveys()
        }
        break;
      case "customiseUI":
       if let args = call.arguments as? Dictionary<String, Any>,
                let bg_color = args["bg_color"] as? String, let button_color = args["button_color"] as? String, let title_color = args["title_color"] as? String {
        if #available(iOS 11.0, *) {
            let config = InBrainNavBarConfig(backgroundColor: UIColor(named: bg_color), buttonsColor: UIColor(named: button_color),
                                             titleColor: UIColor(named: title_color), isTranslucent: false, hasShadow: false)
            inBrain.setNavigationBarConfig(config)
        } else {
            result("Inbrain SDK: ios 11 required for customUI")
        }
        let statusBarConfig = InBrainStatusBarConfig(statusBarStyle: .lightContent, hideStatusBar: false)
        inBrain.setStatusBarConfig(statusBarConfig)
         }
    default:
        result("Inbrain SDK: ios method not implemented")
    }
  }
    
}
