package com.anavrinapps.flutter_mintegral;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.anavrinapps.flutter_mintegral.activity.SplashAdActivity;
import com.anavrinapps.flutter_mintegral.utils.BannerUtil;
import com.anavrinapps.flutter_mintegral.utils.InteractiveAdUtil;
import com.anavrinapps.flutter_mintegral.utils.InterstitialVideoUtil;
import com.anavrinapps.flutter_mintegral.utils.RewardVideoUtil;
// import com.anavrinapps.flutter_mintegral.utils.BannerFactory;

import com.mbridge.msdk.MBridgeConstans;
import com.mbridge.msdk.MBridgeSDK;
import com.mbridge.msdk.out.MBridgeSDKFactory;
import com.mbridge.msdk.out.SDKInitStatusListener;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformViewRegistry;
import io.flutter.plugin.common.BinaryMessenger;


public class FlutterMintegralPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private static MethodChannel channel;
    private static Context context;
    public static Activity activity;
    private FlutterPluginBinding flutterPluginBinding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
        // this.RegistrarBanner(flutterPluginBinding.getPlatformViewRegistry(), flutterPluginBinding.getBinaryMessenger());
    }

    public static void registerWith(Registrar registrar) {
        channel = new MethodChannel(registrar.messenger(), "flutter_mintegral");
        channel.setMethodCallHandler(new FlutterMintegralPlugin());
        activity = registrar.activity();
        context = registrar.context();
        // registrar.platformViewRegistry().registerViewFactory("/Banner", new BannerFactory(registrar.messenger()));
    }

// private void RegistrarBanner(PlatformViewRegistry registry, BinaryMessenger messenger) {
//         registry.registerViewFactory("/Banner", new BannerFactory(messenger));
//     }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("initAdSDK")) {
            if (call.hasArgument("appId") && call.hasArgument("appKey")) {
                String appId = call.argument("appId");
                String appKey = call.argument("appKey");
                MBridgeSDK sdk = MBridgeSDKFactory.getMBridgeSDK();
                Map < String, String > map = sdk.getMBConfigurationMap(appId, appKey);
                boolean isProtectGDPR = call.argument("isProtectGDPR");
                sdk.setConsentStatus(activity, isProtectGDPR ? MBridgeConstans.IS_SWITCH_OFF : MBridgeConstans.IS_SWITCH_ON);
                sdk.init(map, context, new SDKInitStatusListener() {
                    @Override
                    public void onInitSuccess() {
                        OnMethodCallHandler("onInitSuccess");
                        Log.e("SDKInitStatus", "onInitSuccess");
                    }

                    @Override
                    public void onInitFail() {
                        OnMethodCallHandler("onInitFailure");
                        Log.e("SDKInitStatus", "onInitFail");
                    }
                });
                boolean isProtectCCPA = call.argument("isProtectCCPA");
                sdk.setDoNotTrackStatus(isProtectCCPA);
            }
            result.success(null);
        } else if(call.method.equals("disposeBannerAD")) {
            String adUnitId = call.argument("adUnitId").toString();
            BannerUtil.getInstance().dispose(adUnitId);
        } 
        else if (call.method.equals("showBannerAD")) {
            String adUnitId = call.argument("adUnitId").toString();
            String placementId = call.argument("placementId").toString();
            int height = call.argument("height");
            int width = call.argument("width");
            int refreshTime = call.argument("refreshTime");
            boolean closeButton = call.argument("closeButton");
            int bannerType = call.argument("bannerType");
            BannerUtil.getInstance().setActivity(activity).createBanner(placementId, adUnitId,width,height,refreshTime,closeButton,bannerType,channel);
            BannerUtil.getInstance().show(adUnitId);
            result.success(null);
        }
        else if (call.method.equals("startSplashAd")) {
            String adUnitId = call.argument("adUnitId").toString();
            String placementId = call.argument("placementId").toString();
            String launchBackgroundIdStr = call.argument("launchBackgroundId");
            int launchBackgroundId;
            if (TextUtils.isEmpty(launchBackgroundIdStr)) {
                launchBackgroundId = -1;
            } else {
                Resources res = activity.getResources();
                launchBackgroundId = res.getIdentifier(launchBackgroundIdStr, "drawable", activity.getPackageName());
            }
            Intent intent = new Intent(activity, SplashAdActivity.class);
            intent.putExtra("adUnitId", adUnitId);
            intent.putExtra("placementId", placementId);
            intent.putExtra("launchBackgroundId", launchBackgroundId);
            activity.startActivity(intent);
            result.success(null);
        } else if(call.method.equals("showInteractiveAD")) {
            InteractiveAdUtil.getInstance().setActivity(activity).show();
            result.success(null);
        } else if (call.method.equals("loadInteractiveAD")) {
            String adUnitId = call.argument("adUnitId").toString();
            String placementId = call.argument("placementId").toString();
            InteractiveAdUtil.getInstance().setActivity(activity).load(adUnitId, placementId, channel);
            result.success(null);
        } else if(call.method.equals("showRewardedVideoAD")) {
            String userId = call.argument("userId");
            String rewardId = call.argument("rewardId");
            RewardVideoUtil.getInstance().setActivity(activity).show(userId, rewardId); 
            result.success(null);
        }
        else if (call.method.equals("showInterstitialVideoAD")) {
            InterstitialVideoUtil.getInstance().setActivity(activity).show();
            result.success(null);
        } else if (call.method.equals("loadInterstitialVideoAD")) {
            String adUnitId = call.argument("adUnitId").toString();
            String placementId = call.argument("placementId").toString();
            InterstitialVideoUtil.getInstance().setActivity(activity).load(adUnitId, placementId, channel);
            result.success(null);
        } else if (call.method.equals("loadRewardVideoAD")) {
            String adUnitId = call.argument("adUnitId").toString();
            String placementId = call.argument("placementId").toString();
            String userId = call.argument("userId");
            String rewardId = call.argument("rewardId");
            RewardVideoUtil.getInstance().setActivity(activity).load(adUnitId, placementId, userId, rewardId, channel);
            result.success(null);
        } else {
            result.notImplemented();
        }

    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_mintegral");
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {
        flutterPluginBinding = null;
    }

    void OnMethodCallHandler(final String method) {
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