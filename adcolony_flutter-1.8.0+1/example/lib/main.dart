import 'package:flutter/material.dart';
import 'package:adcolony_flutter/adcolony_flutter.dart';
import 'package:adcolony_flutter/banner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late final List<String> zones = [
    'vz4cc427f259db484398',
    'vz943c1ab8c71b46c5a5',
    'vza5b6bdf6080b4a8682',
  ];

  handleAdColonyEvent(AdColonyAdListener? event, int? reward) {
    switch (event) {
      case AdColonyAdListener.onRequestFilled:
        AdColony.show();
        if (reward != null) {
          debugPrint('Adcolony: Reward amount: $reward');
        }
        break;
      case AdColonyAdListener.onRequestNotFilled:
        debugPrint('Adcolony: Ad request not filled');
        break;
      case AdColonyAdListener.onExpiring:
        debugPrint('Adcolony: Ad expiring');
        break;
      case AdColonyAdListener.onClicked:
        debugPrint('Adcolony: Ad clicked');
        break;
      case AdColonyAdListener.onLeftApplication:
        debugPrint('Adcolony: Ad left application');
        break;
      case AdColonyAdListener.onOpened:
        debugPrint('Adcolony: Ad opened');
        break;
      case AdColonyAdListener.onClosed:
        debugPrint('Adcolony: Ad closed');
        break;
      case AdColonyAdListener.onIAPEvent:
        debugPrint('Adcolony: IAP event');
        break;
      case AdColonyAdListener.onReward:
        debugPrint('Adcolony: Ad reward : $reward');
        break;
      default:
        debugPrint('Invalid method');
    }
  }

  @override
  void initState() {
    super.initState();
    initializeAdColony();
  }

  Future<void> initializeAdColony() async {
    try {
      await AdColony.init(
        AdColonyOptions(
          'app4f4659d279be4554ad',
          '0',
          zones,
        ),
      );
    } catch (e) {
      debugPrint('AdColony initialization failed: $e');
    }
  }

  Future<void> requestInterstitial(String zone) async {
    try {
      await AdColony.request(zone, handleAdColonyEvent);
      debugPrint('Adcolony: Interstitial ad requested');
    } catch (e) {
      debugPrint('AdColony request failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin Example App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => requestInterstitial(zones[0]),
                child: const Text('Request Interstitial Ad'),
              ),
              ElevatedButton(
                onPressed: () => requestInterstitial(zones[1]),
                child: const Text('Request Rewarded Interstitial Ad'),
              ),
              BannerView(handleAdColonyEvent, BannerSizes.banner, zones[2],
                  onCreated: (BannerController controller) {}),
              const SizedBox(
                height: 20,
              ),
              BannerView(handleAdColonyEvent, BannerSizes.medium, zones[2],
                  onCreated: (BannerController controller) {}),
            ],
          ),
        ),
      ),
    );
  }
}
