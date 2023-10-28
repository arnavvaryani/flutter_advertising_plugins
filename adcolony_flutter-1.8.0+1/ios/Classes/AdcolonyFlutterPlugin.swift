import UIKit
import AdColony
import Flutter 
// import AdColonyBannerViewFactory
// import AdColonyBannerView

public class AdcolonyFlutterPlugin: NSObject, FlutterPlugin, AdColonyInterstitialDelegate {
    let channel: FlutterMethodChannel
    var interstitial: AdColonyInterstitial?
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "AdColony", binaryMessenger: registrar.messenger())
        let instance = AdcolonyFlutterPlugin(channel: channel)
        // let messenger = registrar.messenger()
        
        // registrar.register(
        //     AdColonyBannerViewFactory(messenger: messenger),
        //     withId: "adcolony_flutter/banner"
        // )
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isLoaded":
            result(interstitial != nil && !interstitial!.expired)
        case "Init":
            if let args = call.arguments as? [String: Any],
               let id = args["Id"] as? String,
               let gdpr = args["Gdpr"] as? String,
               let rewardedZones = args["Zones"] as? [String] {
                let options = AdColonyAppOptions()
                options.setPrivacyFrameworkOfType(ADC_GDPR, isRequired: true)
                options.setPrivacyConsentString(gdpr, forType: ADC_GDPR)
                
                AdColony.configure(withAppID: id, zoneIDs: rewardedZones, options: options) { zones in
                    for zone in zones {
                        if rewardedZones.contains(zone.identifier) {
                            zone.setReward { success, name, amount in
                                if success {
                                    self.channel.invokeMethod("onReward", arguments: amount)
                                }
                            }
                        }
                    }
                }
                result(nil)
            } else {
                result(FlutterError(code: "errorInit", message: "Couldn't initialize Adcolony", details: nil))
            }
        case "Request":
            if let args = call.arguments as? [String: Any],
               let zone = args["Id"] as? String {
                AdColony.requestInterstitial(inZone: zone, options: nil, andDelegate: self)
                result(nil)
            } else {
                result(FlutterError(code: "errorRequest", message: "Couldn't request Adcolony Ads", details: nil))
            }
        case "Show":
            if let interstitial = self.interstitial,
               !interstitial.expired,
               let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                interstitial.show(withPresenting: rootViewController)
                result(nil)
            } else {
                result(FlutterError(code: "errorShow", message: "Couldn't show Adcolony Ad", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // AdColonyInterstitialDelegate methods
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
    
    public func adColonyInterstitial(_ interstitial: AdColonyInterstitial,
                                     iapOpportunityWithProductId iapProductID: String,
                                     andEngagement engagement: AdColonyIAPEngagement) {
        channel.invokeMethod("onIAPEvent", arguments: nil)
    }
}
