package com.anavrinapps.flutter_mintegral;

import androidx.annotation.NonNull;

import com.mbridge.msdk.out.BannerAdListener;
import com.mbridge.msdk.out.MBridgeIds;

import com.anavrinapps.flutter_mintegral.FlutterAd.FlutterMBridgeIds;

public class FlutterAdListener {
    protected final int adId;
    @NonNull
    protected final AdInstanceManager manager;

    FlutterAdListener(int adId, @NonNull AdInstanceManager manager) {
        this.adId = adId;
        this.manager = manager;
    }
}

class FlutterBannerAdListener extends FlutterAdListener implements BannerAdListener {

    FlutterBannerAdListener(int adId, @NonNull AdInstanceManager manager) {
        super(adId, manager);
    }

    @Override
    public void onLoadFailed(MBridgeIds mBridgeIds, String errorMsg) {
        manager.onAdFailedToLoad(adId, new FlutterMBridgeIds(mBridgeIds), errorMsg);
    }

    @Override
    public void onLoadSuccessed(MBridgeIds mBridgeIds) {
        manager.onAdLoaded(adId, new FlutterMBridgeIds(mBridgeIds));
    }

    @Override
    public void onLogImpression(MBridgeIds mBridgeIds) {
        manager.onAdImpression(adId, new FlutterMBridgeIds(mBridgeIds));
    }

    @Override
    public void onClick(MBridgeIds mBridgeIds) {
        manager.onAdClicked(adId, new FlutterMBridgeIds(mBridgeIds));
    }

    @Override
    public void onLeaveApp(MBridgeIds mBridgeIds) {
        manager.onAdLeftApplication(adId, new FlutterMBridgeIds(mBridgeIds));
    }

    /**
     * empty implementation method,(It can be ignored)
     */
    @Override
    public void showFullScreen(MBridgeIds mBridgeIds) {

    }

    /**
     * empty implementation method,(It can be ignored)
     */
    @Override
    public void closeFullScreen(MBridgeIds mBridgeIds) {

    }

    @Override
    public void onCloseBanner(MBridgeIds mBridgeIds) {
        manager.onAdClosed(adId, new FlutterMBridgeIds(mBridgeIds));
    }
}
