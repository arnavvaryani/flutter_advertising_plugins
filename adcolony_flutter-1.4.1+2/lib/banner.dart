import 'package:adcolony_flutter/adcolony_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum BannerSizes { banner, leaderboard, skyscraper, medium }

class BannerView extends StatelessWidget {
  final AdColonyListener listener;
  final BannerSizes size;
  final String id;

  final Map<BannerSizes, BannerType> sizes = {
    BannerSizes.banner: BannerType(300, 50, 'BANNER'),
    BannerSizes.leaderboard: BannerType(320, 50, 'LEADERBOARD'),
    BannerSizes.medium: BannerType(300, 250, 'MEDIUM_RECTANGLE'),
    BannerSizes.skyscraper: BannerType(160, 600, 'SKYSCRAPER')
  };

  BannerView(this.listener, this.size, this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.sizes[this.size]!.width,
      height: this.sizes[this.size]!.height,
      child: AndroidView(
        viewType: '/Banner',
        key: UniqueKey(),
        creationParams: {'Size': this.sizes[this.size]!.type, 'Id': this.id},
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: (int i) {
          AdColony.channel.setMethodCallHandler(
              (MethodCall call) async => AdColony.handleMethod(call, listener));
        },
      ),
    );
  }
}

class BannerType {
  final double width;
  final double height;
  final String type;

  BannerType(this.width, this.height, this.type);
}
