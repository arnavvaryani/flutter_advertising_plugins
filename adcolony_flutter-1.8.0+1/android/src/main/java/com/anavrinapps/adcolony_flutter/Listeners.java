package com.anavrinapps.adcolony_flutter;

import android.util.Log;

import com.adcolony.sdk.AdColonyInterstitial;
import com.adcolony.sdk.AdColonyInterstitialListener;
import com.adcolony.sdk.AdColonyReward;
import com.adcolony.sdk.AdColonyRewardListener;
import com.adcolony.sdk.AdColonyZone;

public class Listeners extends AdColonyInterstitialListener implements AdColonyRewardListener {

    @Override
    public void onRequestFilled(AdColonyInterstitial adColonyInterstitial) {
        AdcolonyFlutterPlugin.Ad = adColonyInterstitial;
        Log.i("AdColony", "onRequestFilled");
        AdcolonyFlutterPlugin.getInstance().onMethodCallHandler("onRequestFilled", 0);
    }

    @Override
    public void onRequestNotFilled(AdColonyZone adColonyZone) {
        AdcolonyFlutterPlugin.Ad = null;
        Log.i("AdColony", "onRequestNotFilled");
        AdcolonyFlutterPlugin.getInstance().onMethodCallHandler("onRequestNotFilled", 0);
    }

    @Override
    public void onOpened(AdColonyInterstitial adColonyInterstitial) {
        Log.i("AdColony", "onOpened");
        AdcolonyFlutterPlugin.getInstance().onMethodCallHandler("onOpened", 0);
    }

    @Override
    public void onClosed(AdColonyInterstitial adColonyInterstitial) {
        AdcolonyFlutterPlugin.Ad = null;
        Log.i("AdColony", "onClosed");
        AdcolonyFlutterPlugin.getInstance().onMethodCallHandler("onClosed", 0);
    }

    @Override
    public void onIAPEvent(AdColonyInterstitial adColonyInterstitial, String productId, int engagementType) {
        Log.i("AdColony", "onIAPEvent");
        AdcolonyFlutterPlugin.getInstance().onMethodCallHandler("onIAPEvent", 0);
    }

    @Override
    public void onExpiring(AdColonyInterstitial adColonyInterstitial) {
        AdcolonyFlutterPlugin.Ad = null;
        Log.i("AdColony", "onExpiring");
        AdcolonyFlutterPlugin.getInstance().onMethodCallHandler("onExpiring", 0);
    }

    @Override
    public void onLeftApplication(AdColonyInterstitial adColonyInterstitial) {
        Log.i("AdColony", "onLeftApplication");
        AdcolonyFlutterPlugin.getInstance().onMethodCallHandler("onLeftApplication", 0);
    }

    @Override
    public void onClicked(AdColonyInterstitial adColonyInterstitial) {
        Log.i("AdColony", "onClicked");
        AdcolonyFlutterPlugin.getInstance().onMethodCallHandler("onClicked", 0);
    }

    @Override
    public void onReward(AdColonyReward adColonyReward) {
        AdcolonyFlutterPlugin.Ad = null;
        Log.i("AdColony", "onReward");
        AdcolonyFlutterPlugin.getInstance().onMethodCallHandler("onReward", adColonyReward.getRewardAmount());
    }
}
