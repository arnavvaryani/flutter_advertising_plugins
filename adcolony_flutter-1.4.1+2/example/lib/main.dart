import 'package:flutter/material.dart';
import 'package:adcolony_flutter/adcolony_flutter.dart';
import 'package:adcolony_flutter/banner.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final zones = [
    'vz4cc427f259db484398',
    'vz943c1ab8c71b46c5a5',
    'vza5b6bdf6080b4a8682'
  ];
  @override
  void initState() {
    super.initState();
    AdColony.init(AdColonyOptions('app4f4659d279be4554ad', '0', this.zones));
  }

  listener(AdColonyAdListener? event, int? reward) async {
    print(event);
    if (event == AdColonyAdListener.onRequestFilled) {
      if (await AdColony.isLoaded()) {
        AdColony.show();
      }
    }
    if (event == AdColonyAdListener.onReward) {
      print('ADCOLONY: $reward');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              ElevatedButton(
                onPressed: () => AdColony.request(this.zones[1], listener),
                child: Text('Show Interstitial'),
              ),
              ElevatedButton(
                onPressed: () async =>
                    AdColony.request(this.zones[0], listener),
                child: Text('Show Interstitial Rewarded'),
              ),
              BannerView(listener, BannerSizes.banner, this.zones[2]),
              BannerView(listener, BannerSizes.medium, this.zones[2]),
              BannerView(listener, BannerSizes.skyscraper, this.zones[2]),
              BannerView(listener, BannerSizes.leaderboard, this.zones[2]),
            ],
          ),
        ),
      ),
    );
  }
}
