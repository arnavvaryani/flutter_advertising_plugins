package com.anavrinapps.adcolony_flutter;

import android.util.Log;

import com.adcolony.sdk.AdColonyInterstitial;
import com.adcolony.sdk.AdColonyInterstitialListener;
import com.adcolony.sdk.AdColonyReward;
import com.adcolony.sdk.AdColonyRewardListener;
import com.adcolony.sdk.AdColonyZone;

public class Listeners extends AdColonyInterstitialListener implements AdColonyRewardListener {


    @Override
    public void onRequestFilled(AdColonyInterstitial adColonyInterstitial){
        AdcolonyFlutterPlugin.Ad = adColonyInterstitial;
        Log.i("AdColony", "onRequestFilled");
        AdcolonyFlutterPlugin.getInstance().OnMethodCallHandler("onRequestFilled",0);
    }

    public void onRequestNotFilled(AdColonyZone adColonyInterstitial) {
        AdcolonyFlutterPlugin.Ad = null;
        Log.i("AdColony", "onRequestNotFilled");
        AdcolonyFlutterPlugin.getInstance().OnMethodCallHandler("onRequestNotFilled",0);
    }

    public void onOpened(AdColonyInterstitial ad) {
        Log.i("AdColony", "onOpened");
        AdcolonyFlutterPlugin.getInstance().OnMethodCallHandler("onOpened",0);
    }

    public void onClosed(AdColonyInterstitial ad) {
        AdcolonyFlutterPlugin.Ad = null;
        Log.i("AdColony", "onClosed");
        AdcolonyFlutterPlugin.getInstance().OnMethodCallHandler("onClosed",0);
    }

    public void onIAPEvent(AdColonyInterstitial ad, String product_id, int engagement_type) {
        Log.i("AdColony", "onIAPEvent");
        AdcolonyFlutterPlugin.getInstance().OnMethodCallHandler("onIAPEvent",0);
    }

    public void onExpiring(AdColonyInterstitial ad) {
        AdcolonyFlutterPlugin.Ad = null;
        Log.i("AdColony", "onExpiring");
        AdcolonyFlutterPlugin.getInstance().OnMethodCallHandler("onExpiring",0);
    }

    public void onLeftApplication(AdColonyInterstitial ad) {
        Log.i("AdColony", "onLeftApplication");
        AdcolonyFlutterPlugin.getInstance().OnMethodCallHandler("onLeftApplication",0);
    }

    public void onClicked(AdColonyInterstitial ad) {
        Log.i("AdColony", "onClicked");
        AdcolonyFlutterPlugin.getInstance().OnMethodCallHandler("onClicked",0);
    }

    @Override
    public void onReward(AdColonyReward adColonyReward) {
        AdcolonyFlutterPlugin.Ad = null;
        Log.i("AdColony", "onReward");
        AdcolonyFlutterPlugin.getInstance().OnMethodCallHandler("onReward",adColonyReward.getRewardAmount());
    }

}
