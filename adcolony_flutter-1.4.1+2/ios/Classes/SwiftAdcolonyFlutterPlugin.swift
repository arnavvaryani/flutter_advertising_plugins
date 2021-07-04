import UIKit
import AdColony 

public class SwiftAdcolonyFlutterPlugin: NSObject, FlutterPlugin, AdColonyInterstitialDelegate {
    let channel: FlutterMethodChannel
    var interstitial:AdColonyInterstitial?
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    public func adColonyInterstitialDidLoad(_ interstitial: AdColonyInterstitial) {
        self.interstitial = interstitial
        channel.invokeMethod("onRequestFilled", arguments: nil)
    }
    
    public func adColonyInterstitialDidFail(toLoad error: AdColonyAdRequestError) {
        channel.invokeMethod("onRequestNotFilled", arguments: nil)
    }
    public func adColonyInterstitialExpired(_ interstitial: AdColonyInterstitial) {
        self.interstitial = nil
        channel.invokeMethod("onExpiring", arguments: nil)
    }
    public func adColonyInterstitialDidReceiveClick(_ interstitial: AdColonyInterstitial) {
        channel.invokeMethod("onClicked", arguments: nil)
    }
    public func adColonyInterstitialWillLeaveApplication(_ interstitial: AdColonyInterstitial) {
        channel.invokeMethod("onLeftApplication", arguments: nil)
    }
    public func adColonyInterstitialWillOpen(_ interstitial: AdColonyInterstitial) {
        channel.invokeMethod("onOpened", arguments: nil)
    }
    public func adColonyInterstitialDidClose(_ interstitial: AdColonyInterstitial) {
        channel.invokeMethod("onClosed", arguments: nil)
    }
    
    public func adColonyInterstitial(_ interstitial: AdColonyInterstitial, iapOpportunityWithProductId iapProductID: String, andEngagement engagement: AdColonyIAPEngagement) {
        channel.invokeMethod("onIAPEvent", arguments: nil)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "AdColony", binaryMessenger: registrar.messenger())
        let instance = SwiftAdcolonyFlutterPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isLoaded":
         if let interstitial = self.interstitial, !interstitial.expired {
                result(true)
            } else {
                result(false)
            }
        break;
        case "Init":
            if let args = call.arguments as? Dictionary<String, Any>,
                let id = args["Id"] as? String, let gdpr = args["Gdpr"] as? String, let rewardedZones = args["Zones"] as? Array<String> {
                let options = AdColonyAppOptions()
              options.setPrivacyFrameworkOfType(ADC_GDPR, isRequired: true)
              options.setPrivacyConsentString(gdpr, forType: ADC_GDPR)
                AdColony.configure(withAppID: id, zoneIDs: rewardedZones, options: options) { (zones) in
                    for zone in zones {
                        if rewardedZones.contains(zone.identifier) {
                            zone.setReward { (success, name, amount) in
                                if success {
                                    self.channel.invokeMethod("onReward", arguments: amount)
                                }
                            }
                        }
                    }
                }
                result(nil)
            } else {
                result(FlutterError.init(code: "errorInit", message: "Couldn't initialize Adcolony", details: nil))
            }
        break;
        case "Request":
            if let args = call.arguments as? Dictionary<String, Any>,
                let zone = args["Id"] as? String {
                AdColony.requestInterstitial(inZone: zone, options: nil, andDelegate: self)
                result(nil)
            } else {
                result(FlutterError.init(code: "errorRequest", message: "Couldn't request Adcolony Ads", details: nil))
            }
        break;
        case "Show":
            if let interstitial = self.interstitial, !interstitial.expired, let
                rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                interstitial.show(withPresenting: rootViewController)
            } else {
                result(FlutterError.init(code: "errorShow", message: "Couldn't show Adcolony Ad", details: nil))
            }
        break;
        default: result(FlutterMethodNotImplemented)
        }
    }
    
}
