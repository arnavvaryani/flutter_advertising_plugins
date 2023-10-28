package com.anavrinapps.flutter_mintegral;

import androidx.annotation.NonNull;

import com.mbridge.msdk.out.BannerSize;

class FlutterAdSize {
    @NonNull final BannerSize size;
    final int width;
    final int height;

    FlutterAdSize(int width, int height) {
        this(new BannerSize(BannerSize.DEV_SET_TYPE, width, height));
    }

    FlutterAdSize(@NonNull BannerSize size) {
        this.size = size;
        this.width = size.getWidth();
        this.height = size.getHeight();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        } else if (!(o instanceof FlutterAdSize)) {
            return false;
        }

        final FlutterAdSize that = (FlutterAdSize) o;

        if (width != that.width) {
            return false;
        }
        return height == that.height;
    }

    @Override
    public int hashCode() {
        return size.hashCode();
    }

    public BannerSize getAdSize() {
        return size;
    }
}
