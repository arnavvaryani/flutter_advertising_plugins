package com.anavrinapps.flutter_mintegral;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.mbridge.msdk.out.MBBannerView;

import io.flutter.plugin.platform.PlatformView;
import io.flutter.util.Preconditions;

/** A wrapper for {@link MBBannerView}. */
class FlutterBannerAd extends FlutterAd {
    private static final String TAG = "FlutterBannerAd";

    @NonNull private final AdInstanceManager manager;
    @NonNull private final String placementId;
    @NonNull private final String unitId;
    @NonNull private final FlutterAdSize size;
    @Nullable private MBBannerView bannerView;

    /** Constructs the FlutterBannerAd. */
    public FlutterBannerAd(
            int adId,
            @NonNull AdInstanceManager manager,
            @NonNull String placementId,
            @NonNull String unitId,
            @NonNull FlutterAdSize size) {
        super(adId);
        Preconditions.checkNotNull(manager);
        Preconditions.checkNotNull(placementId);
        Preconditions.checkNotNull(unitId);
        Preconditions.checkNotNull(size);
        this.manager = manager;
        this.placementId = placementId;
        this.unitId = unitId;
        this.size = size;
    }

    @Override
    void onPause() {
        if (bannerView != null) {
            bannerView.onPause();
        }
    }

    @Override
    void onResume() {
        if (bannerView != null) {
            bannerView.onResume();
        }
    }

    @Override
    void load() {
        if (manager.getActivity() == null) {
            Log.e(TAG, "Tried to show banner ad before activity was bound to the plugin.");
            return;
        }
        bannerView = new MBBannerView(manager.getActivity());
        bannerView.init(size.getAdSize(), placementId, unitId);
        bannerView.setAllowShowCloseBtn(false);
        bannerView.setRefreshTime(60);
        bannerView.setBannerAdListener(new FlutterBannerAdListener(adId, manager));
        bannerView.load();
    }

    @Nullable
    @Override
    public PlatformView getPlatformView() {
        if (bannerView == null) {
            return null;
        }
        return new FlutterPlatformView(bannerView);
    }

    @Override
    void dispose() {
        if (bannerView != null) {
            bannerView.release();
            bannerView = null;
        }
    }

    @Nullable
    FlutterAdSize getAdSize() {
        if (bannerView == null) {
            return null;
        }
        return size;
    }
}
