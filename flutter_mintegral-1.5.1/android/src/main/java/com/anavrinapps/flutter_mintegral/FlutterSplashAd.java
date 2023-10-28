package com.anavrinapps.flutter_mintegral;

import android.util.Log;
import android.view.DisplayCutout;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowInsets;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.mbridge.msdk.out.MBSplashHandler;
import com.mbridge.msdk.out.MBSplashLoadListener;
import com.mbridge.msdk.out.MBSplashShowListener;
import com.mbridge.msdk.out.MBridgeIds;

import java.lang.ref.WeakReference;

/** A wrapper for {@link MBSplashHandler}. */
public class FlutterSplashAd extends FlutterAd.FlutterOverlayAd {
    private static final String TAG = "FlutterSplashAd";

    @NonNull private final AdInstanceManager manager;
    @NonNull private final String placementId;
    @NonNull private final String unitId;
    @Nullable MBSplashHandler mbSplashHandler;
    @Nullable LinearLayout container;

    /** Constructor */
    public FlutterSplashAd(
            int adId,
            @NonNull AdInstanceManager manager,
            @NonNull String placementId,
            @NonNull String unitId) {
        super(adId);
        this.manager = manager;
        this.placementId = placementId;
        this.unitId = unitId;
    }

    @Override
    void onPause() {
        if (mbSplashHandler != null) {
            mbSplashHandler.onPause();
        }
    }

    @Override
    void onResume() {
        if (mbSplashHandler != null) {
            mbSplashHandler.onResume();
        }
    }

    @Override
    void load() {
        if (mbSplashHandler == null) {
            DelegatingSplashCallback delegate = new DelegatingSplashCallback(this);
            mbSplashHandler = new MBSplashHandler(placementId, unitId);
            mbSplashHandler.setSplashLoadListener(delegate);
            mbSplashHandler.setSplashShowListener(delegate);
        }
        mbSplashHandler.preLoad();
    }

    @Override
    void show() {
        if (mbSplashHandler == null || !mbSplashHandler.isReady()) {
            Log.e(TAG, "Error showing splash - the splash ad wasn't loaded yet.");
        }

        if (manager.getActivity() == null) {
            Log.e(TAG, "Tried to show splash ad before activity was bound to the plugin.");
            return;
        }

        if (container == null) {
            int paddingTop = 0;
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
                View decorView = manager.getActivity().getWindow().getDecorView();
                if (decorView != null) {
                    WindowInsets windowInsets = decorView.getRootWindowInsets();
                    if (windowInsets != null) {
                        DisplayCutout cutout = windowInsets.getDisplayCutout();
                        if (cutout != null) {
                            paddingTop = cutout.getSafeInsetTop();
                            Log.d(TAG, "SafeInsetTop: " + cutout.getSafeInsetTop());
                        }
                    }
                }
            }

            container = new LinearLayout(manager.getActivity());
            container.setPadding(0, paddingTop, 0, 0);
            manager.getActivity().addContentView(container, new ViewGroup.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        }

        mbSplashHandler.show(container);
    }

    @Override
    void dispose() {
        if (container != null) {
            ViewGroup parent = (ViewGroup) container.getParent();
            parent.removeView(container);
            container = null;
        }
        if (mbSplashHandler != null) {
            mbSplashHandler.onDestroy();
            mbSplashHandler = null;
        }
    }

    public void onLoadSuccessed(MBridgeIds ids) {
        manager.onAdLoaded(adId, new FlutterMBridgeIds(ids));
    }

    public void onLoadFailed(MBridgeIds ids, String errorMsg) {
        manager.onAdFailedToLoad(adId, new FlutterMBridgeIds(ids), errorMsg);
    }

    public void onShowSuccessed(MBridgeIds ids) {
        manager.onAdShowedFullScreenContent(adId, new FlutterMBridgeIds(ids));
    }

    public void onShowFailed(MBridgeIds ids, String errorMsg) {
        manager.onFailedToShowFullScreenContent(adId, new FlutterMBridgeIds(ids), errorMsg);
    }

    public void onAdClicked(MBridgeIds ids) {
        manager.onAdClicked(adId, new FlutterMBridgeIds(ids));
    }

    public void onDismiss(MBridgeIds ids, int type) {
        manager.onAdDismissedFullScreenContent(adId, new FlutterMBridgeIds(ids), type);
    }

    /**
     * This class delegates various splash ad callbacks to FlutterSplashAd. Maintains a weak
     * reference to avoid memory leaks.
     */
    private static final class DelegatingSplashCallback
            implements MBSplashLoadListener, MBSplashShowListener {

        private final WeakReference<FlutterSplashAd> delegate;

        DelegatingSplashCallback(FlutterSplashAd delegate) {
            this.delegate = new WeakReference<>(delegate);
        }

        @Override
        public void onLoadSuccessed(MBridgeIds mBridgeIds, int reqType) {
            if (delegate.get() != null) {
                delegate.get().onLoadSuccessed(mBridgeIds);
            }
        }

        @Override
        public void onLoadFailed(MBridgeIds mBridgeIds, String errorMsg, int reqType) {
            if (delegate.get() != null) {
                delegate.get().onLoadFailed(mBridgeIds, errorMsg);
            }
        }

        @Override
        public void isSupportZoomOut(MBridgeIds mBridgeIds, boolean b) {
            Log.d(TAG, "isSupportZoomOut, mBridgeIds: " + mBridgeIds.toString() + ", b: " + b);
        }

        @Override
        public void onShowSuccessed(MBridgeIds mBridgeIds) {
            if (delegate.get() != null) {
                delegate.get().onShowSuccessed(mBridgeIds);
            }
        }

        @Override
        public void onShowFailed(MBridgeIds mBridgeIds, String errorMsg) {
            if (delegate.get() != null) {
                delegate.get().onShowFailed(mBridgeIds, errorMsg);
            }
        }

        @Override
        public void onAdClicked(MBridgeIds mBridgeIds) {
            if (delegate.get() != null) {
                delegate.get().onAdClicked(mBridgeIds);
            }
        }

        @Override
        public void onDismiss(MBridgeIds mBridgeIds, int type) {
            if (delegate.get() != null) {
                delegate.get().onDismiss(mBridgeIds, type);
            }
        }

        @Override
        public void onAdTick(MBridgeIds mBridgeIds, long millisUntilFinished) {
            Log.d(TAG, "onAdTick, mBridgeIds: " + mBridgeIds.toString()
                    + ", millisUntilFinished: " + millisUntilFinished);
        }

        @Override
        public void onZoomOutPlayStart(MBridgeIds mBridgeIds) {
            Log.d(TAG, "onZoomOutPlayStart, mBridgeIds: " + mBridgeIds.toString());
        }

        @Override
        public void onZoomOutPlayFinish(MBridgeIds mBridgeIds) {
            Log.d(TAG, "onZoomOutPlayFinish, mBridgeIds: " + mBridgeIds.toString());
        }
    }
}
