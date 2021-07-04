// package com.anavrinapps.flutter_mintegral.utils;

// import android.app.Activity;
// import android.graphics.Point;
// import android.util.Log;
// import android.view.Gravity;
// import android.view.View;
// import android.view.ViewGroup;
// import android.content.Context;
// import android.widget.FrameLayout;

// import androidx.annotation.NonNull;

// import com.mbridge.msdk.out.BannerAdListener;
// import com.mbridge.msdk.out.BannerSize;
// import com.mbridge.msdk.out.MBBannerView;

// import java.util.HashMap;
// import java.util.Map;

// import io.flutter.plugin.common.BinaryMessenger;
// import io.flutter.plugin.common.MethodCall;
// import io.flutter.plugin.common.MethodChannel;
// import io.flutter.plugin.platform.PlatformView;

// import com.anavrinapps.flutter_mintegral.*;

// public class BannerUtil implements PlatformView {
//  //private FrameLayout layout;
//     private static final String TAG = "BannerUtil";
//     private int height;
//     private int width;
//     private MethodChannel channel;
//     private int size;
//     private String adUnitId;
//     private String placementId;
//     private boolean closeButton;
//     private int refreshTime;
//     private MBBannerView mtgBannerView;

//     public BannerUtil(Context context, BinaryMessenger messenger, int id, HashMap args) {
//         try {
//             this.size = (int) args.get("size");
//             this.adUnitId = (String) args.get("adUnitId");
//             this.placementId = (String) args.get("placementId");
//             this.closeButton = (boolean) args.get("closeButton");
//             this.refreshTime = (int) args.get("refreshTime");
//             this.height = (int) args.get("height");
//             this.width = (int) args.get("width");
//             this.channel = new MethodChannel(messenger, "flutter_mintegral");
//            //  this.layout = new FrameLayout(FlutterMintegralPlugin.activity);
//         mtgBannerView = new MBBannerView(FlutterMintegralPlugin.activity);
//         mtgBannerView.init(new BannerSize(BannerSize.DEV_SET_TYPE, 1294, 720), "138791", "146879");
//         mtgBannerView.setAllowShowCloseBtn(false);
//         mtgBannerView.setRefreshTime(60);
//         mtgBannerView.setBannerAdListener(new BannerAdListener() {
//             @Override
//             public void onLoadFailed(String msg) {
//                 OnMethodCallHandler("onBannerLoadFailed");
//                 Log.e(TAG, "on load failed" + msg);
//             }

//             @Override
//             public void onLoadSuccessed() {
//                 OnMethodCallHandler("onBannerLoadSuccess");
//                 Log.e(TAG, "on load successed");
//             }

//             @Override
//             public void onClick() {
//                 OnMethodCallHandler("onBannerClick");
//                 Log.e(TAG, "onAdClick");
//             }

//             @Override
//             public void onLeaveApp() {
//                 OnMethodCallHandler("onBannerLeaveApp");
//                 Log.e(TAG, "leave app");
//             }

//             @Override
//             public void showFullScreen() {
//                 OnMethodCallHandler("onBannerFullScreen");
//                 Log.e(TAG, "showFullScreen");
//             }

//             @Override
//             public void closeFullScreen() {
//                 OnMethodCallHandler("onBannercloseFullScreen");
//                 Log.e(TAG, "closeFullScreen");
//             }

//             @Override
//             public void onLogImpression() {
//                 OnMethodCallHandler("onBannerLogImpression");
//                 Log.e(TAG, "onLogImpression");
//             }

//             @Override
//             public void onCloseBanner() {
//                 OnMethodCallHandler("onBannerClose");
//                 Log.e(TAG, "onCloseBanner");
//             }
//         });
//         if (mtgBannerView != null) {
//             //this.layout.removeAllViews();
//             mtgBannerView.load();
//             mtgBannerView.setLayoutParams(new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
//             //  FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT,
//             //      FrameLayout.LayoutParams.MATCH_PARENT);
//             // this.layout.addView(mtgBannerView,0,layoutParams);
//             // layout.setVisibility(View.VISIBLE);
//         }
            
//         } catch (Exception e) {
//             Log.e("MintegralSDK", e.toString());
//         }
//     }

//     @Override
//     public View getView() {
//         return mtgBannerView;
//     }

//     @Override
//     public void dispose() {
//         //this.layout.removeAllViews();
//         if (mtgBannerView != null) {
//             mtgBannerView.release();
//         }
//     }

//     void OnMethodCallHandler(final String method) {
//         try {
//            FlutterMintegralPlugin.activity.runOnUiThread(new Runnable() {
//                 @Override
//                 public void run() {
//                  channel.invokeMethod(method, null);
//                 }
//             });
//         } catch (Exception e) {
//             Log.e("MintegralSDK", "Error " + e.toString());
//         }
//     }

// }