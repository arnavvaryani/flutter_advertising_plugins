import 'package:adcolony_flutter/adcolony_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum BannerSizes { banner, leaderboard, skyscraper, medium }

typedef BannerCreatedCallback = void Function(BannerController controller);

class BannerView extends StatefulWidget {
  final AdColonyListener? listener;
  final BannerSizes size;
  final String id;
  final BannerCreatedCallback onCreated;
  const BannerView(this.listener, this.size, this.id,
      {Key? key, required this.onCreated})
      : super(key: key);
  @override
  BannerViewState createState() => BannerViewState();
}

class BannerViewState extends State<BannerView> {
  final Map<BannerSizes, BannerType> sizes = {
    BannerSizes.banner: BannerType(300, 50, 'BANNER'),
    BannerSizes.leaderboard: BannerType(320, 50, 'LEADERBOARD'),
    BannerSizes.medium: BannerType(300, 250, 'MEDIUM_RECTANGLE'),
    BannerSizes.skyscraper: BannerType(160, 600, 'SKYSCRAPER')
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sizes[widget.size]?.width,
      height: sizes[widget.size]?.height,
      child: AndroidView(
        viewType: '/Banner',
        key: UniqueKey(),
        creationParams: {'Size': sizes[widget.size]?.type, 'Id': widget.id},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      ),
    );
  }

  void _onPlatformViewCreated(int id) {
    BannerController controller = BannerController._(id);
    controller._channel.setMethodCallHandler(
      (MethodCall call) async => handleMethod(call),
    );
    //controller.loadAd();
    widget.onCreated(controller);
  }

  Future<void> handleMethod(MethodCall call) async {
    widget.listener!(AdColony.adColonyAdListener[call.method], call.arguments);
  }
}

class BannerType {
  final double width;
  final double height;
  final String type;

  BannerType(this.width, this.height, this.type);
}

class BannerController {
  BannerController._(int id) : _channel = MethodChannel('Banner_$id');

  final MethodChannel _channel;

  Future<void> loadAd() async {
    return _channel.invokeMethod('loadAd');
  }
}
