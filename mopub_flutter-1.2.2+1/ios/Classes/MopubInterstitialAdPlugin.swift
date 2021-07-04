//
//  MopubInterstitialAdPlugin.swift
//  mopub_flutter
//
//  Created by Rohit Kulkarni on 1/6/20.
//

import Foundation
import Flutter
import MoPub

public class MopubInterstitialAdPlugin : NSObject, FlutterPlugin {
    
    fileprivate var ads: [String: MPInterstitialAdController] = [:]
    fileprivate var delegates: [String: MPInterstitialAdControllerDelegate] = [:]
    
    fileprivate var pluginRegistrar: FlutterPluginRegistrar?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = MopubInterstitialAdPlugin()
        instance.pluginRegistrar = registrar
        let channel = FlutterMethodChannel(name: MopubConstants.INTERSTITIAL_AD_CHANNEL, binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    override init() {
        self.ads = Dictionary<String, MPInterstitialAdController>()
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String : Any] ?? [:]
        let adUnitId = args["adUnitId"] as? String ?? "ad_unit_id"
        
        switch call.method {
        case MopubConstants.SHOW_INTERSTITIAL_METHOD:
            let ad = ads[adUnitId] ?? nil
            if (ad == nil || !ad!.ready) {
                return;
            }
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController
            ad!.show(from: rootViewController)
            result(nil);
            break
        case MopubConstants.LOAD_INTERSTITIAL_METHOD:
            
            if (ads[adUnitId] == nil) {
                ads[adUnitId] = MPInterstitialAdController(forAdUnitId: adUnitId);
            }
            let ad = ads[adUnitId]
            if (ad != nil) {
                let channelName = "\(MopubConstants.INTERSTITIAL_AD_CHANNEL)_\(adUnitId)"
                let adChannel = FlutterMethodChannel(name: channelName, binaryMessenger: pluginRegistrar!.messenger())
                delegates[adUnitId] = MopubInterstitialDelegate(channel: adChannel)
                ad!.delegate = delegates[adUnitId]
                if (!ad!.ready) {
                    ad!.loadAd()
                }
            }
            result(nil)
            break
        case MopubConstants.HAS_INTERSTITIAL_METHOD:
            let ad = ads[adUnitId]
            if(ad != nil) {
                let isReady = ad?.ready ?? false
                result(isReady)
                return
            }
            result(false)
            break
        case MopubConstants.DESTROY_INTERSTITIAL_METHOD:
            if (ads[adUnitId] == nil) {
                return;
            } else  {
                ads.removeValue(forKey: adUnitId)
                delegates.removeValue(forKey: adUnitId)
            }
            result(nil);
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

class MopubInterstitialDelegate: NSObject, MPInterstitialAdControllerDelegate {
    
    let channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!) {
        var args:[String:Any] = [:]
        args["keywords"] = interstitial.keywords
        channel.invokeMethod(MopubConstants.LOADED_METHOD, arguments: args)
    }
    
    func interstitialDidFail(toLoadAd interstitial: MPInterstitialAdController!, withError error: Error!) {
        var args:[String:Any] = [:]
        args["keywords"] = interstitial.keywords
        args["errorCode"] = error.localizedDescription
        channel.invokeMethod(MopubConstants.ERROR_METHOD, arguments: args)
    }
    
    func interstitialDidReceiveTapEvent(_ interstitial: MPInterstitialAdController!) {
        var args:[String:Any] = [:]
        args["keywords"] = interstitial.keywords
        channel.invokeMethod(MopubConstants.CLICKED_METHOD, arguments: args)
    }
    
    func interstitialWillAppear(_ interstitial: MPInterstitialAdController!) {        
        var args:[String:Any] = [:]
        args["keywords"] = interstitial.keywords
        channel.invokeMethod(MopubConstants.CLICKED_METHOD, arguments: args)
    }
    
    func interstitialDidDisappear(_ interstitial: MPInterstitialAdController!) {
        var args:[String:Any] = [:]
        args["keywords"] = interstitial.keywords
        channel.invokeMethod(MopubConstants.DISMISSED_METHOD, arguments: args)
    }
    
    func interstitialDidExpire(_ interstitial: MPInterstitialAdController!) {
        interstitial.loadAd()
    }
    
}
