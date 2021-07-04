package com.anavrinapps.flutter_mintegral.activity;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Toast;

import androidx.annotation.DrawableRes;

import com.anavrinapps.flutter_mintegral.R;
import com.mbridge.msdk.MBridgeConstans;
import com.mbridge.msdk.MBridgeSDK;
import com.mbridge.msdk.out.MBSplashHandler;
import com.mbridge.msdk.out.MBSplashLoadListener;
import com.mbridge.msdk.out.MBSplashShowListener;
import com.mbridge.msdk.out.MBridgeSDKFactory;
import com.mbridge.msdk.out.SDKInitStatusListener;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.Log;

public abstract class SplashAdAbstractActivity extends Activity {
    private static final String TAG = "SplashAbstractActivity";
    private MBSplashHandler mtgSplashHandler;
    private String adUnitId;
    private String appId;
    private String appKey;
    private String placementId;

    private boolean isFlutterStart = false;

    private View adContainer;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.splash_ad);
        adContainer = this.findViewById(R.id.ad_container);

        appId = getIntent().getStringExtra("appId");
        appKey = getIntent().getStringExtra("appKey");
        adUnitId = getIntent().getStringExtra("adUnitId");
        placementId = getIntent().getStringExtra("placementId");

        int launchBackgroundId = getIntent().getIntExtra("launchBackgroundId", -1);
        if (launchBackgroundId == -1 && getLaunchBackground() != null)
            launchBackgroundId = getLaunchBackground();
        if (launchBackgroundId != -1)
            adContainer.setBackground(getResources().getDrawable(launchBackgroundId));
        if (TextUtils.isEmpty(appId)) {
            appId = getAppId();
        } else {
            isFlutterStart = true;
        }
        if (TextUtils.isEmpty(placementId)) {
            placementId = getAdPlacementId();
        }
        if (TextUtils.isEmpty(appKey)) {
            appKey = getAppKey();
        }
        if (TextUtils.isEmpty(adUnitId)) {
            adUnitId = getAdUnitId();
        }
        if (isFlutterStart) {
            fetchSplashAD();
            return;
        }
            initSdk(appId, appKey);
    }

    private void initSdk(String appId, String appKey) {
        MBridgeSDK sdk = MBridgeSDKFactory.getMBridgeSDK();
        Map<String, String> map = sdk.getMBConfigurationMap(appId, appKey);
        sdk.setConsentStatus(this, isProtectGDPR() ? MBridgeConstans.IS_SWITCH_OFF : MBridgeConstans.IS_SWITCH_ON);

        sdk.init(map, this, new SDKInitStatusListener() {
            @Override
            public void onInitSuccess() {
                Log.e(TAG, "onInitSuccess");
                fetchSplashAD();
            }

            @Override
            public void onInitFail() {
                Log.e(TAG, "onInitFail");
            }
        });
        sdk.setDoNotTrackStatus(isProtectCCPA());
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
            initSdk(appId, appKey);
    }

    private void fetchSplashAD() {
        if (TextUtils.isEmpty(placementId)) {
            Log.e(TAG, "error: placementId is null");
            finish();
            return;
        }
        mtgSplashHandler = new MBSplashHandler(placementId, adUnitId);
        mtgSplashHandler.setLoadTimeOut(10);

        mtgSplashHandler.setSplashLoadListener(new MBSplashLoadListener() {
            @Override
            public void onLoadSuccessed(int reqType) {
                Log.e(TAG, "onLoadSuccessed" + reqType);
            }

            @Override
            public void onLoadFailed(String msg, int reqType) {
                Log.e(TAG, "onLoadFailed" + msg + reqType);
                finish();
            }
        });

        mtgSplashHandler.setSplashShowListener(new MBSplashShowListener() {
            @Override
            public void onShowSuccessed() {
                Log.e(TAG, "onShowSuccessed");
            }

            @Override
            public void onShowFailed(String msg) {
                Log.e(TAG, "onShowFailed" + msg);
                finish();
            }

            @Override
            public void onAdClicked() {
                Log.e(TAG, "onAdClicked");
            }

            @Override
            public void onDismiss(int type) {
                Log.e(TAG, "onDismiss" + type);
                finish();
            }

            @Override
            public void onAdTick(long millisUntilFinished) {
                Log.e(TAG, "onAdTick" + millisUntilFinished);
            }
        });

        mtgSplashHandler.loadAndShow((ViewGroup) adContainer);
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (mtgSplashHandler != null) {
            mtgSplashHandler.onResume();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (mtgSplashHandler != null) {
            mtgSplashHandler.onPause();
        }
    }

    @Override
    protected void onDestroy() {
        if (mtgSplashHandler != null) {
            mtgSplashHandler.onDestroy();
        }
        super.onDestroy();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK || keyCode == KeyEvent.KEYCODE_HOME) {
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    protected abstract String getAppId();

    protected abstract String getAppKey();

    protected abstract String getAdUnitId();

    protected abstract String getAdPlacementId();

    protected abstract boolean isProtectGDPR();

    protected abstract boolean isProtectCCPA();

    protected abstract @DrawableRes
    Integer getLaunchBackground();
}
