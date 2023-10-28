package com.anavrinapps.flutter_mintegral;

import android.content.Context;

import androidx.annotation.NonNull;

import com.anavrinapps.flutter_mintegral.FlutterAd.FlutterMBridgeIds;
import com.anavrinapps.flutter_mintegral.FlutterRewardVideoAd.FlutterRewardInfo;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;

import io.flutter.plugin.common.StandardMessageCodec;

/**
 * Encodes and decodes values by reading from a ByteBuffer and writing to a ByteArrayOutputStream.
 */
public class AdMessageCodec extends StandardMessageCodec {
    // The type values below must be consistent for each platform.
    private static final byte VALUE_MBRIDGE_IDS = (byte) 128;
    private static final byte VALUE_REWARD_INFO = (byte) 129;
    private static final byte VALUE_AD_SIZE = (byte) 130;

    @NonNull Context context;

    AdMessageCodec(@NonNull Context context) {
        this.context = context;
    }

    void setContext(@NonNull Context context) {
        this.context = context;
    }

    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value) {
        if (value instanceof FlutterMBridgeIds) {
            stream.write(VALUE_MBRIDGE_IDS);
            final FlutterMBridgeIds mBridgeIds = (FlutterMBridgeIds) value;
            writeValue(stream, mBridgeIds.getPlacementId());
            writeValue(stream, mBridgeIds.getUnitId());
            writeValue(stream, mBridgeIds.getBidToken());
        } else if (value instanceof FlutterRewardInfo) {
            stream.write(VALUE_REWARD_INFO);
            final FlutterRewardInfo info = (FlutterRewardInfo) value;
            writeValue(stream, info.isCompleteView);
            writeValue(stream, info.rewardName);
            writeValue(stream, info.rewardAmount);
            writeValue(stream, info.rewardAlertStatus);
        } else if (value instanceof FlutterAdSize) {
            stream.write(VALUE_AD_SIZE);
            final FlutterAdSize size = (FlutterAdSize) value;
            writeValue(stream, size.width);
            writeValue(stream, size.height);
        } else {
            super.writeValue(stream, value);
        }
    }

    @Override
    protected Object readValueOfType(byte type, ByteBuffer buffer) {
        switch (type) {
            case VALUE_MBRIDGE_IDS:
                return new FlutterMBridgeIds(
                        (String) readValueOfType(buffer.get(), buffer),
                        (String) readValueOfType(buffer.get(), buffer),
                        (String) readValueOfType(buffer.get(), buffer)
                );
            case VALUE_REWARD_INFO:
                return new FlutterRewardInfo(
                        (Boolean) readValueOfType(buffer.get(), buffer),
                        (String) readValueOfType(buffer.get(), buffer),
                        (String) readValueOfType(buffer.get(), buffer),
                        (Integer) readValueOfType(buffer.get(), buffer)
                );
            case VALUE_AD_SIZE:
                return new FlutterAdSize(
                        (Integer) readValueOfType(buffer.get(), buffer),
                        (Integer) readValueOfType(buffer.get(), buffer)
                );
            default:
                return super.readValueOfType(type, buffer);
        }
    }
}
