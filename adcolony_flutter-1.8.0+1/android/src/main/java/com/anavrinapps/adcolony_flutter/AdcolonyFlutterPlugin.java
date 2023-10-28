package com.anavrinapps.adcolony_flutter;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.adcolony.sdk.AdColony;
import com.adcolony.sdk.AdColonyAppOptions;
import com.adcolony.sdk.AdColonyInterstitial;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Objects;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.platform.PlatformViewRegistry;

public class AdcolonyFlutterPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

    @SuppressLint("StaticFieldLeak")
    private static AdcolonyFlutterPlugin Instance;
    private static MethodChannel Channel;
    @SuppressLint("StaticFieldLeak")
    static Activity ActivityInstance;
    static AdColonyInterstitial Ad;
    private static final Listeners listeners = new Listeners();

    static AdcolonyFlutterPlugin getInstance() {
        return Instance;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.onAttachedToEngine(flutterPluginBinding.getBinaryMessenger());
        this.registerBanner(flutterPluginBinding.getPlatformViewRegistry());
    }

    public static void registerWith(Registrar registrar) {
        if (ActivityInstance == null) ActivityInstance = registrar.activity();
        if (Instance == null) Instance = new AdcolonyFlutterPlugin();
        Instance.onAttachedToEngine(registrar.messenger());
        Instance.registerBanner(registrar.platformViewRegistry());
    }

    private void registerBanner(PlatformViewRegistry registry) {
        registry.registerViewFactory("/Banner", new BannerFactory());
    }

    private void onAttachedToEngine(BinaryMessenger messenger) {
        if (Instance == null) {
            Instance = new AdcolonyFlutterPlugin();
        }
        if (Channel != null) {
            return;
        }
        Channel = new MethodChannel(messenger, "AdColony");
        Channel.setMethodCallHandler(this);
    }

    void onMethodCallHandler(final String method, final int reward) {
        try {
            ActivityInstance.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    Channel.invokeMethod(method, reward);
                }
            });
        } catch (Exception e) {
            Log.e("AdColony", "Error " + e.toString());
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        try {
            switch (call.method) {
                case "Init":
                    this.initSdk((HashMap) call.arguments);
                    result.success(Boolean.TRUE);
                    break;
                case "Request":
                    AdColony.requestInterstitial((String) call.argument("Id"), listeners);
                    result.success(Boolean.TRUE);
                    break;
                case "Show":
                    if (Ad != null) {
                        Ad.show();
                        result.success(Boolean.TRUE);
                    }
                    break;
                case "isLoaded":
                    result.success(Ad != null);
                    break;
            }
        } catch (Exception e) {
            Log.e("AdColony", "Error " + e.toString());
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    private void initSdk(final HashMap args) {
        try {
            if (ActivityInstance != null) {
                AdColonyAppOptions options = new AdColonyAppOptions() {
                    {
                        setKeepScreenOn(true);
                        setGDPRConsentString((String) Objects.requireNonNull(args.get("Gdpr")));
                        setGDPRRequired(true);
                    }
                };
                Object[] arrayList = ((ArrayList) args.get("Zones")).toArray();
                String[] Zones = Arrays.copyOf(arrayList, arrayList.length, String[].class);
                AdColony.configure(ActivityInstance, options, (String) args.get("Id"), Zones);
                AdColony.setRewardListener(listeners);
            } else {
                Log.e("AdColony", "Activity Null");
            }
        } catch (Exception e) {
            Log.e("AdColony", e.getMessage());
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        ActivityInstance = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        ActivityInstance = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {

    }
}
