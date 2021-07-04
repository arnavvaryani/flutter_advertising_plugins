import 'package:flutter/material.dart';
import 'package:flutter_mintegral/flutter_mintegral.dart';

class BannerAdHome extends StatefulWidget {
  @override
  _BannerAdHomeState createState() => _BannerAdHomeState();
}

class _BannerAdHomeState extends State<BannerAdHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      // body: BannerView(
      //   (FlutterMintegralListener event) => print(event),
      //   BannerSizes.standard,
      //   placementId: '138791',
      //   adUnitId: '146879',
      //   refreshTime: 15,
      //   closeButton: false,
      // ),
    );
  }

  @override
  void initState() {
    Mintegral.showBannerAD(
      adUnitId: "146879",
      placementId: "138791",
      height: 1000,
      width: 1000,
      bannerType: 5,
      closeButton: true,
      refreshTime: 5,
    );

    super.initState();
  }

  @override
  void dispose() {
    Mintegral.disposeBannerAD(adUnitId: "146879");
    super.dispose();
  }
}
