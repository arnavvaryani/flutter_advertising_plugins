package com.mopub_flutter;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.mopub.common.MoPub;
import com.mopub.common.SdkConfiguration;
import com.mopub.common.SdkInitializationListener;
import com.mopub.common.logging.MoPubLog;

import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

import static com.mopub.common.logging.MoPubLog.SdkLogEvent.CUSTOM;

/**
 * MopubFlutterPlugin
 */
public class MopubFlutterPlugin implements MethodCallHandler {

    private Activity activity;

    private MopubFlutterPlugin(Activity activity) {
        this.activity = activity;
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), MopubConstants.MAIN_CHANNEL);
        channel.setMethodCallHandler(new MopubFlutterPlugin(registrar.activity()));

        // Interstitial Ad channel
        final MethodChannel interstitialAdChannel = new MethodChannel(registrar.messenger(),
                MopubConstants.INTERSTITIAL_AD_CHANNEL);
        interstitialAdChannel.setMethodCallHandler(new MopubInterstitialAdPlugin(registrar));

        // Rewarded video Ad channel
        final MethodChannel rewardedAdChannel = new MethodChannel(registrar.messenger(),
                MopubConstants.REWARDED_VIDEO_CHANNEL);
        rewardedAdChannel.setMethodCallHandler(new MopubRewardedVideoAdPlugin(registrar));

        // Banner Ad PlatformView channel
        registrar.platformViewRegistry().registerViewFactory(MopubConstants.BANNER_AD_CHANNEL,
                new MopubBannerAdPlugin(registrar.messenger()));
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals(MopubConstants.INIT_METHOD))
            result.success(init((HashMap) call.arguments));
        else
            result.notImplemented();
    }

    private boolean init(HashMap initValues) {
        final boolean testMode = (boolean) initValues.get("testMode");
        final String adUnitId = (String) initValues.get("adUnitId");

        final SdkConfiguration.Builder configBuilder = new SdkConfiguration.Builder(adUnitId)
                .withLogLevel(testMode ? MoPubLog.LogLevel.DEBUG : MoPubLog.LogLevel.NONE);

        MoPub.initializeSdk(activity, configBuilder.build(), new SdkInitializationListener() {
            @Override
            public void onInitializationFinished() {
                MoPubLog.log(CUSTOM, "##Flutter## MoPub SDK initialized." +
                        " AdUnitId: " + adUnitId + " TestMode:" + testMode);
            }
        });

        return true;
    }
}
