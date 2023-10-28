package com.anavrinapps.flutter_mintegral;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.mbridge.msdk.out.MBridgeIds;

import java.util.Objects;

import io.flutter.plugin.platform.PlatformView;

abstract class FlutterAd {
    protected final int adId;

    FlutterAd(int adId) {
        this.adId = adId;
    }

    /** A {@link FlutterAd} that is overlaid on top of a running application. */
    abstract static class FlutterOverlayAd extends FlutterAd {
        abstract void show();

        FlutterOverlayAd(int adId) {
            super(adId);
        }
    }

    /** A wrapper around {@link MBridgeIds}. */
    static class FlutterMBridgeIds {

        @NonNull private final String placementId;
        @NonNull private final String unitId;
        @NonNull private final String bidToken;

        FlutterMBridgeIds(@NonNull MBridgeIds ids) {
            this.placementId = ids.getPlacementId();
            this.unitId = ids.getUnitId();
            this.bidToken = ids.getBidToken();
        }

        FlutterMBridgeIds(
                @NonNull String placementId,
                @NonNull String unitId,
                @NonNull String bidToken) {
            this.placementId = placementId;
            this.unitId = unitId;
            this.bidToken = bidToken;
        }

        @NonNull
        String getPlacementId() {
            return placementId;
        }

        @NonNull
        String getUnitId() {
            return unitId;
        }

        @NonNull
        String getBidToken() {
            return bidToken;
        }

        @Override
        public boolean equals(@Nullable Object obj) {
            if (obj == this) {
                return true;
            } else if (!(obj instanceof FlutterMBridgeIds)) {
                return false;
            }

            FlutterMBridgeIds that = (FlutterMBridgeIds) obj;
            return Objects.equals(placementId, that.placementId)
                    && Objects.equals(unitId, that.unitId)
                    && Objects.equals(bidToken, that.bidToken);
        }

        @Override
        public int hashCode() {
            return Objects.hash(placementId, unitId);
        }
    }

    abstract void onPause();

    abstract void onResume();

    abstract void load();

    /**
     * Gets the PlatformView for the ad. Default behavior is to return null. Should be overridden by
     * ads with platform views, such as banner and native ads.
     */
    @Nullable
    PlatformView getPlatformView() {
        return null;
    }

    /**
     * Invoked when dispose() is called on the corresponding Flutter ad object. This perform any
     * necessary cleanup.
     */
    abstract void dispose();
}
