import 'package:flutter_test/flutter_test.dart';
// import 'package:adcolony_flutter/adcolony_flutter.dart';
import 'package:adcolony_flutter/adcolony_flutter_platform_interface.dart';
import 'package:adcolony_flutter/adcolony_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAdcolonyFlutterPlatform
    with MockPlatformInterfaceMixin
    implements AdcolonyFlutterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AdcolonyFlutterPlatform initialPlatform =
      AdcolonyFlutterPlatform.instance;

  test('$MethodChannelAdcolonyFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAdcolonyFlutter>());
  });

  test('getPlatformVersion', () async {
    // AdcolonyFlutter adcolonyFlutterPlugin = AdcolonyFlutter();
    MockAdcolonyFlutterPlatform fakePlatform = MockAdcolonyFlutterPlatform();
    AdcolonyFlutterPlatform.instance = fakePlatform;

    // expect(await adcolonyFlutterPlugin.getPlatformVersion(), '42');
  });
}
