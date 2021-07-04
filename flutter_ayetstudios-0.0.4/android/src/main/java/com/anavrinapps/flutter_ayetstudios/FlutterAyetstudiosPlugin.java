package com.anavrinapps.flutter_ayetstudios;

import androidx.annotation.NonNull;
import android.app.Activity;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.platform.PlatformViewRegistry;

import com.ayetstudios.publishersdk.AyetSdk;
import com.ayetstudios.publishersdk.messages.SdkUserData;
import com.ayetstudios.publishersdk.messages.SdkUserBalance;
import com.ayetstudios.publishersdk.interfaces.UserBalanceCallback;
import com.ayetstudios.publishersdk.interfaces.DeductUserBalanceCallback;
import com.ayetstudios.publishersdk.models.NativeOfferList;

public class FlutterAyetstudiosPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  static Activity activity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_ayetstudios");
    channel.setMethodCallHandler(this);
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_ayetstudios");
    channel.setMethodCallHandler(new FlutterAyetstudiosPlugin());
  }

void OnMethodCallHandler(final String method, final int args) {
  try {
      FlutterAyetstudiosPlugin.activity.runOnUiThread(new Runnable() {
          @Override
          public void run() {
              channel.invokeMethod(method, args);
          }
      });
  } catch (Exception e) {
      Log.e("flutter_ayetstudios", "Error " + e.toString());
  }
}

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("init")) {
        String amount = call.argument("uid");
       AyetSdk.init(activity.getApplication(), amount, new UserBalanceCallback() { 
            @Override
            public void userBalanceChanged(SdkUserBalance sdkUserBalance) {
                OnMethodCallHandler("userBalanceChanged",sdkUserBalance.getAvailableBalance());
                Log.d("AyetSdk" , "userBalanceChanged - available balance: "+sdkUserBalance.getAvailableBalance()); 
            }

            @Override
            public void userBalanceInitialized(SdkUserBalance sdkUserBalance) {
              OnMethodCallHandler("initializationFailed",0);
                OnMethodCallHandler("userAvailableBalance",sdkUserBalance.getAvailableBalance());
                OnMethodCallHandler("userPendingBalance",sdkUserBalance.getPendingBalance());
            }
            
            @Override
            public void initializationFailed() {
                 OnMethodCallHandler("initializationFailed",1);
                Log.d("AyetSdk", "initializationFailed - please check APP API KEY & internet connectivity");
            }
        });
    } else if(call.method.equals("show")) {
        String placement = call.argument("placement");
        if (AyetSdk.isInitialized()) {
          AyetSdk.showOfferwall(activity.getApplication(), placement);	
          Log.d("AyetSdk" , "SDK is ready");
       } else {
        Log.d("AyetSdk" , "SDK is NOT ready");
       }                
    }  else if(call.method.equals("deduct")) {
        int amount = call.argument("amount");
        AyetSdk.deductUserBalance(activity.getApplication(), amount, new DeductUserBalanceCallback() {
          @Override
          public void success() {
            OnMethodCallHandler("deductUserBalance",1);
              // Log.d("AyetSdk" , "deductUserBalance - successful, new available balance: "+AyetSdk.getAvailableBalance());
             
          }
  
          @Override
          public void failed() {
            OnMethodCallHandler("deductUserBalance",0);
              Log.d("AyetSdk" , "deductUserBalance - failed");
          }
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
  public void onAttachedToActivity(ActivityPluginBinding binding) {
      FlutterAyetstudiosPlugin.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
      FlutterAyetstudiosPlugin.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {

  }
}
