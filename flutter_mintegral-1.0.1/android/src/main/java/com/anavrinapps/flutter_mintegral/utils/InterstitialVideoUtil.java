package com.anavrinapps.flutter_mintegral.utils;

import android.app.Activity;
import android.content.IntentFilter;
import android.net.ConnectivityManager;

import com.mbridge.msdk.MBridgeConstans;
import com.mbridge.msdk.interstitialvideo.out.InterstitialVideoListener;
import com.mbridge.msdk.interstitialvideo.out.MBInterstitialVideoHandler;
import com.mbridge.msdk.videocommon.download.NetStateOnReceive;

import io.flutter.plugin.common.MethodChannel;

import io.flutter.Log;

import com.anavrinapps.flutter_mintegral.*;

public class InterstitialVideoUtil {
    private static final String TAG = "InterstitialVideoUtil";
    private static InterstitialVideoUtil instance;
    private MBInterstitialVideoHandler mMtgInterstitalVideoHandler;
    private NetStateOnReceive mNetStateOnReceive;
    private Activity activity;

    private InterstitialVideoUtil() {}

    public static InterstitialVideoUtil getInstance() {
        if (instance == null) {
            instance = new InterstitialVideoUtil();
        }
        return instance;
    }

    public InterstitialVideoUtil setActivity(Activity activity) {
        this.activity = activity;
        return instance;
    }

    public void load(String adUnitId, String placementId, final MethodChannel channel) {
        initHandler(adUnitId, placementId, channel);
        if (mMtgInterstitalVideoHandler != null) {
            mMtgInterstitalVideoHandler.load();
        }
    }

    public void show() {
    if (mMtgInterstitalVideoHandler != null && mMtgInterstitalVideoHandler.isReady()) {
     mMtgInterstitalVideoHandler.show();
    }
    }

    private void initHandler(String adUnitId, String placementId, final MethodChannel channel) {
        try {
            if (mNetStateOnReceive == null) {
                mNetStateOnReceive = new NetStateOnReceive();
                IntentFilter filter = new IntentFilter();
                filter.addAction(ConnectivityManager.CONNECTIVITY_ACTION);
                activity.registerReceiver(mNetStateOnReceive, filter);
            }

            mMtgInterstitalVideoHandler = new MBInterstitialVideoHandler(activity, placementId, adUnitId);
            mMtgInterstitalVideoHandler.setInterstitialVideoListener(new InterstitialVideoListener() {

                @Override
                public void onLoadSuccess(String placementId, String unitId) {
                    Log.e(TAG, "onLoadSuccess:" + Thread.currentThread());
                    OnMethodCallHandler("onInterstitalLoadSuccess", false, channel);
                }

                @Override
                public void onVideoLoadSuccess(String placementId, String unitId) {
                    Log.e(TAG, "onVideoLoadSuccess:" + Thread.currentThread());
                    if (mMtgInterstitalVideoHandler != null && mMtgInterstitalVideoHandler.isReady()) {
                        OnMethodCallHandler("onInterstitialVideoLoadSuccess", false, channel);
                    }
                }

                @Override
                public void onVideoLoadFail(String errorMsg) {
                    OnMethodCallHandler("onInterstitalVideoLoadFail", false, channel);
                    Log.e(TAG, "onVideoLoadFail errorMsg:" + errorMsg);
                }

                @Override
                public void onShowFail(String errorMsg) {
                    OnMethodCallHandler("onInterstitalShowFail", false, channel);
                    Log.e(TAG, "onShowFail=" + errorMsg);
                }

                @Override
                public void onAdShow() {
                    OnMethodCallHandler("onInterstitalAdShow", false, channel);
                    Log.e(TAG, "onAdShow");
                }

                @Override
                public void onAdClose(boolean isCompleteView) {
                    OnMethodCallHandler("onInterstitalAdClose", false, channel);
                    Log.e(TAG, "onAdClose rewardinfo :" + "isCompleteView：" + isCompleteView);
                }

                @Override
                public void onVideoAdClicked(String placementId, String unitId) {
                    OnMethodCallHandler("onInterstitalVideoClicked", false, channel);
                    Log.e(TAG, "onVideoAdClicked");
                }

                @Override
                public void onVideoComplete(String placementId, String unitId) {
                    OnMethodCallHandler("onInterstitalVideoComplete", false, channel);
                    Log.e(TAG, "onVideoComplete");
                }

                @Override
                public void onAdCloseWithIVReward(boolean isComplete, int rewardAlertStatus) {
                    Log.e(TAG, "onAdCloseWithIVReward");
                    Log.e(TAG, isComplete ? "Video playback/playable is complete." : "Video playback/playable is not complete.");
                    OnMethodCallHandler("onInterstitalAdCloseWithIVReward", isComplete, channel);

                    if (rewardAlertStatus == MBridgeConstans.IVREWARDALERT_STATUS_NOTSHOWN) {
                        OnMethodCallHandler("onInterstitalAdCloseStatusNotShown", isComplete, channel);
                        Log.e(TAG, "The dialog is not show.");
                    }

                    if (rewardAlertStatus == MBridgeConstans.IVREWARDALERT_STATUS_CLICKCONTINUE) {
                        OnMethodCallHandler("onInterstitalAdCloseStatusClickContinue", isComplete, channel);
                        Log.e(TAG, "The dialog's continue button clicked.");
                    }

                    if (rewardAlertStatus == MBridgeConstans.IVREWARDALERT_STATUS_CLICKCANCEL) {
                        OnMethodCallHandler("onInterstitalAdCloseStatusClickCancel", isComplete, channel);
                        Log.e(TAG, "The dialog's cancel button clicked.");
                    }
                }

                @Override
                public void onEndcardShow(String placementId, String unitId) {
                    OnMethodCallHandler("onInterstitalEndcardShow", false, channel);
                    Log.e(TAG, "onEndcardShow");
                }

            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    void OnMethodCallHandler(final String method, final boolean isComplete, final MethodChannel channel) {
        try {
            activity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod(method, isComplete);
                }
            });
        } catch (Exception e) {
            Log.e("MintegralSDK", "Error " + e.toString());
        }
    }
}