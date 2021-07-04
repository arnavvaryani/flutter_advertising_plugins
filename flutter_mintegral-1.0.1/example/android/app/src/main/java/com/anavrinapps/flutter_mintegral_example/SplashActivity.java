package com.anavrinapps.flutter_mintegral_example;


import com.anavrinapps.flutter_mintegral.activity.SplashAdAbstractActivity;

public class SplashActivity extends SplashAdAbstractActivity {
    @Override
    protected String getAppId() {
        return "118690";
    }

    @Override
    protected String getAppKey() {
        return "7c22942b749fe6a6e361b675e96b3ee9";
    }

    @Override
    protected String getAdUnitId() {
        return "209547";
    }

    @Override
    protected String getAdPlacementId() {
        return "173349";
    }

    @Override
    protected boolean isProtectGDPR() {
        return false;
    }

    @Override
    protected boolean isProtectCCPA() {
        return false;
    }

    @Override
    protected Integer getLaunchBackground() {
        return null;
    }
}
