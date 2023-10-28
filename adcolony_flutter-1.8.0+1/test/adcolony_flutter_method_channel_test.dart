import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adcolony_flutter/adcolony_flutter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAdcolonyFlutter platform = MethodChannelAdcolonyFlutter();
  const MethodChannel channel = MethodChannel('adcolony_flutter');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
