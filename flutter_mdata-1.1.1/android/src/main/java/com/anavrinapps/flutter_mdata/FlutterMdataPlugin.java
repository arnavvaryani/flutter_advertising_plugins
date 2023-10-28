package com.anavrinapps.flutter_mdata;

import androidx.annotation.NonNull;
import android.app.Activity;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.BinaryMessenger;

import io.monedata.*;
import kotlin.Unit;

import com.ogury.sdk.OguryConfiguration;
import com.ogury.sdk.Ogury;
import com.ogury.cm.OguryConsentListener;
import com.ogury.cm.OguryChoiceManager;
import com.ogury.core.OguryError;

public class FlutterMdataPlugin implements FlutterPlugin, MethodCallHandler,ActivityAware {
  private MethodChannel channel;
  static Activity activity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "monedatasdk");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("init")) {
      String api_token = null;
      String ogury_token = null;
  if(call.argument("api_token")!=null) {
    api_token = call.argument("api_token");
    ogury_token = call.argument("oguryToken");
  }else{
    result.error("no_api_token", "a null api token was provided", null);
    return;
  }
  OguryConfiguration.Builder oguryConfigurationBuilder = new OguryConfiguration.Builder(activity.getApplicationContext(), ogury_token);
  Ogury.start(oguryConfigurationBuilder.build());
      Monedata.initialize(activity.getApplicationContext(), api_token, true);
      Monedata.waitForInitialization(isReady -> {
        try {
          FlutterMdataPlugin.activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("isReady",isReady);
                    }
                });
            } catch (Exception e) {
                Log.e("Monedata", "Error " + e.toString());
         }
        return Unit.INSTANCE;
    });
    } else if(call.method.equals("editConsent")) {
      OguryChoiceManager.edit(activity, new OguryConsentListener() {
        @Override
        public void onComplete(OguryChoiceManager.Answer answer) {
            String tcString = OguryChoiceManager.TcfV2.getIabString();
            Monedata.Consent.setIabString(activity, tcString);
        }
        @Override
        public void onError(OguryError error) {
        }
    }); 
    } else if(call.method.equals("start")) {
      Monedata.start(activity.getApplicationContext());
    } else if(call.method.equals("stop")) {
      Monedata.stop(activity.getApplicationContext());
    } else if (call.method.equals("consent")) {
      OguryChoiceManager.ask(activity, new OguryConsentListener() {
        @Override
        public void onComplete(OguryChoiceManager.Answer answer) {
            String tcString = OguryChoiceManager.TcfV2.getIabString();
            Monedata.Consent.setIabString(activity, tcString);
        }
        @Override
        public void onError(OguryError error) {
        }
    }); 
      Monedata.Consent.addListener(consent -> {
        try {
          FlutterMdataPlugin.activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("consentListener",consent);
                    }
                });
            } catch (Exception e) {
                Log.e("Monedata", "Error " + e.toString());
         }
        return Unit.INSTANCE;
    });
    } 
    else {
      result.notImplemented();
    }
  }

 @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding activityPluginBinding) {
    activity = activityPluginBinding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding activityPluginBinding) {
  }

  @Override
  public void onDetachedFromActivity() {
  }
}
