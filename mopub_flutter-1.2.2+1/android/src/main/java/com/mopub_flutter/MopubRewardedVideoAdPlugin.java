package com.mopub_flutter;

import androidx.annotation.NonNull;

import com.mopub.common.MoPubReward;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubRewardedVideoListener;
import com.mopub.mobileads.MoPubRewardedVideos;

import java.util.HashMap;
import java.util.Set;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

class MopubRewardedVideoAdPlugin implements MethodChannel.MethodCallHandler {

    private PluginRegistry.Registrar registrar;

    MopubRewardedVideoAdPlugin(PluginRegistry.Registrar registrar) {
        this.registrar = registrar;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        final HashMap args = (HashMap) call.arguments;
        final String adUnitId = (String) args.get("adUnitId");

        switch (call.method) {
            case MopubConstants.SHOW_REWARDED_VIDEO_METHOD:

                if (MoPubRewardedVideos.hasRewardedVideo(adUnitId))
                    MoPubRewardedVideos.showRewardedVideo(adUnitId);

                result.success(null);
                break;
            case MopubConstants.LOAD_REWARDED_VIDEO_METHOD:

                final MethodChannel adChannel = new MethodChannel(registrar.messenger(),
                        MopubConstants.REWARDED_VIDEO_CHANNEL + "_" + adUnitId);
                MoPubRewardedVideos.setRewardedVideoListener(new RewardedVideoListener(adChannel));
                if (MoPubRewardedVideos.hasRewardedVideo(adUnitId))
                    return;
                MoPubRewardedVideos.loadRewardedVideo(adUnitId);

                result.success(null);
                break;
            case MopubConstants.HAS_REWARDED_VIDEO_METHOD:
                boolean hasAd = MoPubRewardedVideos.hasRewardedVideo(adUnitId);
                result.success(hasAd);
                break;
            default:
                result.notImplemented();
        }
    }

    class RewardedVideoListener implements MoPubRewardedVideoListener {

        MethodChannel channel;
        boolean didReceiveReward = false;
        int rewardAmount = 0;

        RewardedVideoListener(MethodChannel channel) {
            this.channel = channel;
        }

        @Override
        public void onRewardedVideoLoadSuccess(@NonNull String adUnitId) {
            HashMap<String, Object> args = new HashMap<>();
            args.put("adUnitId", adUnitId);

            channel.invokeMethod(MopubConstants.LOADED_METHOD, args);
        }

        @Override
        public void onRewardedVideoLoadFailure(@NonNull String adUnitId, @NonNull MoPubErrorCode errorCode) {
            HashMap<String, Object> args = new HashMap<>();
            args.put("adUnitId", adUnitId);
            args.put("errorCode", errorCode.toString());

            channel.invokeMethod(MopubConstants.ERROR_METHOD, args);
        }

        @Override
        public void onRewardedVideoStarted(@NonNull String adUnitId) {
            HashMap<String, Object> args = new HashMap<>();
            args.put("adUnitId", adUnitId);

            channel.invokeMethod(MopubConstants.DISPLAYED_METHOD, args);
        }

        @Override
        public void onRewardedVideoPlaybackError(@NonNull String adUnitId, @NonNull MoPubErrorCode errorCode) {
            HashMap<String, Object> args = new HashMap<>();
            args.put("adUnitId", adUnitId);
            args.put("errorCode", errorCode.toString());

            channel.invokeMethod(MopubConstants.REWARDED_PLAYBACK_ERROR, args);
        }

        @Override
        public void onRewardedVideoClicked(@NonNull String adUnitId) {
            HashMap<String, Object> args = new HashMap<>();
            args.put("adUnitId", adUnitId);

            channel.invokeMethod(MopubConstants.CLICKED_METHOD, args);
        }

        @Override
        public void onRewardedVideoClosed(@NonNull String adUnitId) {
            HashMap<String, Object> args = new HashMap<>();
            args.put("adUnitId", adUnitId);

            channel.invokeMethod(MopubConstants.DISMISSED_METHOD, args);
            if (didReceiveReward) {
                didReceiveReward = false;
                final HashMap<String, Object> rewardArgs = new HashMap<>();
                rewardArgs.put("reward", rewardAmount);
                channel.invokeMethod(MopubConstants.GRANT_REWARD, rewardArgs);
            }

        }

        @Override
        public void onRewardedVideoCompleted(@NonNull Set<String> adUnitIds, @NonNull MoPubReward reward) {
            didReceiveReward = true;
            rewardAmount = reward.getAmount();
        }
    }
}
