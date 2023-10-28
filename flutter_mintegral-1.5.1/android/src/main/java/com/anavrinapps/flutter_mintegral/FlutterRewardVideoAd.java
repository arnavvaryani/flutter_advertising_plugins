package com.anavrinapps.flutter_mintegral;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.mbridge.msdk.out.MBRewardVideoHandler;
import com.mbridge.msdk.out.MBridgeIds;
import com.mbridge.msdk.out.RewardInfo;
import com.mbridge.msdk.out.RewardVideoListener;

import java.lang.ref.WeakReference;
import java.util.Objects;

/** A wrapper for {@link MBRewardVideoHandler}. */
public class FlutterRewardVideoAd extends FlutterAd.FlutterOverlayAd {
    private static final String TAG = "FlutterRewardVideoAd";

    @NonNull private final AdInstanceManager manager;
    @NonNull private final String placementId;
    @NonNull private final String unitId;
    @Nullable MBRewardVideoHandler mMBRewardVideoHandler;

    private boolean isRewardPlus = false;

    /** A wrapper for {@link RewardInfo}. */
    static class FlutterRewardInfo {
        @NonNull final Boolean isCompleteView;
        @NonNull final String rewardName;
        @NonNull final String rewardAmount;
        @NonNull final Integer rewardAlertStatus;

        FlutterRewardInfo(@NonNull RewardInfo rewardInfo) {
            this.isCompleteView = rewardInfo.isCompleteView();
            this.rewardName = rewardInfo.getRewardName();
            this.rewardAmount = rewardInfo.getRewardAmount();
            this.rewardAlertStatus = rewardInfo.getRewardAlertStatus();
        }

        FlutterRewardInfo(
                @NonNull Boolean isCompleteView,
                @NonNull String rewardName,
                @NonNull String rewardAmount,
                @NonNull Integer rewardAlertStatus) {
            this.isCompleteView = isCompleteView;
            this.rewardName = rewardName;
            this.rewardAmount = rewardAmount;
            this.rewardAlertStatus = rewardAlertStatus;
        }

        @Override
        public boolean equals(Object other) {
            if (this == other) {
                return true;
            } else if (!(other instanceof FlutterRewardInfo)) {
                return false;
            }

            final FlutterRewardInfo that = (FlutterRewardInfo) other;
            return Objects.equals(isCompleteView, that.isCompleteView)
                    && Objects.equals(rewardName, that.rewardName)
                    && Objects.equals(rewardAmount, that.rewardAmount)
                    && Objects.equals(rewardAlertStatus, that.rewardAlertStatus);
        }

        @Override
        public int hashCode() {
            int result = rewardAlertStatus.hashCode();
            result = 31 * result + isCompleteView.hashCode();
            result = 31 * result + rewardName.hashCode();
            result = 31 * result + rewardAmount.hashCode();
            return result;
        }
    }

    /** Constructor */
    public FlutterRewardVideoAd(
            int adId,
            @NonNull AdInstanceManager manager,
            @NonNull String placementId,
            @NonNull String unitId) {
        super(adId);
        this.manager = manager;
        this.placementId = placementId;
        this.unitId = unitId;
    }

    public void setRewardPlus(boolean isRewardPlus) {
        if (mMBRewardVideoHandler != null) {
            Log.e(TAG, "Error setting reward plus - reward plus must be called before load.");
        }
        this.isRewardPlus = isRewardPlus;
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
        if (mMBRewardVideoHandler == null) {
            mMBRewardVideoHandler = new MBRewardVideoHandler(manager.getActivity(), placementId, unitId);
            mMBRewardVideoHandler.setRewardVideoListener(new DelegatingRewardCallback(this));
            mMBRewardVideoHandler.setRewardPlus(isRewardPlus);
        }
        mMBRewardVideoHandler.load();
    }

