//
//  MopubBannerAd.swift
//  mopub_flutter
//
//  Created by Rohit Kulkarni on 1/6/20.
//

import Foundation
import MoPub

class MoPubBannerAd : NSObject, FlutterPlatformView {
    
    private let channel: FlutterMethodChannel
    private let messeneger: FlutterBinaryMessenger
    private let frame: CGRect
    private let viewId: Int64
    private let args: [String: Any]
    private var adView: MPAdView!
    
    init(frame: CGRect, viewId: Int64, args: [String: Any], messeneger: FlutterBinaryMessenger) {
        
        self.args = args
        self.messeneger = messeneger
        self.frame = frame
        self.viewId = viewId
        let channelName = "\(MopubConstants.BANNER_AD_CHANNEL)_\(viewId)"
        print("The current value of channelName is \(channelName)")
        self.channel = FlutterMethodChannel(name: channelName, binaryMessenger: messeneger)
        
        super.init()
    }
    
    func view() -> UIView {
        return getBannerAdView() ?? UIView()
    }
    
    fileprivate func dispose() {
        adView?.stopAutomaticallyRefreshingContents()
        adView?.removeFromSuperview()
        adView = nil
        channel.setMethodCallHandler(nil)
    }
    
    fileprivate func getBannerAdView() -> MPAdView? {
        if adView == nil {
            let adUnitId = self.args["adUnitId"] as? String ?? "ad_unit_id"
            let autoRefresh = self.args["autoRefresh"] as? Bool ?? false
            let height = self.args["height"] as? NSInteger ?? 0
            
            adView = {
                let view: MPAdView = MPAdView(adUnitId: adUnitId)
                view.delegate = self                
                if autoRefresh { adView!.startAutomaticallyRefreshingContents() }
                return view
            }()
            adView!.loadAd(withMaxAdSize: getBannerAdSize(height: height))
        }
        return adView
    }
    
    
    fileprivate func getBannerAdSize(height: NSInteger) -> CGSize {
        if height >= 280 {
            return kMPPresetMaxAdSize280Height
        } else if height >= 250 {
            return kMPPresetMaxAdSize250Height
        } else if height >= 90 {
            return kMPPresetMaxAdSize90Height
        } else if height >= 50 {
            return kMPPresetMaxAdSize50Height
        } else {
            return kMPPresetMaxAdSizeMatchFrame
        }
    }
}

extension MoPubBannerAd: MPAdViewDelegate {
    func viewControllerForPresentingModalView() -> UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    func adViewDidLoadAd(_ view: MPAdView!) {
        var args:[String:Any] = [:]
        args["adUnitId"] = view.adUnitId
        args["keywords"] = view.keywords
        channel.invokeMethod(MopubConstants.LOADED_METHOD, arguments: args)
    }

    func adView(_ view: MPAdView!, didFailToLoadAdWithError error: Error!) {
        var args:[String:Any] = [:]
        args["adUnitId"] = view.adUnitId
        args["errorCode"] = error.localizedDescription
        channel.invokeMethod(MopubConstants.ERROR_METHOD, arguments: args)
    }
    
    func willPresentModalView(forAd view: MPAdView!) {
        var args:[String:Any] = [:]
        args["adUnitId"] = view.adUnitId
        args["keywords"] = view.keywords
        channel.invokeMethod(MopubConstants.CLICKED_METHOD, arguments: args)
        channel.invokeMethod(MopubConstants.EXPANDED_METHOD, arguments: args)
    }
    
    func didDismissModalView(forAd view: MPAdView!) {
        var args:[String:Any] = [:]
        args["adUnitId"] = view.adUnitId
        args["keywords"] = view.keywords
        channel.invokeMethod(MopubConstants.DISMISSED_METHOD, arguments: args)
    }
    
    func willLeaveApplication(fromAd view: MPAdView!) {
        
    }
}
