package com.mopub_flutter;

import androidx.annotation.NonNull;

import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubInterstitial;

import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

class MopubInterstitialAdPlugin implements MethodChannel.MethodCallHandler {

    private HashMap<String, MoPubInterstitial> ads = new HashMap<>();

    private PluginRegistry.Registrar registrar;

    MopubInterstitialAdPlugin(PluginRegistry.Registrar registrar) {
        this.registrar = registrar;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        final HashMap args = (HashMap) call.arguments;
        final String adUnitId = (String) args.get("adUnitId");
        MoPubInterstitial ad;

        switch (call.method) {
            case MopubConstants.SHOW_INTERSTITIAL_METHOD:
                ad = ads.get(adUnitId);
                if (ad == null || !ad.isReady()) {
                    result.success(null);
                    return;
                }
                ad.show();
                result.success(null);
                break;
            case MopubConstants.LOAD_INTERSTITIAL_METHOD:
                if (registrar.activity() == null)
                    return;
                if (registrar.activity().isFinishing() || registrar.activity().isDestroyed())
                    return;
                if (ads.get(adUnitId) == null) {
                    ads.put(adUnitId, new MoPubInterstitial(registrar.activity(), adUnitId));
                }
                ad = ads.get(adUnitId);
                if (ad != null) {
                    final MethodChannel adChannel = new MethodChannel(registrar.messenger(),
                            MopubConstants.INTERSTITIAL_AD_CHANNEL + "_" + adUnitId);
                    ad.setInterstitialAdListener(createListener(adChannel));
                    if (!ad.isReady()) {
                        ad.load();
                    }
                }
                result.success(null);
                break;
            case MopubConstants.HAS_INTERSTITIAL_METHOD:
                ad = ads.get(adUnitId);
                if (ad != null) {
                    boolean isReady = ad.isReady();
                    result.success(isReady);
                    return;
                }
                result.success(false);
                break;
            case MopubConstants.DESTROY_INTERSTITIAL_METHOD:
                ad = ads.get(adUnitId);
                if (ad == null) {
                    return;
                } else {
                    ad.setInterstitialAdListener(null);
                    ad.destroy();
                    ads.remove(adUnitId);
                }
                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }

    private MoPubInterstitial.InterstitialAdListener createListener(final MethodChannel channel) {
        return new MoPubInterstitial.InterstitialAdListener() {
            @Override
            public void onInterstitialLoaded(MoPubInterstitial ad) {
                HashMap<String, Object> args = new HashMap<>();
                args.put("keywords", ad.getKeywords());

                channel.invokeMethod(MopubConstants.LOADED_METHOD, args);
            }

            @Override
            public void onInterstitialFailed(MoPubInterstitial ad, MoPubErrorCode errorCode) {
                HashMap<String, Object> args = new HashMap<>();
                args.put("keywords", ad.getKeywords());
                args.put("errorCode", errorCode.toString());

                channel.invokeMethod(MopubConstants.ERROR_METHOD, args);
            }

            @Override
            public void onInterstitialShown(MoPubInterstitial ad) {
                HashMap<String, Object> args = new HashMap<>();
                args.put("keywords", ad.getKeywords());

                channel.invokeMethod(MopubConstants.DISPLAYED_METHOD, args);
            }

            @Override
            public void onInterstitialClicked(MoPubInterstitial ad) {
                HashMap<String, Object> args = new HashMap<>();
                args.put("keywords", ad.getKeywords());

                channel.invokeMethod(MopubConstants.CLICKED_METHOD, args);
            }

            @Override
            public void onInterstitialDismissed(MoPubInterstitial ad) {
                HashMap<String, Object> args = new HashMap<>();
                args.put("keywords", ad.getKeywords());

                channel.invokeMethod(MopubConstants.DISMISSED_METHOD, args);
            }
        };
    }
}
