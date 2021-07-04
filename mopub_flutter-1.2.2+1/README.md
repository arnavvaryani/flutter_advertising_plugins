# **MoPub SDK for Flutter**

  ### Note -  When running the example repo, please make sure to add your GADIdentifier as well as your AppLovin Key to use MoPub mediation, alternatively you can remove these from your Manifest, not doing so may result in crashes.
  
## Getting started:
### 1. Initialise MoPub
Call `Mopub.init()` in the `initState()` of your app

```sh
try {
      MoPub.init('ad_unit_id', testMode: true).then((_) {
        _loadRewardedAd();
        _loadInterstitialAd();
      });
    } on PlatformException {}
```
  
### 2. To load a rewarded ad 
 
 ```sh
 void _loadRewardedAd() {
    videoAd = MoPubRewardedVideoAd('ad_unit_id',
        (result, args) {
      setState(() {
        rewardedResult = '${result.toString()}____$args';
      });
      print('$result');
      if (result == RewardedVideoAdResult.GRANT_REWARD) {
        print('Grant reward: $args');
      }
    }, reloadOnClosed: true);
  }
 ```
 ### 3. To load an interstitial ad  

  ```sh
   void _loadInterstitialAd() {
    interstitialAd = MoPubInterstitialAd(
      'ad_unit_id',
      (result, args) {
        print('Interstitial $result');
      },
      reloadOnClosed: true,
    );    
  }
 ```
 
 
  ### 4. To call a banner ad

  ```sh
   MoPubBannerAd(
              adUnitId: 'ad_unit_id',
              bannerSize: BannerSize.STANDARD,
              keepAlive: true,
              listener: (result, dynamic) {
                print('$result');
              },
            );
 ``` 
  ### IMPORTANT: If you’re Publishing and using Proguard:
```sh
# Keep public classes and methods.
-keepclassmembers class com.mopub.** { public *; }
-keep public class com.mopub.**
-keep public class android.webkit.JavascriptInterface {}

# Explicitly keep any BaseAd and CustomEventNative classes in any package.
-keep class * extends com.mopub.mobileads.BaseAd {}
-keep class * extends com.mopub.nativeads.CustomEventNative {}

# Keep methods that are accessed via reflection
-keepclassmembers class ** { @com.mopub.common.util.ReflectionTarget *; }

-keep class com.google.android.gms.common.GooglePlayServicesUtil {*;}
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient {*;}
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient$Info {*;}

-keep class * extends java.util.ListResourceBundle {
    protected Object[][] getContents();
}

-keep public class com.google.android.gms.common.internal.safeparcel.SafeParcelable {
    public static final *** NULL;
}

-keepnames @com.google.android.gms.common.annotation.KeepName class *
-keepclassmembernames class * {
    @com.google.android.gms.common.annotation.KeepName *;
}

-keepnames class * implements android.os.Parcelable {
    public static final ** CREATOR;
}        
 ``` 