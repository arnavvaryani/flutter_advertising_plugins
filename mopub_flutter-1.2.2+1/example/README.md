# **MoPub SDK for Flutter**

## Getting started:
### 1. Initialise Mopub
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
 
 
  ### 4. To load a banner ad

  ```sh
   MoPubBannerAd(
              adUnitId: 'ad_unit_id',
              bannerSize: BannerSize.STANDARD,
              keepAlive: true,
              listener: (result, dynamic) {
                print('$result');
              },
            ),
 ``` 
  ### IMPORTANT: If you’re Publishing and using Proguard:
MoPub includes a proguard.cfg file in both the mopub-sdk and mopub-sample directories. The contents of these identical files should be included in your Proguard config when using the MoPub SDK in a Proguarded project.
 
  For the complete implementation, please refer to the example repo.        
