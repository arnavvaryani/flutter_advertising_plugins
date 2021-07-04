import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:flutter_tapjoy/flutter_tapjoy.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_tapjoy');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    //  expect(await TapJoyPlugin.platformVersion, '42');
  });
}
