import 'package:flutter/material.dart';
import 'package:flutter_mintegral/flutter_mintegral.dart';
import 'banner.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    Mintegral.initSdk(
        appId: "118690", appKey: "7c22942b749fe6a6e361b675e96b3ee9");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainHome());
  }
}

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  bool isInterReady;
  bool isInteractiveReady;
  bool isRewardReady;

  @override
  void initState() {
    Mintegral.setListeners(listener);
    isInterReady = false;
    isInteractiveReady = false;
    isRewardReady = false;
    super.initState();
  }

  listener(FlutterMintegralListener event) {
    //All events can be called here
    if (event == FlutterMintegralListener.onInitSuccess) {
      Mintegral.loadInteractiveAD(
        adUnitId: "146878",
        placementId: "138790",
      );
      Mintegral.loadInterstitialVideoAD(
        adUnitId: "146869",
        placementId: "138781",
      );
      Mintegral.loadRewardVideoAD(
        adUnitId: "146874",
        placementId: "138786",
      );
    } else if (event == FlutterMintegralListener.onInteractivelLoadSuccess) {
      isInteractiveReady = true;
    } else if (event == FlutterMintegralListener.onInterstitialVideoLoadSuccess) {
      isInterReady = true;
      print('isInterReady :$isInterReady');
     } 
     else if (event == FlutterMintegralListener.onRewardLoadSuccess) {
      isRewardReady = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text("banner"),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => BannerAdHome()));
              },
            ),
            ElevatedButton(
              child: Text("splash"),
              onPressed: () {
                Mintegral.startSplashAd(
                  adUnitId: "209547",
                  placementId: "173349",
                );
              },
            ),
            ElevatedButton(
                child: Text("Interactive"),
                onPressed: () { 
                  if (isInteractiveReady) {
                    Mintegral.showInteractiveAD();
                  }
                }),
            ElevatedButton(
              child: Text("InterstitialVideo"),
              onPressed: () {
                if (isInterReady) {
                  Mintegral.showInterstitialVideoAD();
                }
              },
            ),
            ElevatedButton(
              child: Text("RewardVideo"),
              onPressed: () {
                if (isRewardReady) {
                  Mintegral.showRewardedVideoAD();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
