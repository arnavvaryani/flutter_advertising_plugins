package com.mopub_flutter;

import android.content.Context;
import android.view.View;

import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubView;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

class MopubBannerAdPlugin extends PlatformViewFactory {

    private final BinaryMessenger messenger;

    MopubBannerAdPlugin(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        return new MopubBannerAdView(context, viewId, (HashMap) args, messenger);
    }
}

class MopubBannerAdView implements MoPubView.BannerAdListener, PlatformView {
    private MoPubView adView;
    private MethodChannel channel;


    MopubBannerAdView(Context context, int id, HashMap args, BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, MopubConstants.BANNER_AD_CHANNEL + "_" + id);
        final String adUnitId = (String) args.get("adUnitId");
        final boolean autoRefresh = (boolean) args.get("autoRefresh");
        final int height = (int) args.get("height");

        adView = new MoPubView(context);
        adView.setAdUnitId(adUnitId);
        adView.setAutorefreshEnabled(autoRefresh);
        adView.setAdSize(getBannerAdSize(height));
        adView.setBannerAdListener(this);
        adView.loadAd();
    }

    private MoPubView.MoPubAdSize getBannerAdSize(double height) {
        if (height >= 280) {
            return MoPubView.MoPubAdSize.HEIGHT_280;
        } else if (height >= 250) {
            return MoPubView.MoPubAdSize.HEIGHT_250;
        } else if (height >= 90) {
            return MoPubView.MoPubAdSize.HEIGHT_90;
        } else if (height >= 50) {
            return MoPubView.MoPubAdSize.HEIGHT_50;
        } else {
            return MoPubView.MoPubAdSize.MATCH_VIEW;
        }
    }

    @Override
    public void onBannerLoaded(MoPubView banner) {
        HashMap<String, Object> args = new HashMap<>();
        args.put("adUnitId", banner.getAdUnitId());

        channel.invokeMethod(MopubConstants.LOADED_METHOD, args);
    }

    @Override
    public void onBannerFailed(MoPubView banner, MoPubErrorCode errorCode) {
        HashMap<String, Object> args = new HashMap<>();
        args.put("adUnitId", banner.getAdUnitId());
        args.put("errorCode", errorCode.toString());

        channel.invokeMethod(MopubConstants.ERROR_METHOD, args);
    }

    @Override
    public void onBannerClicked(MoPubView banner) {
        HashMap<String, Object> args = new HashMap<>();
        args.put("adUnitId", banner.getAdUnitId());

        channel.invokeMethod(MopubConstants.CLICKED_METHOD, args);
    }

    @Override
    public void onBannerExpanded(MoPubView banner) {
        HashMap<String, Object> args = new HashMap<>();
        args.put("adUnitId", banner.getAdUnitId());

        channel.invokeMethod(MopubConstants.EXPANDED_METHOD, args);
    }

    @Override
    public void onBannerCollapsed(MoPubView banner) {
        HashMap<String, Object> args = new HashMap<>();
        args.put("adUnitId", banner.getAdUnitId());

        channel.invokeMethod(MopubConstants.DISMISSED_METHOD, args);
    }

    @Override
    public View getView() {
        return adView;
    }

    @Override
    public void dispose() {
        channel.setMethodCallHandler(null);
        if (adView != null) {
            adView.setAutorefreshEnabled(false);
            adView.destroy();
        }
    }

    @Override
    public void onInputConnectionLocked() {
    }

    @Override
    public void onInputConnectionUnlocked() {
    }
}
