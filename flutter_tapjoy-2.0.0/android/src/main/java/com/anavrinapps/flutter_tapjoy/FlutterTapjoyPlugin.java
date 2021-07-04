package com.anavrinapps.flutter_tapjoy;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import com.tapjoy.TJActionRequest;
import com.tapjoy.TJAwardCurrencyListener;
import com.tapjoy.TJConnectListener;
import com.tapjoy.TJEarnedCurrencyListener;
import com.tapjoy.TJError;
import com.tapjoy.TJGetCurrencyBalanceListener;
import com.tapjoy.TJPlacement;
import com.tapjoy.TJPlacementListener;
import com.tapjoy.TJSpendCurrencyListener;
import com.tapjoy.Tapjoy;
import com.tapjoy.TapjoyConnectFlag;

import java.util.Hashtable;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterTapjoyPlugin */
public class FlutterTapjoyPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  static Activity activity;
  private Context context;
  Hashtable<String, TJPlacement> placements = new Hashtable<String, TJPlacement>();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_tapjoy");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();

  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
    switch (call.method) {
      case "connectTapJoy":
        Tapjoy.setActivity(activity);
        final String tapjoySDKKey = call.argument("androidApiKey");
        final Boolean debug = call.argument("debug");
        Hashtable<String, Object> connectFlags = new Hashtable<String, Object>();
        connectFlags.put(TapjoyConnectFlag.ENABLE_LOGGING, "true");
        Tapjoy.setDebugEnabled(debug);
        boolean resulti = Tapjoy.connect(context, tapjoySDKKey, connectFlags, new TJConnectListener() {
          @Override
          public void onConnectSuccess() {

            channel.invokeMethod("connectionSuccess",null);
          }

          @Override
          public void onConnectFailure() {
            channel.invokeMethod("connectionFail",null);
          }
        });
        result.success(resulti);
        Tapjoy.setEarnedCurrencyListener(new TJEarnedCurrencyListener() {
          @Override
          public void onEarnedCurrency(String currencyName, int amount) {
            Hashtable<String, Object> getCurrencyResponse = new Hashtable<String, Object>();
              getCurrencyResponse.put("currencyName",currencyName);
              getCurrencyResponse.put("earnedAmount",amount);
              invokeMethod("onEarnedCurrency",getCurrencyResponse);
          }
        });
        break;
      case "setUserID":
        final String userID = call.argument("userID");
        Tapjoy.setUserID(userID);
        break;
      case "isConnected":
        result.success(Tapjoy.isConnected());
        break;
      case "createPlacement":
        final String placementName = call.argument("placementName");
        TJPlacementListener placementListener = new TJPlacementListener() {
          @Override
          public void onRequestSuccess(final TJPlacement tjPlacement) {
            final Hashtable<String, Object> myMap = new Hashtable<String, Object>();
            myMap.put("placementName",tjPlacement.getName());
             invokeMethod("requestSuccess",myMap);
          }

          @Override
          public void onRequestFailure(TJPlacement tjPlacement, TJError tjError) {
            final Hashtable<String, Object> myMap = new Hashtable<String, Object>();
            myMap.put("placementName",tjPlacement.getName());
            myMap.put("error",tjError.message);
              invokeMethod("requestFail",myMap);
          }

          @Override
          public void onContentReady(TJPlacement tjPlacement) {
            final Hashtable<String, Object> myMap = new Hashtable<String, Object>();
            myMap.put("placementName",tjPlacement.getName());
              invokeMethod("contentReady",myMap);
          }

          @Override
          public void onContentShow(TJPlacement tjPlacement) {
            final Hashtable<String, Object> myMap = new Hashtable<String, Object>();
            myMap.put("placementName",tjPlacement.getName());
            invokeMethod("contentDidAppear",myMap);
          }

          @Override
          public void onContentDismiss(TJPlacement tjPlacement) {
            final Hashtable<String, Object> myMap = new Hashtable<String, Object>();
            myMap.put("placementName",tjPlacement.getName());
           invokeMethod("contentDidDisAppear",myMap);

          }

          @Override
          public void onPurchaseRequest(TJPlacement tjPlacement, TJActionRequest tjActionRequest, String s) {

          }

          @Override
          public void onRewardRequest(TJPlacement tjPlacement, TJActionRequest tjActionRequest, String s, int i) {

          }

          @Override
          public void onClick(TJPlacement tjPlacement) {
            final Hashtable<String, Object> myMap = new Hashtable<String, Object>();
            myMap.put("placementName",tjPlacement.getName());
           invokeMethod("clicked",myMap);
          }
        };
        TJPlacement p = Tapjoy.getPlacement(placementName, placementListener);
        placements.put(placementName,p);
        result.success(p.isContentAvailable());
        break;
      case "requestContent":
        final String placementNameRequest = call.argument("placementName");
        final TJPlacement tjPlacementRequest = placements.get(placementNameRequest);
        if (tjPlacementRequest != null) {
          tjPlacementRequest.requestContent();
        } else {
          final Hashtable<String, Object> myMap = new Hashtable<String, Object>();
          myMap.put("placementName",placementNameRequest);
          myMap.put("error","Placement Not Found, Please Add placement first");
          invokeMethod("requestFail",myMap);
        }
        break;
      case "showPlacement":
        final String placementNameShow = call.argument("placementName");
        final TJPlacement tjPlacementShow = placements.get(placementNameShow);
        assert tjPlacementShow != null;
        tjPlacementShow.showContent();
        break;
      case "getCurrencyBalance":
        Tapjoy.getCurrencyBalance(new TJGetCurrencyBalanceListener(){
          Hashtable<String, Object> getCurrencyResponse = new Hashtable<String, Object>();
          @Override
          public void onGetCurrencyBalanceResponse(String currencyName, int balance) {
            getCurrencyResponse.put("currencyName",currencyName);
            getCurrencyResponse.put("balance",balance);
            invokeMethod("onGetCurrencyBalanceResponse",getCurrencyResponse);
          }
          @Override
          public void onGetCurrencyBalanceResponseFailure(String error) {
              getCurrencyResponse.put("error",error);
              invokeMethod("onGetCurrencyBalanceResponse",getCurrencyResponse);
            }
        });

        break;
      case "spendCurrency":
        final int myAmountInt = call.argument("amount");
        Tapjoy.spendCurrency(myAmountInt, new TJSpendCurrencyListener() {
          Hashtable<String, Object> spendCurrencyResponse = new Hashtable<String, Object>();
          @Override
          public void onSpendCurrencyResponse(String currencyName, int balance) {
            spendCurrencyResponse.put("currencyName",currencyName);
            spendCurrencyResponse.put("balance",balance);
            invokeMethod("onSpendCurrencyResponse",spendCurrencyResponse);
          }

          @Override
          public void onSpendCurrencyResponseFailure(String error) {
            spendCurrencyResponse.put("error",error);
            invokeMethod("onSpendCurrencyResponse",spendCurrencyResponse);
          }
        });

        break;

      case "awardCurrency":
        final int myAmountIntAward = call.argument("amount");
        Tapjoy.awardCurrency(myAmountIntAward, new TJAwardCurrencyListener() {
          Hashtable<String, Object> awardCurrencyResponse = new Hashtable<String, Object>();
          @Override
          public void onAwardCurrencyResponse(String currencyName, int balance) {
            awardCurrencyResponse.put("currencyName",currencyName);
            awardCurrencyResponse.put("balance",balance);
            invokeMethod("onAwardCurrencyResponse",awardCurrencyResponse);
          }

          @Override
          public void onAwardCurrencyResponseFailure(String error) {
            awardCurrencyResponse.put("error",error);
            invokeMethod("onAwardCurrencyResponse",awardCurrencyResponse);
          }
        });

        break;
      default:
        result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull  ActivityPluginBinding binding) {
    FlutterTapjoyPlugin.activity = binding.getActivity();
  }


  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull  ActivityPluginBinding binding) {
    FlutterTapjoyPlugin.activity = binding.getActivity();
  }


  @Override
  public void onDetachedFromActivity() {

  }

  void invokeMethod(@NonNull final String methodName,final Hashtable<String,Object> data) {
    try {
      FlutterTapjoyPlugin.activity.runOnUiThread(new Runnable() {@Override
      public void run() {
        channel.invokeMethod(methodName,data);
      }
      });
    } catch(final Exception e) {
      Log.e("FlutterTapjoyPlugin", "Error " + e.toString());
    }
  }
}
