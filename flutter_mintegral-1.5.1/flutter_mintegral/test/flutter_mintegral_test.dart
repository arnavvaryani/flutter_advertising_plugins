import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mintegral/flutter_mintegral.dart';
import 'package:flutter_mintegral/flutter_mintegral_platform_interface.dart';
import 'package:flutter_mintegral/flutter_mintegral_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterMintegralPlatform
    with MockPlatformInterfaceMixin
    implements FlutterMintegralPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterMintegralPlatform initialPlatform = FlutterMintegralPlatform.instance;

  test('$MethodChannelFlutterMintegral is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterMintegral>());
  });

  test('getPlatformVersion', () async {
    FlutterMintegral flutterMintegralPlugin = FlutterMintegral();
    MockFlutterMintegralPlatform fakePlatform = MockFlutterMintegralPlatform();
    FlutterMintegralPlatform.instance = fakePlatform;

    expect(await flutterMintegralPlugin.getPlatformVersion(), '42');
  });
}
