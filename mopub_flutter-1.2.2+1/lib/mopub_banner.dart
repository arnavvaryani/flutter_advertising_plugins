import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'mopub_constants.dart';

class BannerSize {
  final int width;
  final int height;

  static const BannerSize MATCH_VIEW = BannerSize(width: 320, height: 0);
  static const BannerSize STANDARD = BannerSize(width: 320, height: 50);
  static const BannerSize LARGE = BannerSize(width: 320, height: 90);
  static const BannerSize MEDIUM_RECTANGLE =
      BannerSize(width: 320, height: 250);

  const BannerSize({this.width = 320, this.height = 50});
}

enum BannerAdResult {
  /// Banner Ad error.
  ERROR,

  /// Banner Ad loaded successfully.
  LOADED,

  /// Banner Ad clicked.
  CLICKED,
}

class MoPubBannerAd extends StatefulWidget {
  final String adUnitId;

  /// Size of the Banner Ad. Choose from three pre-defined sizes.
  final BannerSize bannerSize;

  /// Banner Ad listener
  final void Function(BannerAdResult, dynamic) listener;

  /// This defines if the ad view to be kept alive.
  final bool keepAlive;

  const MoPubBannerAd({
    Key key,
    this.adUnitId,
    this.bannerSize = BannerSize.MATCH_VIEW,
    this.listener,
    this.keepAlive = false,
  }) : super(key: key);

  @override
  _MoPubBannerAdState createState() => _MoPubBannerAdState();
}

class _MoPubBannerAdState extends State<MoPubBannerAd>
    with AutomaticKeepAliveClientMixin {
  var containerHeight = 0.5;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var viewType = BANNER_AD_CHANNEL;
    var params = <String, dynamic>{
      "adUnitId": widget.adUnitId,
      "autoRefresh": false,
      "height": widget.bannerSize.height,
    };

    Widget platformView;
    if (Platform.isIOS) {
      platformView = UiKitView(
        viewType: viewType,
        creationParams: params,
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: _onBannerAdViewCreated,
      );
    } else {
      platformView = AndroidView(
        viewType: viewType,
        creationParams: params,
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: _onBannerAdViewCreated,
      );
    }

    return Container(
      height: containerHeight,
      color: Colors.transparent,
      child: platformView,
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;

  void _onBannerAdViewCreated(int id) {
    final channel = MethodChannel('${BANNER_AD_CHANNEL}_$id');

    channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case ERROR_METHOD:
          if (widget.listener != null)
            widget.listener(BannerAdResult.ERROR, call.arguments);
          break;
        case LOADED_METHOD:
          setState(() {
            containerHeight = widget.bannerSize.height <= -1
                ? double.infinity
                : widget.bannerSize.height.toDouble();
          });
          if (widget.listener != null)
            widget.listener(BannerAdResult.LOADED, call.arguments);
          break;
        case CLICKED_METHOD:
          if (widget.listener != null)
            widget.listener(BannerAdResult.CLICKED, call.arguments);
          break;
      }
    });
  }
}
