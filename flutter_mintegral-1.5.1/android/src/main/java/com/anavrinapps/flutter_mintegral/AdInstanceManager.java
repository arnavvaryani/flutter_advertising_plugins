package com.anavrinapps.flutter_mintegral;

import android.app.Activity;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.anavrinapps.flutter_mintegral.FlutterAd.FlutterMBridgeIds;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

class AdInstanceManager {
    @Nullable private Activity activity;

    @NonNull private final Map<Integer, FlutterAd> ads;
    @NonNull private final MethodChannel channel;

    AdInstanceManager(@NonNull MethodChannel channel) {
        this.channel = channel;
        this.ads = new HashMap<>();
    }

    void setActivity(@Nullable Activity activity) {
        this.activity = activity;
    }

    @Nullable
    Activity getActivity() {
        return activity;
    }

    @Nullable
    FlutterAd adForId(int id) {
        return ads.get(id);
    }

    @Nullable
    Integer adIdFor(@NonNull FlutterAd ad) {
        for (Integer adId : ads.keySet()) {
            if (ads.get(adId) == ad) {
                return adId;
            }
        }
        return null;
    }

    void trackAd(@NonNull FlutterAd ad, int adId) {
        if (ads.get(adId) != null) {
            throw new IllegalArgumentException(
                    String.format("Ad for following adId already exists: %d", adId));
        }
        ads.put(adId, ad);
    }

    void disposeAd(int adId) {
        if (!ads.containsKey(adId)) {
            return;
        }
        FlutterAd ad = ads.get(adId);
        if (ad != null) {
            ad.dispose();
        }
        ads.remove(adId);
    }

    void disposeAllAds() {
        for (Map.Entry<Integer, FlutterAd> entry : ads.entrySet()) {
            if (entry.getValue() != null) {
                entry.getValue().dispose();
            }
        }
        ads.clear();
    }

    void onAdLoaded(int adId, @NonNull FlutterMBridgeIds mBridgeIds) {
        Map<Object, Object> arguments = new HashMap<>();
        arguments.put("adId", adId);
        arguments.put("eventName", "onAdLoaded");
        arguments.put("mBridgeIds", mBridgeIds);
        invokeOnAdEvent(arguments);
    }

    void onAdFailedToLoad(int adId, @NonNull FlutterMBridgeIds mBridgeIds, String errorMsg) {
        Map<Object, Object> arguments = new HashMap<>();
        arguments.put("adId", adId);
        arguments.put("eventName", "onAdFailedToLoad");
        arguments.put("mBridgeIds", mBridgeIds);
        arguments.put("loadAdError", errorMsg);
        invokeOnAdEvent(arguments);
    }

    void onAdImpression(int adId, @NonNull FlutterMBridgeIds mBridgeIds) {
        Map<Object, Object> arguments = new HashMap<>();
        arguments.put("adId", adId);
        arguments.put("eventName", "onAdImpression");
        arguments.put("mBridgeIds", mBridgeIds);
        invokeOnAdEvent(arguments);
    }

    void onAdClicked(int adId, @NonNull FlutterMBridgeIds mBridgeIds) {
        Map<Object, Object> arguments = new HashMap<>();
        arguments.put("adId", adId);
        arguments.put("eventName", "onAdClicked");
        arguments.put("mBridgeIds", mBridgeIds);
        invokeOnAdEvent(arguments);
    }

    void onAdClosed(int adId, @NonNull FlutterMBridgeIds mBridgeIds) {
        Map<Object, Object> arguments = new HashMap<>();
        arguments.put("adId", adId);
        arguments.put("eventName", "onAdClosed");
        arguments.put("mBridgeIds", mBridgeIds);
        invokeOnAdEvent(arguments);
    }

    void onAdCompleted(int adId, @NonNull FlutterMBridgeIds mBridgeIds) {
        final Map<Object, Object> arguments = new HashMap<>();
        arguments.put("adId", adId);
        arguments.put("eventName", "onAdCompleted");
        arguments.put("mBridgeIds", mBridgeIds);
        invokeOnAdEvent(arguments);
    }

    void onAdEndCardShowed(int adId, @NonNull FlutterMBridgeIds mBridgeIds) {
        final Map<Object, Object> arguments = new HashMap<>();
        arguments.put("adId", adId);
        arguments.put("eventName", "onAdEndCardShowed");
        arguments.put("mBridgeIds", mBridgeIds);
        invokeOnAdEvent(arguments);
    }

    void onFailedToShowFullScreenContent(
            int adId,
            @NonNull FlutterMBridgeIds mBridgeIds,
            String errorMsg) {
        final Map<Object, Object> arguments = new HashMap<>();
        arguments.put("adId", adId);
        arguments.put("eventName", "onFailedToShowFullScreenContent");
        arguments.put("mBridgeIds", mBridgeIds);
        arguments.put("error", errorMsg);
        invokeOnAdEvent(arguments);
    }

    void onAdShowedFullScreenContent(int adId, @NonNull FlutterMBridgeIds mBridgeIds) {
        final Map<Object, Object> arguments = new HashMap<>();
        arguments.put("adId", adId);
        arguments.put("eventName", "onAdShowedFullScreenContent");
        arguments.put("mBridgeIds", mBridgeIds);
        invokeOnAdEvent(arguments);
    }

    void onAdDismissedFullScreenContent(
            int adId,
            @NonNull FlutterMBridgeIds mBridgeIds,
            @NonNull FlutterRewardVideoAd.FlutterRewardInfo rewardInfo) {
        final Map<Object, Object> arguments = new HashMap<>();
        arguments.put("adId", adId);
        arguments.put("eventName", "onAdDismissedFullScreenContent");
        arguments.put("mBridgeIds", mBridgeIds);
        arguments.put("rewardInfo", rewardInfo);
        invokeOnAdEvent(arguments);
    }

    void onAdDismissedFullScreenContent(
            int adId, @NonNull FlutterMBridgeIds mBridgeIds, int type) {
        final Map<Object, Object> arguments = new HashMap<>();
        arguments.put("adId", adId);
        arguments.put("eventName", "onAdDismissedFullScreenContent");
        arguments.put("mBridgeIds", mBridgeIds);
        arguments.put("type", type);
        invokeOnAdEvent(arguments);
    }

    void onAdLeftApplication(int adId, @NonNull FlutterMBridgeIds mBridgeIds) {
        final Map<Object, Object> arguments = new HashMap<>();
        arguments.put("adId", adId);
        arguments.put("eventName", "onAdLeftApplication");
        arguments.put("mBridgeIds", mBridgeIds);
        invokeOnAdEvent(arguments);
    }

    boolean showAdWithId(int id) {
        final FlutterAd.FlutterOverlayAd ad = (FlutterAd.FlutterOverlayAd) adForId(id);

        if (ad == null) {
            return false;
        }

        ad.show();
        return true;
    }

    /** Invoke the method channel using the UI thread. Otherwise the message gets silently dropped. */
    private void invokeOnAdEvent(final Map<Object, Object> arguments) {
        new Handler(Looper.getMainLooper())
                .post(() -> channel.invokeMethod("onAdEvent", arguments));
    }
}
