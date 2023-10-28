// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_tapjoy/flutter_tapjoy.dart';
// import 'package:flutter_tapjoy/flutter_tapjoy_platform_interface.dart';
// import 'package:flutter_tapjoy/flutter_tapjoy_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockFlutterTapjoyPlatform
//     with MockPlatformInterfaceMixin
//     implements FlutterTapjoyPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final FlutterTapjoyPlatform initialPlatform = FlutterTapjoyPlatform.instance;

//   test('$MethodChannelFlutterTapjoy is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelFlutterTapjoy>());
//   });

//   test('getPlatformVersion', () async {
//     FlutterTapjoy flutterTapjoyPlugin = FlutterTapjoy();
//     MockFlutterTapjoyPlatform fakePlatform = MockFlutterTapjoyPlatform();
//     FlutterTapjoyPlatform.instance = fakePlatform;

//     expect(await flutterTapjoyPlugin.getPlatformVersion(), '42');
//   });
// }
