// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_tapresearch/flutter_tapresearch.dart';

// void main() {
//   const MethodChannel channel = MethodChannel('flutter_tapresearch');

//   TestWidgetsFlutterBinding.ensureInitialized();

//   setUp(() {
//     channel.setMockMethodCallHandler((MethodCall methodCall) async {
//       return '42';
//     });
//   });

//   tearDown(() {
//     channel.setMockMethodCallHandler(null);
//   });

//   test('getPlatformVersion', () async {
//     expect(await FlutterTapresearch.platformVersion, '42');
//   });
// }
