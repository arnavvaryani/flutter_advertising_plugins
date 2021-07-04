package com.anavrinapps.flutter_inbrain;

import androidx.annotation.NonNull;
import android.app.Activity;
import android.graphics.Color;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.Log;

import com.inbrain.sdk.InBrain;
import com.inbrain.sdk.callback.GetNativeSurveysCallback;
import com.inbrain.sdk.callback.GetRewardsCallback;
import com.inbrain.sdk.callback.InBrainCallback;
import com.inbrain.sdk.callback.StartSurveysCallback;
import com.inbrain.sdk.callback.SurveysAvailableCallback;
import com.inbrain.sdk.config.StatusBarConfig;
import com.inbrain.sdk.config.ToolBarConfig;
import com.inbrain.sdk.model.Reward;
import com.inbrain.sdk.model.Survey;

import java.util.*;

import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.plugin.common.BinaryMessenger;

public class FlutterInbrainPlugin implements FlutterPlugin, MethodCallHandler,ActivityAware {

    private MethodChannel channel;
    static Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_inbrain");
        channel.setMethodCallHandler(this);
    }

    void OnMethodCallHandler2(final String method, final int args) {
        try {
            FlutterInbrainPlugin.activity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod(method, args);
                }
            });
        } catch (Exception e) {
            Log.e("InbrainSDK", "Error " + e.toString());
        }
    }

    void OnMethodCallHandler(final String method, final List args) {
        try {
            FlutterInbrainPlugin.activity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod(method, args);
                }
            });
        } catch (Exception e) {
            Log.e("InbrainSDK", "Error " + e.toString());
        }
    }


    InBrainCallback callback = new InBrainCallback() {

        @Override
        public void surveysClosed() {
            List < String > list = new ArrayList < String > ();
            OnMethodCallHandler("surveyClosed", list);
        }

        @Override
        public void surveysClosedFromPage() {
            List < String > list = new ArrayList < String > ();
            OnMethodCallHandler("surveyClosedFromPage", list);
        }

        @Override
        public boolean didReceiveInBrainRewards(List<Reward> rewards) {
            int total = 0;
            for (Reward reward : rewards) {
                total += reward.amount;
            }
            OnMethodCallHandler2("didRecieveInBrainRewards", total);
            return true;
        }
    };

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("init")) {
            if(call.argument("apiClientId") != null && call.argument("apiSecret") != null && call.argument("isS2S") != null && call.argument("userId") != null) {
             String apiClientId = call.argument("apiClientId");
           String apiSecret = call.argument("apiSecret");
           boolean isS2S = call.argument("isS2S");
           String user_id = call.argument("user_id");
            
            InBrain.getInstance().setInBrain(activity, apiClientId, apiSecret, isS2S, user_id);
            InBrain.getInstance().addCallback(callback);
            InBrain.getInstance().areSurveysAvailable(activity, new SurveysAvailableCallback() {
                @Override
                public void onSurveysAvailable(final boolean available) {
                    List < String > list = new ArrayList < String > ();
                    if (available) {
                        list.add("true");
                    } else {
                        list.add("false");
                    }
                    OnMethodCallHandler("onSurveysAvailable", list);
                    Log.d("InbrainSDK", "Surveys available:" + available);
                }
            }); 
        }   
        } else if (call.method.equals("destroyCallback")) {
            InBrain.getInstance().removeCallback(callback);
        } else if (call.method.equals("customiseUI")) {
            ToolBarConfig toolBarConfig = new ToolBarConfig();
            StatusBarConfig statusBarConfig = new StatusBarConfig();
            String toolbar_title = call.argument("title");
            boolean isElevationEnabled = call.argument("elevation");
            // int toolbar_color = call.argument("toolbar_color");
            // int title_color = call.argument("title_color");
            // int backbutton_color = call.argument("backbutton_color");
            // int statusbar_color = call.argument("statusbar_color");
           // toolBarConfig.setToolbarColor(toolbar_color);
           // toolBarConfig.setToolbarTitle(toolbar_title);
           // toolBarConfig.setTitleColor(title_color);
           // toolBarConfig.setBackButtonColor(backbutton_color);
            toolBarConfig.setElevationEnabled(isElevationEnabled);
           InBrain.getInstance().setToolbarConfig(toolBarConfig);
          // statusBarConfig.setStatusBarColor(statusbar_color);
        } else if (call.method.equals("showSurveys")) {
            InBrain.getInstance().showSurveys(activity, new StartSurveysCallback() {
                @Override
                public void onSuccess() {
                    List < String > list = new ArrayList < String > ();
                    OnMethodCallHandler("onShowSuccess", list);
                }

                @Override
                public void onFail(String message) {
                    List < String > list = new ArrayList < String > ();
                    list.add(message);
                    OnMethodCallHandler("onShowFailure", list);
                }
            });
        } else {
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