//
//  MopubConstants.swift
//  mopub_flutter
//
//  Created by Rohit Kulkarni on 1/6/20.
//

import Foundation

class MopubConstants {
    static let MAIN_CHANNEL = "mopub";
    static let BANNER_AD_CHANNEL = MAIN_CHANNEL + "/bannerAd";
    static let INTERSTITIAL_AD_CHANNEL = MAIN_CHANNEL + "/interstitialAd";
    //    static let NATIVE_AD_CHANNEL = MAIN_CHANNEL + "/nativeAd";
    static let REWARDED_VIDEO_CHANNEL = MAIN_CHANNEL + "/rewardedAd";
    //    static let IN_STREAM_VIDEO_CHANNEL = MAIN_CHANNEL + "/inStreamAd";
    
    static let INIT_METHOD = "initialize";
    static let DISPOSE_METHOD = "dispose";
    
    static let EXPANDED_METHOD = "expanded";
    static let DISMISSED_METHOD = "dismissed";
    static let DISPLAYED_METHOD = "displayed";
    static let ERROR_METHOD = "error";
    static let LOADED_METHOD = "loaded";
    static let CLICKED_METHOD = "clicked";
    
    static let HAS_INTERSTITIAL_METHOD = "hasInterstitialAd";
    static let SHOW_INTERSTITIAL_METHOD = "showInterstitialAd";
    static let LOAD_INTERSTITIAL_METHOD = "loadInterstitialAd";
    static let DESTROY_INTERSTITIAL_METHOD = "destroyInterstitialAd";
    
    static let HAS_REWARDED_VIDEO_METHOD = "hasRewardedAd";
    static let SHOW_REWARDED_VIDEO_METHOD = "showRewardedAd";
    static let LOAD_REWARDED_VIDEO_METHOD = "loadRewardedAd";
    
    static let REWARDED_PLAYBACK_ERROR = "rewardedVideoError";
    static let GRANT_REWARD = "grantReward";
    //    static let DESTROY_REWARDED_VIDEO_METHOD = "destroyRewardedAd";

}
