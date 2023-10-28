package com.anavrinapps.flutter_mintegral;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;

import java.util.Locale;

import io.flutter.BuildConfig;
import io.flutter.Log;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/** Displays loaded FlutterAds for an AdInstanceManager */
public class MintegralAdsViewFactory extends PlatformViewFactory {
    @NonNull private final AdInstanceManager manager;

    private static class ErrorTextView implements PlatformView {
        private final TextView textView;

        private ErrorTextView(Context context, String message) {
            textView = new TextView(context);
            textView.setText(message);
            textView.setBackgroundColor(Color.RED);
            textView.setTextColor(Color.YELLOW);
        }

        @Override
        public View getView() {
            return textView;
        }

        @Override
        public void dispose() {}
    }

    public MintegralAdsViewFactory(@NonNull AdInstanceManager manager) {
        super(StandardMessageCodec.INSTANCE);
        this.manager = manager;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        final Integer adId = (Integer) args;
        FlutterAd ad = manager.adForId(adId);
        if (ad == null || ad.getPlatformView() == null) {
            return getErrorView(context, adId);
        }
        return ad.getPlatformView();
    }

    /**
     * Returns an ErrorView with a debug message for debug builds only. Otherwise just returns an
     * empty PlatformView.
     */
    private static PlatformView getErrorView(@NonNull final Context context, int adId) {
        final String message =
                String.format(
                        Locale.getDefault(),
                        "This ad may have not been loaded or has been disposed. "
                                + "Ad with the following id could not be found: %d.",
                        adId);

        if (BuildConfig.DEBUG) {
            return new ErrorTextView(context, message);
        } else {
            Log.e(MintegralAdsViewFactory.class.getSimpleName(), message);
            return new PlatformView() {
                @Override
                public View getView() {
                    return new View(context);
                }

                @Override
                public void dispose() {
                    // Do nothing.
                }
            };
        }
    }
}
