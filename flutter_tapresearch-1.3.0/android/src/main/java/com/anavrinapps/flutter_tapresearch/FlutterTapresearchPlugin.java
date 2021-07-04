package com.anavrinapps.flutter_tapresearch;

import androidx.annotation.NonNull;
import android.app.Activity;
import android.os.AsyncTask;
import android.graphics.Color;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.plugin.common.BinaryMessenger;

import com.tapr.sdk.PlacementListener;
import com.tapr.sdk.RewardListener;
import com.tapr.sdk.SurveyListener;
import com.tapr.sdk.TRPlacement;
import com.tapr.sdk.TRReward;
import com.tapr.sdk.TapResearch;

public class FlutterTapresearchPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
 
  private static MethodChannel channel;
  private TRPlacement mPlacement;
  static Activity activity;
 
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.OnAttachedToEngine(flutterPluginBinding.getBinaryMessenger());
  }

   private void OnAttachedToEngine(BinaryMessenger messenger) {
        if (FlutterTapresearchPlugin.channel != null)
            return;
            FlutterTapresearchPlugin.channel = new MethodChannel(messenger, "flutter_tapresearch");
            FlutterTapresearchPlugin.channel.setMethodCallHandler(this);
    }
    
void OnMethodCallHandler(final String method, final int args) {
  try {
    FlutterTapresearchPlugin.activity.runOnUiThread(new Runnable() {
             @Override
             public void run() {
                 channel.invokeMethod(method, args);
             }
         });
     } catch (Exception e) {
         Log.e("Trsurveys", "Error " + e.toString());
  }
 }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("configure")) {
      String api_token;
      if(call.argument("api_token")!=null){
       api_token = call.argument("api_token");
        TapResearch.configure(api_token, activity);
      }else{
        result.error("no_api_token", "a null api token was provided", null);
      }
    } else if(call.method.equals("initPlacement")) {
      String placement_id = null;
      if(call.argument("placement_id")!=null){
       placement_id = call.argument("placement_id");
      } else {
        result.error("no_placement_id", "a null placement id was provided", null);
      }
      TapResearch.getInstance().initPlacement(placement_id, new PlacementListener() {
        @Override
         public void onPlacementReady(TRPlacement placement) {
             if (placement.getPlacementCode() != TRPlacement.PLACEMENT_CODE_SDK_NOT_READY) {
               mPlacement = placement;
               if (mPlacement.isSurveyWallAvailable()) {
                 OnMethodCallHandler("isSurveyWallAvailable",1);
               }
             } else {
               OnMethodCallHandler("isSurveyWallAvailable",0);
             }
         }
       });
    } else if(call.method.equals("setUniqueUserIdentifier")) {
      if(call.argument("user_id")!=null){
        String user_id = call.argument("user_id");
        TapResearch.getInstance().setUniqueUserIdentifier(user_id); 
      }else{
        result.error("no_user_id", "a null user id was provided", null);
        return;
      }
    }
    else if(call.method.equals("setRewardListener")) {
      TapResearch.getInstance().setRewardListener(new RewardListener() {
        @Override
        public void onDidReceiveReward(TRReward reward) {
        OnMethodCallHandler("tapResearchDidReceiveReward",reward.getRewardAmount());
        }
      });
    }
    else if(call.method.equals("setDebugMode")) {
      boolean debugMode  = call.argument("mode");
      TapResearch.getInstance().setDebugMode(debugMode);
    }
    else if (call.method.equals("showSurveyWall")) {
      if(mPlacement !=null) {
        mPlacement.showSurveyWall(new SurveyListener() {
      @Override
      public void onSurveyWallOpened() {
        OnMethodCallHandler("tapResearchSurveyWallOpened",0);
      }

      @Override
      public void onSurveyWallDismissed() {
        OnMethodCallHandler("tapResearchSurveyWallDismissed",0);
      }
  });
} else {
  Log.e("Trsurveys","Surveywall not loaded");
}
}else if(call.method.equals("setNavigationBarText")) {
String actionBarText = call.argument("navBarText");
TapResearch.getInstance().setActionBarText(actionBarText);
}else if(call.method.equals("setNavigationBarColor")){
String navBarColor = call.argument("navColor");
int argColor = Color.parseColor(navBarColor);
TapResearch.getInstance().setActionBarColor(argColor);
}else if(call.method.equals("setNavigationBarTextColor")){
String navBarColor = call.argument("navBarColor");
int argColor = Color.parseColor(navBarColor);
TapResearch.getInstance().setActionBarTextColor(argColor);
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
