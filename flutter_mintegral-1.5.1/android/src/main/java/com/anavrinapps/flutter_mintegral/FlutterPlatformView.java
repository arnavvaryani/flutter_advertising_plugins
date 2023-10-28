package com.anavrinapps.flutter_mintegral;

import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.platform.PlatformView;

/** A simple PlatformView that wraps a View and sets its reference to null on dispose(). */
class FlutterPlatformView implements PlatformView {

    @Nullable private View view;

    FlutterPlatformView(@NonNull View view) {
        this.view = view;
    }

    @Nullable
    @Override
    public View getView() {
        return view;
    }

    @Override
    public void dispose() {
        this.view = null;
    }
}
