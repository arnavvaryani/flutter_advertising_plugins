package com.anavrinapps.flutter_mintegral.utils;

import android.app.Activity;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.text.TextUtils;

import com.mbridge.msdk.out.MBRewardVideoHandler;
import com.mbridge.msdk.out.RewardVideoListener;
import com.mbridge.msdk.videocommon.download.NetStateOnReceive;

import io.flutter.plugin.common.MethodChannel;

import io.flutter.Log;

import com.anavrinapps.flutter_mintegral.*;

public class RewardVideoUtil {
    private static final String TAG = "RewardVideoUtil";
    private static RewardVideoUtil instance;
    private MBRewardVideoHandler mMTGRewardVideoHandler;
    private NetStateOnReceive mNetStateOnReceive;
    private Activity activity;

    private RewardVideoUtil() {}

    public static RewardVideoUtil getInstance() {
        if (instance == null) {
            instance = new RewardVideoUtil();
        }
        return instance;
    }

    public RewardVideoUtil setActivity(Activity activity) {
        this.activity = activity;
        return instance;
    }

    public void load(String adUnitId, String placementId, String userId, String rewardId, MethodChannel channel) {
        initHandler(adUnitId, placementId, userId, rewardId, channel);
        mMTGRewardVideoHandler.load();
    }

    public void show(String userId, String rewardId) {
        mMTGRewardVideoHandler.show(rewardId, userId);
    }

    private void initHandler(String adUnitId, String placementId, final String userId, final String rewardId, final MethodChannel channel) {
        try {
            if (mNetStateOnReceive == null) {
                mNetStateOnReceive = new NetStateOnReceive();
                IntentFilter filter = new IntentFilter();
                filter.addAction(ConnectivityManager.CONNECTIVITY_ACTION);
                activity.registerReceiver(mNetStateOnReceive, filter);
            }

            mMTGRewardVideoHandler = new MBRewardVideoHandler(activity, placementId, adUnitId);

            mMTGRewardVideoHandler.setRewardVideoListener(new RewardVideoListener() {

                @Override
                public void onLoadSuccess(String placementId, String unitId) {
                    OnMethodCallHandler("onRewardLoadSuccess", 0, channel);
                    Log.e(TAG, "onLoadSuccess: " + (TextUtils.isEmpty(placementId) ? "" : placementId) + "  " + unitId);
                }

                @Override
                public void onVideoLoadSuccess(String placementId, String unitId) {
                    Log.e(TAG, "onVideoLoadSuccess: " + (TextUtils.isEmpty(placementId) ? "" : placementId) + "  " + unitId);
                    if (mMTGRewardVideoHandler.isReady()) {
                        OnMethodCallHandler("onRewardVideoLoadSuccess", 0, channel);
                    }
                }

                @Override
                public void onVideoLoadFail(String errorMsg) {
                    OnMethodCallHandler("onRewardVideoLoadFail", 0, channel);
                    Log.e(TAG, "onVideoLoadFail errorMsg: " + errorMsg);
                }

                @Override
                public void onShowFail(String errorMsg) {
                    OnMethodCallHandler("onRewardVideoShowFail", 0, channel);
                    Log.e(TAG, "onShowFail: " + errorMsg);
                }

                @Override
                public void onAdShow() {
                    OnMethodCallHandler("onRewardAdShow", 0, channel);
                    Log.e(TAG, "onAdShow");
                }

                @Override
                public void onAdClose(boolean isCompleteView, String RewardName, float RewardAmout) {
                    OnMethodCallHandler("onRewardAdClose", RewardAmout, channel);
                    Log.e(TAG, "onAdClose rewardinfo : " + "RewardName:" + RewardName + "RewardAmout:" + RewardAmout + " isCompleteView：" + isCompleteView);
                }

                @Override
                public void onVideoAdClicked(String placementId, String unitId) {
                    OnMethodCallHandler("onRewardVideoAdClicked", 0, channel);
                    Log.e(TAG, "onVideoAdClicked : " + (TextUtils.isEmpty(placementId) ? "" : placementId) + "  " + unitId);
                }

                @Override
                public void onVideoComplete(String placementId, String unitId) {
                    OnMethodCallHandler("onRewardVideoComplete", 0, channel);
                    Log.e(TAG, "onVideoComplete : " + (TextUtils.isEmpty(placementId) ? "" : placementId) + "  " + unitId);
                }

                @Override
                public void onEndcardShow(String placementId, String unitId) {
                    OnMethodCallHandler("onRewardEndcardShow", 0, channel);
                    Log.e(TAG, "onEndcardShow : " + (TextUtils.isEmpty(placementId) ? "" : placementId) + "  " + unitId);
                }

            });
            mMTGRewardVideoHandler.setRewardPlus(true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    void OnMethodCallHandler(final String method, final float reward, final MethodChannel channel) {
        try {
            activity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod(method, null);
                }
            });
        } catch (Exception e) {
            Log.e("MintegralSDK", "Error " + e.toString());
        }
    }
}