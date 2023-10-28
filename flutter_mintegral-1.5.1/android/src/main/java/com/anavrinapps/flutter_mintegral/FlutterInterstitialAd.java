package com.anavrinapps.flutter_mintegral;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.mbridge.msdk.newinterstitial.out.MBNewInterstitialHandler;
import com.mbridge.msdk.newinterstitial.out.NewInterstitialListener;
import com.mbridge.msdk.out.MBridgeIds;
import com.mbridge.msdk.out.RewardInfo;

import java.lang.ref.WeakReference;

/** A wrapper for {@link MBNewInterstitialHandler}. */
class FlutterInterstitialAd extends FlutterAd.FlutterOverlayAd {
    private static final String TAG = "FlutterInterstitialAd";

    @NonNull private final AdInstanceManager manager;
    @NonNull private final String placementId;
    @NonNull private final String unitId;
    @Nullable MBNewInterstitialHandler mbNewInterstitialHandler;

    /** Constructor */
    public FlutterInterstitialAd(
            int adId,
            @NonNull AdInstanceManager manager,
            @NonNull String placementId,
            @NonNull String unitId) {
        super(adId);
        this.manager = manager;
        this.placementId = placementId;
        this.unitId = unitId;
    }

    /**
     * empty implementation method,(It can be ignored)
     */
    @Override
    void onPause() {

    }

    /**
     * empty implementation method,(It can be ignored)
     */
    @Override
    void onResume() {

    }

    @Override
    void load() {
        if (manager.getActivity() == null) {
            Log.e(TAG, "Tried to show reward ad before activity was bound to the plugin.");
            return;
        }
        if (mbNewInterstitialHandler == null) {
            mbNewInterstitialHandler = new MBNewInterstitialHandler(
                    manager.getActivity(), placementId, unitId);
            mbNewInterstitialHandler.setInterstitialVideoListener(
                    new FlutterInterstitialAd.DelegatingInterstitialCallback(this));
        }
        mbNewInterstitialHandler.load();
    }

    @Override
    void show() {
        if (mbNewInterstitialHandler == null || !mbNewInterstitialHandler.isReady()) {
            Log.e(TAG, "Error showing interstitial - the interstitial ad wasn't loaded yet.");
        }
        mbNewInterstitialHandler.show();
    }

    @Override
    void dispose() {
        mbNewInterstitialHandler = null;
    }

    void onResourceLoadSuccess(MBridgeIds mBridgeIds) {
        manager.onAdLoaded(adId, new FlutterMBridgeIds(mBridgeIds));
    }

    void onResourceLoadFail(MBridgeIds mBridgeIds, String errorMsg) {
        manager.onAdFailedToLoad(adId, new FlutterMBridgeIds(mBridgeIds), errorMsg);
    }

    void onAdShow(MBridgeIds mBridgeIds) {
        manager.onAdShowedFullScreenContent(adId, new FlutterMBridgeIds(mBridgeIds));
    }

    void onAdClose(MBridgeIds mBridgeIds, RewardInfo rewardInfo) {
        manager.onAdDismissedFullScreenContent(
                adId,
                new FlutterMBridgeIds(mBridgeIds),
                new FlutterRewardVideoAd.FlutterRewardInfo(rewardInfo));
    }

    void onShowFail(MBridgeIds mBridgeIds, String errorMsg) {
        manager.onFailedToShowFullScreenContent(adId, new FlutterMBridgeIds(mBridgeIds), errorMsg);
    }

    void onAdClicked(MBridgeIds mBridgeIds) {
        manager.onAdClicked(adId, new FlutterMBridgeIds(mBridgeIds));
    }

    void onVideoComplete(MBridgeIds mBridgeIds) {
        manager.onAdCompleted(adId, new FlutterMBridgeIds(mBridgeIds));
    }

    void onAdCloseWithNIReward(MBridgeIds mBridgeIds, RewardInfo rewardInfo) {
        manager.onAdDismissedFullScreenContent(
                adId,
                new FlutterMBridgeIds(mBridgeIds),
                new FlutterRewardVideoAd.FlutterRewardInfo(rewardInfo));
    }

