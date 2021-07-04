import Flutter
import UIKit
import TheoremReachSDK

public class SwiftTrsurveysPlugin: NSObject, FlutterPlugin, TheoremReachRewardDelegate, TheoremReachSurveyAvailableDelegate, TheoremReachSurveyDelegate {
 
    let channel: FlutterMethodChannel!
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    public func theoremreachSurveyAvailable(_ surveyAvailable: Bool) {
        channel.invokeMethod("theoremReachSurveyAvailable", arguments: surveyAvailable)
    }
    
    public func onRewardCenterOpened() {
        channel.invokeMethod("onRewardCenterOpened", arguments: nil)
    }
    
    public func onRewardCenterClosed() {
        channel.invokeMethod("onRewardCenterClosed", arguments: nil)
    }
    
    public func onReward(_ quantity: NSNumber!) {
        channel.invokeMethod("onReward", arguments: quantity)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "theoremreach", binaryMessenger: registrar.messenger())
        let instance = SwiftTrsurveysPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch call.method {
        case "init":
            if let args = call.arguments as? Dictionary<String, Any>,
                let apiToken = args["api_token"] as? String, let userId = args["user_id"] as? String {
                TheoremReach.initWithApiKey(apiToken, userId: userId)
                TheoremReach.setRewardDelegate(self)
                TheoremReach.setSurveyDelegate(self)
                result(nil)
            } else {
                result(FlutterError.init(code: "errorRequest", message: "Couldn't request TheoremReach surveys", details: nil))
            }
            
        case "show":
            TheoremReach.setRewardDelegate(self)
            if TheoremReach.getInstance()!.isSurveyAvailable {
                TheoremReach.showRewardCenter()
            } else {
                result(FlutterError(code: "showRewardCenter", message: "TheoremReach Survey Unavailable", details: call.arguments))
            }
        case "setNavBarText":
            if let args = call.arguments as? Dictionary<String, Any>,
                let textColor = args["text"] as? String {
                TheoremReach.getInstance().navigationBarTextColor = textColor
                result(nil)
            } else {
                result(FlutterError.init(code: "errorRequest", message: "Couldn't set TheoremReach text color", details: nil))
            }
            
        case "setNavBarColor":
            if let args = call.arguments as? Dictionary<String, Any>,
                let barText = args["color"] as? String {
                TheoremReach.getInstance().navigationBarText = barText
                result(nil)
            } else {
                result(FlutterError.init(code: "errorRequest", message: "Couldn't set TheoremReach barText color", details: nil))
            }
        case "setNavBarTextColor":
            if let args = call.arguments as? Dictionary<String, Any>,
                let barColor = args["text_color"] as? String {
                TheoremReach.getInstance().navigationBarColor = barColor
                result(nil)
            } else {
                result(FlutterError.init(code: "errorRequest", message: "Couldn't set TheoremReach barColor", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
