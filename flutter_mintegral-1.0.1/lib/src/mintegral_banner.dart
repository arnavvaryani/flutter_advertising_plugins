// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_mintegral/flutter_mintegral.dart';

// enum BannerSizes { large, medium, smart, standard }
// typedef void BannerCreatedCallback();

// class BannerView extends StatefulWidget {
//   final FlutterMintegralAdListener listener;
//   final BannerSizes size;
//   final bool closeButton;
//   final int refreshTime;
//   final String adUnitId;
//   final String placementId;

//   BannerView(this.listener, this.size,
//       {Key key,
//       @required this.refreshTime,
//       @required this.closeButton,
//       @required this.placementId,
//       @required this.adUnitId})
//       : super(key: key);
//   @override
//   _BannerViewState createState() => _BannerViewState();
// }

// class _BannerViewState extends State<BannerView> {
//   final Map<BannerSizes, BannerType> sizes = {
//     BannerSizes.large: BannerType(320, 90, 1),
//     BannerSizes.medium: BannerType(300, 250, 2),
//     BannerSizes.smart: BannerType(728, 90, 3),
//     BannerSizes.standard: BannerType(320, 50, 4)
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: this.sizes[this.widget.size].width,
//       height: this.sizes[this.widget.size].height,
//       child: AndroidView(
//         viewType: '/Banner',
//         key: UniqueKey(),
//         creationParams: {
//           'closeButton': widget.closeButton,
//           'refreshTime': widget.refreshTime,
//           'adUnitId': widget.adUnitId,
//           'placementId': widget.placementId,
//           'size': this.sizes[this.widget.size].type,
//           'height': this.sizes[this.widget.size].height,
//           'width': this.sizes[this.widget.size].width
//         },
//         creationParamsCodec: StandardMessageCodec(),
//       ),
//     );
//   }

//   Future<void> handleMethod(MethodCall call) async {
//     if (this.widget.listener != null)
//       this
//           .widget
//           .listener(FlutterMintegral.flutterMintegralListener[call.method]);
//   }
// }

// class BannerType {
//   final double width;
//   final double height;
//   final int type;

//   BannerType(this.width, this.height, this.type);
// }
