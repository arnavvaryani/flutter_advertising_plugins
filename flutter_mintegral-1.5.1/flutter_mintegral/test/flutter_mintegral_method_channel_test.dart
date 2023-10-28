import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mintegral/flutter_mintegral_method_channel.dart';

void main() {
  MethodChannelFlutterMintegral platform = MethodChannelFlutterMintegral();
  const MethodChannel channel = MethodChannel('flutter_mintegral');

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
    expect(await platform.getPlatformVersion(), '42');
  });
}
