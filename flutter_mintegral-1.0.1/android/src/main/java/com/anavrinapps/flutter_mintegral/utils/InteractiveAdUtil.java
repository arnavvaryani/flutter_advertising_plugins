package com.anavrinapps.flutter_mintegral.utils;

import android.app.Activity;

import com.mbridge.msdk.MBridgeConstans;
import com.mbridge.msdk.interactiveads.out.InteractiveAdsListener;
import com.mbridge.msdk.interactiveads.out.MBInteractiveHandler;

import io.flutter.plugin.common.MethodChannel;

import java.util.HashMap;

import io.flutter.Log;

import com.anavrinapps.flutter_mintegral.*;

public class InteractiveAdUtil {
    private static final String TAG = "InteractiveAdUtil";

    private static InteractiveAdUtil instance;
    private MBInteractiveHandler mInterstitialHandler;
    private Activity activity;

    private InteractiveAdUtil() {}

    public static InteractiveAdUtil getInstance() {
        if (instance == null) {
            instance = new InteractiveAdUtil();
        }
        return instance;
    }
    public InteractiveAdUtil setActivity(Activity activity) {
        this.activity = activity;
        return instance;
    }
    
    public void load(String adUnitId, String placementId, MethodChannel channel) {
        initHandler(adUnitId, placementId, channel);
        mInterstitialHandler.load();
    }
    
    public void show() {
        mInterstitialHandler.show();
    }
    private void initHandler(String adUnitId, String placementId, final MethodChannel channel) {
        HashMap < String, Object > hashMap = new HashMap < String, Object > ();
        hashMap.put(MBridgeConstans.PROPERTIES_UNIT_ID, adUnitId);
        hashMap.put(MBridgeConstans.PLACEMENT_ID, placementId);
        mInterstitialHandler = new MBInteractiveHandler(activity, hashMap);
        mInterstitialHandler.setInteractiveAdsListener(new InteractiveAdsListener() {
            @Override
            public void onInteractivelLoadSuccess(int restype) {
                Log.e(TAG, "onInteractivelLoadSuccess");
                OnMethodCallHandler("onInteractivelLoadSuccess", false, channel);
            }

            @Override
            public void onInterActiveMaterialLoadSuccess() {
                Log.e(TAG, "onInterActiveMaterialLoadSuccess");
                OnMethodCallHandler("onInterActiveMaterialLoadSuccess", false, channel);
            }

            @Override
            public void onInteractiveLoadFail(String errorMsg) {
                Log.e(TAG, "onInteractiveLoadFail");
                OnMethodCallHandler("onInteractiveLoadFail", false, channel);
            }

            @Override
            public void onInteractiveShowSuccess() {
                Log.e(TAG, "onInteractiveShowSuccess");
                OnMethodCallHandler("onInteractiveShowSuccess", false, channel);
            }

            @Override
            public void onInteractiveShowFail(String errorMsg) {
                Log.e(TAG, "onInteractiveShowFail " + errorMsg);
                OnMethodCallHandler("onInteractiveShowFail", false, channel);
            }

            @Override
            public void onInteractiveClosed() {
                Log.e(TAG, "onInteractiveClosed");
                OnMethodCallHandler("onInteractiveClosed", false, channel);
            }

            @Override
            public void onInteractiveAdClick() {
                Log.e(TAG, "onInteractiveAdClick");
                OnMethodCallHandler("onInteractiveAdClick", false, channel);
            }

            @Override
            public void onInteractivePlayingComplete(boolean isComplete) {
                Log.e(TAG, "onInteractivePlayingComplete isComplete = " + isComplete);
                OnMethodCallHandler("onInteractivePlayingComplete", isComplete, channel);
            }
        });
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