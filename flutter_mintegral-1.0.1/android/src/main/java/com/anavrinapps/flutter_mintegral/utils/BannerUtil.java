package com.anavrinapps.flutter_mintegral.utils;

import android.app.Activity;
import android.graphics.Point;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;

import com.mbridge.msdk.out.BannerAdListener;
import com.mbridge.msdk.out.BannerSize;
import com.mbridge.msdk.out.MBBannerView;

import io.flutter.plugin.common.MethodChannel;

import java.util.HashMap;
import java.util.Map;

import com.anavrinapps.flutter_mintegral.FlutterMintegralPlugin;

public class BannerUtil {
    private static final String TAG = "BannerUtil";
    private Activity activity;
    private Map<String, MBBannerView> cache;
    private static BannerUtil instance;

    private BannerUtil() {
        cache = new HashMap<>();
    }

    public static BannerUtil getInstance() {
        if (instance == null) {
            instance = new BannerUtil();
        }
        return instance;
    }
    public BannerUtil setActivity(Activity activity) {
        this.activity = activity;
        return instance;
    }

    public void createBanner(String placementId, String adUnitId,int width,int height, int refreshTime, boolean closeButton,int bannerType,final MethodChannel channel) {
        MBBannerView mtgBannerView = new MBBannerView(activity);
        mtgBannerView.init(new BannerSize(bannerType, width, height), placementId, adUnitId);
        mtgBannerView.setAllowShowCloseBtn(closeButton);
        mtgBannerView.setRefreshTime(refreshTime);
         mtgBannerView.setBannerAdListener(new BannerAdListener() {
            @Override
            public void onLoadFailed(String msg) {
                OnMethodCallHandler("onBannerLoadFailed",channel);
                Log.e(TAG, "on load failed" + msg);
            }

            @Override
            public void onLoadSuccessed() {
                OnMethodCallHandler("onBannerLoadSuccess",channel);
                Log.e(TAG, "on load successed");
            }

            @Override
            public void onClick() {
                OnMethodCallHandler("onBannerClick",channel);
                Log.e(TAG, "onAdClick");
            }

            @Override
            public void onLeaveApp() {
                OnMethodCallHandler("onBannerLeaveApp",channel);
                Log.e(TAG, "leave app");
            }

            @Override
            public void showFullScreen() {
                OnMethodCallHandler("onBannerFullScreen",channel);
                Log.e(TAG, "showFullScreen");
            }

            @Override
            public void closeFullScreen() {
                OnMethodCallHandler("onBannercloseFullScreen",channel);
                Log.e(TAG, "closeFullScreen");
            }

            @Override
            public void onLogImpression() {
                OnMethodCallHandler("onBannerLogImpression",channel);
                Log.e(TAG, "onLogImpression");
            }

            @Override
            public void onCloseBanner() {
                OnMethodCallHandler("onBannerClose",channel);
                Log.e(TAG, "onCloseBanner");
            }
        });
        cache.put(adUnitId, mtgBannerView);
    }

    public void show(String adUnitId) {
        MBBannerView bannerAd = cache.get(adUnitId);
        if (bannerAd != null) {
            bannerAd.load();
            LinearLayout content = new LinearLayout(activity);
//          LayoutParams params = new LayoutParams(
//         LayoutParams.WRAP_CONTENT,      
//         LayoutParams.WRAP_CONTENT
// );
//             params.setMargins(10, 20, 10, 5);
//             content.setLayoutParams(params);
             content.setOrientation(LinearLayout.VERTICAL);
            content.setGravity(Gravity.BOTTOM);
            content.addView(bannerAd, getUnifiedBannerLayoutParams());
            activity.addContentView(
                    content,
                    new ViewGroup.LayoutParams(
                            ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        }
    }

    public void dispose(String adUnitId) {
        MBBannerView bannerAd = cache.get(adUnitId);
        if (bannerAd != null) {
            bannerAd.release();
            View contentView = (View) bannerAd.getParent();
            if (contentView == null || !(contentView.getParent() instanceof ViewGroup)) return;

            ViewGroup contentParent = (ViewGroup) (contentView.getParent());
            contentParent.removeView(contentView);
            cache.remove(adUnitId);
        }
    }

    private LinearLayout.LayoutParams getUnifiedBannerLayoutParams() {
        Point screenSize = new Point();
        activity.getWindowManager().getDefaultDisplay().getSize(screenSize);
        return new LinearLayout.LayoutParams(screenSize.x, Math.round(screenSize.x / 6.4F));
    }

 void OnMethodCallHandler(final String method,final MethodChannel channel) {
        try {
           FlutterMintegralPlugin.activity.runOnUiThread(new Runnable() {
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