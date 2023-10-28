import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trsurveys/trsurveys_method_channel.dart';

void main() {
  MethodChannelTrsurveys platform = MethodChannelTrsurveys();
  const MethodChannel channel = MethodChannel('trsurveys');

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
