package com.anavrinapps.trsurveys;

import androidx.annotation.NonNull;
import android.app.Activity;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import theoremreach.com.theoremreach.TheoremReach;
import theoremreach.com.theoremreach.TheoremReachRewardListener;
import theoremreach.com.theoremreach.TheoremReachSurveyAvailableListener;
import theoremreach.com.theoremreach.TheoremReachSurveyListener;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.plugin.common.BinaryMessenger;

import io.flutter.plugin.common.PluginRegistry.Registrar;

import theoremreach.com.theoremreach.TheoremReach;

public class TrsurveysPlugin implements FlutterPlugin, MethodCallHandler,ActivityAware {
 
  private static MethodChannel channel;
  private static TrsurveysPlugin Instance;
  static Activity activity;
  private static final Listeners listeners = new Listeners();


  static TrsurveysPlugin getInstance() {
    return Instance;
}

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.OnAttachedToEngine(flutterPluginBinding.getBinaryMessenger());
  }

  private void OnAttachedToEngine(BinaryMessenger messenger) {
    if (TrsurveysPlugin.Instance == null)
    TrsurveysPlugin.Instance = new TrsurveysPlugin();
  if (TrsurveysPlugin.channel == null) {
    TrsurveysPlugin.channel = new MethodChannel(messenger, "theoremreach");
    TrsurveysPlugin.channel.setMethodCallHandler(this);
    } 
}
void OnMethodCallHandler(final String method, final int args) {
  try {
   TrsurveysPlugin.activity.runOnUiThread(new Runnable() {
             @Override
             public void run() {
                 channel.invokeMethod(method, args);
             }
         });
     } catch (Exception e) {
         Log.e("Trsurveys", "Error " + e.toString());
  }
 }
 private void extractTheoremReachParams(MethodCall call, Result result) {
  String api_token = null;
  if(call.argument("api_token")!=null){
    api_token = call.argument("api_token");
  }else{
    result.error("no_api_token", "a null api token was provided", null);
    return;
  }
  String user_id = null;
  if(call.argument("user_id")!=null){
    user_id = call.argument("user_id");
  }
  TheoremReach.initWithApiKeyAndUserIdAndActivityContext(api_token,user_id,activity);
  TheoremReach.getInstance().setTheoremReachRewardListener(TrsurveysPlugin.listeners);
  TheoremReach.getInstance().setTheoremReachSurveyListener(TrsurveysPlugin.listeners);
  TheoremReach.getInstance().setTheoremReachSurveyAvailableListener(TrsurveysPlugin.listeners);
}
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("init")) {
      extractTheoremReachParams(call,result);
    } else if (call.method.equals("show")) {
      if(call.argument("placementID")!=null){
        String placement = call.argument("placementID");
        TheoremReach.getInstance().showRewardCenter(placement);
      }else{
          TheoremReach.getInstance().showRewardCenter();
      }
    }else if(call.method.equals("setNavBarText")){
      String text = call.argument("text");
      TheoremReach.getInstance().setNavigationBarText(text);
    }else if(call.method.equals("setNavBarColor")){
      String color = call.argument("color");
      TheoremReach.getInstance().setNavigationBarColor(color);
    }else if(call.method.equals("setNavBarTextColor")){
      String textColor = call.argument("text_color");
      TheoremReach.getInstance().setNavigationBarTextColor(textColor);
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
