package com.mopub_flutter;

final class MopubConstants {
    static final String MAIN_CHANNEL = "mopub";
    static final String BANNER_AD_CHANNEL = MAIN_CHANNEL + "/bannerAd";
    static final String INTERSTITIAL_AD_CHANNEL = MAIN_CHANNEL + "/interstitialAd";
    //    static final String NATIVE_AD_CHANNEL = MAIN_CHANNEL + "/nativeAd";
    static final String REWARDED_VIDEO_CHANNEL = MAIN_CHANNEL + "/rewardedAd";
//    static final String IN_STREAM_VIDEO_CHANNEL = MAIN_CHANNEL + "/inStreamAd";

    static final String INIT_METHOD = "initialize";
    static final String DISPOSE_METHOD = "dispose";

    static final String EXPANDED_METHOD = "expanded";
    static final String DISMISSED_METHOD = "dismissed";
    static final String DISPLAYED_METHOD = "displayed";
    static final String ERROR_METHOD = "error";
    static final String LOADED_METHOD = "loaded";
    static final String CLICKED_METHOD = "clicked";

    static final String HAS_INTERSTITIAL_METHOD = "hasInterstitialAd";
    static final String SHOW_INTERSTITIAL_METHOD = "showInterstitialAd";
    static final String LOAD_INTERSTITIAL_METHOD = "loadInterstitialAd";
    static final String DESTROY_INTERSTITIAL_METHOD = "destroyInterstitialAd";

    static final String HAS_REWARDED_VIDEO_METHOD = "hasRewardedAd";
    static final String SHOW_REWARDED_VIDEO_METHOD = "showRewardedAd";
    static final String LOAD_REWARDED_VIDEO_METHOD = "loadRewardedAd";

    static final String REWARDED_PLAYBACK_ERROR = "rewardedVideoError";
    static final String GRANT_REWARD = "grantReward";
//    static final String DESTROY_REWARDED_VIDEO_METHOD = "destroyRewardedAd";
}