    @Override
    void show() {
        if (mMBRewardVideoHandler == null || !mMBRewardVideoHandler.isReady()) {
            Log.e(TAG, "Error showing reward - the reward ad wasn't loaded yet.");
        }
        mMBRewardVideoHandler.show();
    }

    @Override
    void dispose() {
        mMBRewardVideoHandler = null;
    }

    public void onVideoLoadSuccess(MBridgeIds ids) {
        manager.onAdLoaded(adId, new FlutterMBridgeIds(ids));
    }

    public void onVideoLoadFail(MBridgeIds ids, String errorMsg) {
        manager.onAdFailedToLoad(adId, new FlutterMBridgeIds(ids), errorMsg);
    }

    public void onAdShow(MBridgeIds ids) {
        manager.onAdShowedFullScreenContent(adId, new FlutterMBridgeIds(ids));
    }

    public void onAdClose(MBridgeIds ids, RewardInfo rewardInfo) {
        manager.onAdDismissedFullScreenContent(
                adId,
                new FlutterMBridgeIds(ids),
                new FlutterRewardInfo(rewardInfo));
    }

    public void onShowFail(MBridgeIds ids, String errorMsg) {
        manager.onFailedToShowFullScreenContent(adId, new FlutterMBridgeIds(ids), errorMsg);
    }

    public void onVideoAdClicked(MBridgeIds ids) {
        manager.onAdClicked(adId, new FlutterMBridgeIds(ids));
    }

    public void onVideoComplete(MBridgeIds ids) {
        manager.onAdCompleted(adId, new FlutterMBridgeIds(ids));
    }

    public void onEndCardShow(MBridgeIds ids) {
        manager.onAdEndCardShowed(adId, new FlutterMBridgeIds(ids));
    }

    /**
     * This class delegates various reward ad callbacks to FlutterRewardVideoAd. Maintains a weak
     * reference to avoid memory leaks.
     */
    private static final class DelegatingRewardCallback implements RewardVideoListener {

        private final WeakReference<FlutterRewardVideoAd> delegate;

        DelegatingRewardCallback(FlutterRewardVideoAd delegate) {
            this.delegate = new WeakReference<>(delegate);
        }

        @Override
        public void onVideoLoadSuccess(MBridgeIds mBridgeIds) {
            if (delegate.get() != null) {
                delegate.get().onVideoLoadSuccess(mBridgeIds);
            }
        }

        @Override
        public void onLoadSuccess(MBridgeIds mBridgeIds) {
            Log.d(TAG, "onLoadSuccess, mBridgeIds: " + mBridgeIds.toString());
        }

        @Override
        public void onVideoLoadFail(MBridgeIds mBridgeIds, String errorMsg) {
            if (delegate.get() != null) {
                delegate.get().onVideoLoadFail(mBridgeIds, errorMsg);
            }
        }

        @Override
        public void onAdShow(MBridgeIds mBridgeIds) {
            if (delegate.get() != null) {
                delegate.get().onAdShow(mBridgeIds);
            }
        }

        @Override
        public void onAdClose(MBridgeIds mBridgeIds, RewardInfo rewardInfo) {
            if (delegate.get() != null) {
                delegate.get().onAdClose(mBridgeIds, rewardInfo);
            }
        }

        @Override
        public void onShowFail(MBridgeIds mBridgeIds, String errorMsg) {
            if (delegate.get() != null) {
                delegate.get().onShowFail(mBridgeIds, errorMsg);
            }
        }

        @Override
        public void onVideoAdClicked(MBridgeIds mBridgeIds) {
            if (delegate.get() != null) {
                delegate.get().onVideoAdClicked(mBridgeIds);
            }
        }

        @Override
        public void onVideoComplete(MBridgeIds mBridgeIds) {
            if (delegate.get() != null) {
                delegate.get().onVideoComplete(mBridgeIds);
            }
        }

        @Override
        public void onEndcardShow(MBridgeIds mBridgeIds) {
            if (delegate.get() != null) {
                delegate.get().onEndCardShow(mBridgeIds);
            }
        }
    }
}
