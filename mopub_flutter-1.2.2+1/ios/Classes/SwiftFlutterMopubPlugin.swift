import Flutter
import UIKit
import MoPub

public class SwiftMopubFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: MopubConstants.MAIN_CHANNEL, binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(SwiftMopubFlutterPlugin(), channel: channel)
    
    // Banner Ad PlatformView channel
    registrar.register(
        MopubBannerAdPlugin(messeneger: registrar.messenger()),
        withId: MopubConstants.BANNER_AD_CHANNEL
    )
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String : Any] ?? [:]
    let testMode:Bool = args["testMode"] as? Bool ?? false
    let adUnitId:String = args["adUnitId"] as? String ?? ""
    switch call.method {
    case MopubConstants.INIT_METHOD:
        let sdkConfig = MPMoPubConfiguration(adUnitIdForAppInitialization: adUnitId)
        sdkConfig.loggingLevel = testMode ? .debug : .none
        
        MoPub.sharedInstance().initializeSdk(with: sdkConfig) {
            //SDK initialized
        }
        result(nil)
        break
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
