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
    this.OnAttachedToEngine(flutterPluginBinding.getBinaryMessenger());
    this.RegistrarBanner(flutterPluginBinding.getPlatformViewRegistry());
  }

  public static void registerWith(Registrar registrar) {
    if(ActivityInstance == null) ActivityInstance = registrar.activity();
    if (Instance == null) Instance = new AdcolonyFlutterPlugin();
    Instance.OnAttachedToEngine(registrar.messenger());
    Instance.RegistrarBanner(registrar.platformViewRegistry());
  }

  private void RegistrarBanner(PlatformViewRegistry registry) {
    registry.registerViewFactory("/Banner", new BannerFactory());
}
private void OnAttachedToEngine(BinaryMessenger messenger) {
  if (AdcolonyFlutterPlugin.Instance == null)
      AdcolonyFlutterPlugin.Instance = new AdcolonyFlutterPlugin();
  if (AdcolonyFlutterPlugin.Channel != null)
      return;
  AdcolonyFlutterPlugin.Channel = new MethodChannel(messenger, "AdColony");
  AdcolonyFlutterPlugin.Channel.setMethodCallHandler(this);
}
void OnMethodCallHandler(final String method, final int reward) {
  try {
      AdcolonyFlutterPlugin.ActivityInstance.runOnUiThread(new Runnable() {
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
              this.InitSdk((HashMap) call.arguments);
              result.success(Boolean.TRUE);
              break;
          case "Request":
              AdColony.requestInterstitial((String) call.argument("Id"), AdcolonyFlutterPlugin.listeners);
              result.success(Boolean.TRUE);
              break;
          case "Show":
              if (AdcolonyFlutterPlugin.Ad != null)
                  AdcolonyFlutterPlugin.Ad.show();
                  result.success(Boolean.TRUE);
              break;
          case "isLoaded":
          if (AdcolonyFlutterPlugin.Ad != null){
            result.success(Boolean.TRUE);
          }else{
            result.success(Boolean.FALSE);
          }
           break;
      }
  } catch (Exception e) {
      Log.e("AdColony", "Error " + e.toString());
  }
  }

 
  @RequiresApi(api = Build.VERSION_CODES.KITKAT)
  private void InitSdk(final HashMap args) {
      try {
          if (AdcolonyFlutterPlugin.ActivityInstance != null) {
              AdColonyAppOptions options = new AdColonyAppOptions() {
                  {
                      setKeepScreenOn(true);
                      setGDPRConsentString((String) Objects.requireNonNull(args.get("Gdpr")));
                      setGDPRRequired(true);
                  }
              };
              Object[] arrayList = ((ArrayList) args.get("Zones")).toArray();
              String[] Zones = Arrays.copyOf(arrayList, arrayList.length, String[].class);
              AdColony.configure(AdcolonyFlutterPlugin.ActivityInstance, options, (String) args.get("Id"), Zones);
              AdColony.setRewardListener(AdcolonyFlutterPlugin.listeners);
          } else {
              Log.e("AdColony", "Activity Nulll");
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
      AdcolonyFlutterPlugin.ActivityInstance = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
      AdcolonyFlutterPlugin.ActivityInstance = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {

  }
}
