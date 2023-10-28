package com.anavrinapps.flutter_mintegral;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.mbridge.msdk.MBridgeSDK;
import com.mbridge.msdk.out.MBridgeSDKFactory;
import com.mbridge.msdk.out.SDKInitStatusListener;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.StandardMethodCodec;

/** FlutterMintegralPlugin */
public class FlutterMintegralPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private static final String TAG = "MintegralPlugin";

  private static <T> T requireNonNull(T obj) {
    if (obj == null) {
      throw new IllegalArgumentException();
    }
    return obj;
  }

  private static <T> Boolean requireBoolean(T obj) {
    return obj instanceof Boolean ? (Boolean) obj : Boolean.FALSE;
  }

  // This is always null when not using v2 embedding.
  @Nullable private FlutterPluginBinding pluginBinding;
  @Nullable private AdInstanceManager instanceManager;
  @Nullable private AdMessageCodec adMessageCodec;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    pluginBinding = binding;
    adMessageCodec = new AdMessageCodec(binding.getApplicationContext());
    final MethodChannel channel = new MethodChannel(
            binding.getBinaryMessenger(),
            "flutter_mintegral",
            new StandardMethodCodec(adMessageCodec));
    channel.setMethodCallHandler(this);
    instanceManager = new AdInstanceManager(channel);
    binding.getPlatformViewRegistry()
            .registerViewFactory(
                    "flutter_mintegral/ad_widget",
                    new MintegralAdsViewFactory(instanceManager));
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    if (instanceManager != null) {
      instanceManager.setActivity(binding.getActivity());
    }
    if (adMessageCodec != null) {
      adMessageCodec.setContext(binding.getActivity());
    }
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    // Use the application context
    if (adMessageCodec != null && pluginBinding != null) {
      adMessageCodec.setContext(pluginBinding.getApplicationContext());
    }
    if (instanceManager != null) {
      instanceManager.setActivity(null);
    }
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    if (instanceManager != null) {
      instanceManager.setActivity(binding.getActivity());
    }
    if (adMessageCodec != null) {
      adMessageCodec.setContext(binding.getActivity());
    }
  }

  @Override
  public void onDetachedFromActivity() {
    if (adMessageCodec != null && pluginBinding != null) {
      adMessageCodec.setContext(pluginBinding.getApplicationContext());
    }
    if (instanceManager != null) {
      instanceManager.setActivity(null);
    }
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (instanceManager == null || pluginBinding == null) {
      Log.e(TAG, "method call received before instanceManager initialized: " + call.method);
      return;
    }
    // Use activity as context if available.
    Context context =
            (instanceManager.getActivity() != null)
                    ? instanceManager.getActivity()
                    : pluginBinding.getApplicationContext();

    switch (call.method) {
      case "_init":
        // Internal init. This is necessary to cleanup state on hot restart.
        instanceManager.disposeAllAds();
        result.success(null);
        break;
      case "initialize":
        final String appId = requireNonNull(call.argument("appId"));
        final String appKey = requireNonNull(call.argument("appKey"));
        MBridgeSDK sdk = MBridgeSDKFactory.getMBridgeSDK();
        Map <String, String> map = sdk.getMBConfigurationMap(appId, appKey);
        sdk.init(map, context, new FlutterInitializationListener(result));
        break;
      case "loadBannerAd":
        final FlutterBannerAd bannerAd =
                new FlutterBannerAd(
                        requireNonNull(call.<Integer>argument("adId")),
                        instanceManager,
                        requireNonNull(call.argument("placementId")),
                        requireNonNull(call.argument("unitId")),
                        requireNonNull(call.argument("size")));
        instanceManager.trackAd(bannerAd, requireNonNull(call.<Integer>argument("adId")));
        bannerAd.load();
        result.success(null);
        break;
      case "loadSplashAd":
        final FlutterSplashAd splashAd = new FlutterSplashAd(
                requireNonNull(call.<Integer>argument("adId")),
                requireNonNull(instanceManager),
                requireNonNull(call.argument("placementId")),
                requireNonNull(call.argument("unitId"))
        );
        instanceManager.trackAd(splashAd, requireNonNull(call.<Integer>argument("adId")));
        splashAd.load();
        result.success(null);
        break;
      case "loadInterstitialAd":
        final FlutterInterstitialAd interstitial = new FlutterInterstitialAd(
                requireNonNull(call.<Integer>argument("adId")),
                requireNonNull(instanceManager),
                requireNonNull(call.argument("placementId")),
                requireNonNull(call.argument("unitId"))
        );
        instanceManager.trackAd(interstitial, requireNonNull(call.<Integer>argument("adId")));
        interstitial.load();
        result.success(null);
        break;
      case "loadRewardVideoAd":
        final boolean isRewardPlus = requireBoolean(call.argument("isRewardPlus"));
        final FlutterRewardVideoAd rewardVideoAd = new FlutterRewardVideoAd(
                requireNonNull(call.<Integer>argument("adId")),
                requireNonNull(instanceManager),
                requireNonNull(call.argument("placementId")),
                requireNonNull(call.argument("unitId"))
        );
        instanceManager.trackAd(rewardVideoAd, requireNonNull(call.<Integer>argument("adId")));
        rewardVideoAd.setRewardPlus(isRewardPlus);
        rewardVideoAd.load();
        result.success(null);
        break;
      case "disposeAd":
        instanceManager.disposeAd(requireNonNull(call.<Integer>argument("adId")));
        result.success(null);
        break;
      case "showAdWithoutView":
        final boolean adShown = instanceManager.showAdWithId(
                requireNonNull(call.<Integer>argument("adId")));
        if (!adShown) {
          result.error("AdShowError", "Ad failed to show.", null);
          break;
        }
        result.success(null);
        break;
      case "onPause": {
        FlutterAd ad = instanceManager.adForId(
                requireNonNull(call.<Integer>argument("adId")));
        if (ad != null) {
          ad.onPause();
        }
        result.success(null);
        break;
      }
      case "onResume": {
        FlutterAd ad = instanceManager.adForId(
                requireNonNull(call.<Integer>argument("adId")));
        if (ad != null) {
          ad.onResume();
        }
        result.success(null);
        break;
      }
      case "getAdSize": {
        FlutterAd ad = instanceManager.adForId(
                requireNonNull(call.<Integer>argument("adId")));
        if (ad == null) {
          // This was called on a dart ad container that hasn't been loaded yet.
          result.success(null);
        } else if (ad instanceof FlutterBannerAd) {
          result.success(((FlutterBannerAd) ad).getAdSize());
        } else {
          result.error(
                  "unexpected_ad_type",
                  "Unexpected ad type for getAdSize: " + ad,
                  null);
        }
        break;
      }
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  /** An {@link SDKInitStatusListener} that invokes result.success() at most once. */
  private static final class FlutterInitializationListener implements SDKInitStatusListener {

    private final Result result;
    private boolean isInitializationCompleted;

    private FlutterInitializationListener(@NonNull final Result result) {
      this.result = result;
      isInitializationCompleted = false;
    }

    @Override
    public void onInitSuccess() {
      // Make sure not to invoke this more than once, since Dart will throw an exception if success
      // is invoked more than once. See b/193418432.
      if (isInitializationCompleted) {
        return;
      }
      Map<String, Object> arguments = new HashMap<>();
      arguments.put("initializationStatus", true);
      result.success(arguments);
      isInitializationCompleted = true;
    }

    @Override
    public void onInitFail(String errorMsg) {
      // Make sure not to invoke this more than once, since Dart will throw an exception if success
      // is invoked more than once. See b/193418432.
      if (isInitializationCompleted) {
        return;
      }
      Map<String, Object> arguments = new HashMap<>();
      arguments.put("initializationStatus", false);
      arguments.put("error", errorMsg);
      result.success(arguments);
      isInitializationCompleted = true;
    }
  }
}