    void onEndcardShow(MBridgeIds mBridgeIds) {
        manager.onAdEndCardShowed(adId, new FlutterMBridgeIds(mBridgeIds));
    }

    /**
     * This class delegates various interstitial ad callbacks to FlutterInterstitialAd.
     * Maintains a weak reference to avoid memory leaks.
     */
    private static final class DelegatingInterstitialCallback implements NewInterstitialListener {

        private final WeakReference<FlutterInterstitialAd> delegate;

        DelegatingInterstitialCallback(FlutterInterstitialAd delegate) {
            this.delegate = new WeakReference<>(delegate);
        }

        /**
         * Called when the ad is loaded , but is not ready to be displayed completely
         * @param mBridgeIds the encapsulated ad id object
         */
        @Override
        public void onLoadCampaignSuccess(MBridgeIds mBridgeIds) {
            Log.d(TAG, "onLoadCampaignSuccess, mBridgeIds: " + mBridgeIds.toString());
        }

        /**
         * Called when the ad is loaded , and is ready to be displayed completely
         * @param mBridgeIds the encapsulated ad id object
         */
        @Override
        public void onResourceLoadSuccess(MBridgeIds mBridgeIds) {
            if (delegate.get() != null) {
                delegate.get().onResourceLoadSuccess(mBridgeIds);
            }
        }

        /**
         * Called when the ad is load failed with the errorMsg
         * @param mBridgeIds the encapsulated ad id object
         * @param errorMsg error message
         */
        @Override
        public void onResourceLoadFail(MBridgeIds mBridgeIds, String errorMsg) {
            if (delegate.get() != null) {
                delegate.get().onResourceLoadFail(mBridgeIds, errorMsg);
            }
        }

        /**
         * Called when the ad is shown
         * @param mBridgeIds the encapsulated ad id object
         */
        @Override
        public void onAdShow(MBridgeIds mBridgeIds) {
            if (delegate.get() != null) {
                delegate.get().onAdShow(mBridgeIds);
            }
        }

        /**
         * Called when the ad is closed
         * @param mBridgeIds the encapsulated ad id object
         * @param rewardInfo the encapsulated reward object
         */
        @Override
        public void onAdClose(MBridgeIds mBridgeIds, RewardInfo rewardInfo) {
            if (delegate.get() != null) {
                delegate.get().onAdClose(mBridgeIds, rewardInfo);
            }
        }

        /**
         * Called when the ad is shown failed
         * @param mBridgeIds the encapsulated ad id object
         * @param errorMsg error message
         */
        @Override
        public void onShowFail(MBridgeIds mBridgeIds, String errorMsg) {
            if (delegate.get() != null) {
                delegate.get().onShowFail(mBridgeIds, errorMsg);
            }
        }

        /**
         * Called when the ad is clicked
         * @param mBridgeIds the encapsulated ad id object
         */
        @Override
        public void onAdClicked(MBridgeIds mBridgeIds) {
            if (delegate.get() != null) {
                delegate.get().onAdClicked(mBridgeIds);
            }
        }

        /**
         * Called when the ad played completely
         * @param mBridgeIds the encapsulated ad id object
         */
        @Override
        public void onVideoComplete(MBridgeIds mBridgeIds) {
            if (delegate.get() != null) {
                delegate.get().onVideoComplete(mBridgeIds);
            }
        }

        /**
         * Called when the ad close if developer set iv reward.
         *
         * @param mBridgeIds the encapsulated ad id object
         * @param rewardInfo the encapsulated reward object
         */
        @Override
        public void onAdCloseWithNIReward(MBridgeIds mBridgeIds, RewardInfo rewardInfo) {
            if (delegate.get() != null) {
                delegate.get().onAdCloseWithNIReward(mBridgeIds, rewardInfo);
            }
        }

        /**
         * Called when the ad endcard be shown
         * @param mBridgeIds the encapsulated ad id object
         */
        @Override
        public void onEndcardShow(MBridgeIds mBridgeIds) {
            if (delegate.get() != null) {
                delegate.get().onEndcardShow(mBridgeIds);
            }
        }
    }
}
