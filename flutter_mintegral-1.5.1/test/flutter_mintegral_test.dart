import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mintegral/flutter_mintegral.dart';
// ignore: implementation_imports
import 'package:flutter_mintegral/src/ad_instance_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final channel = instanceManager.channel;
  final log = <MethodCall>[];
  bool initResult = true;

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      log.add(call);
      if (call.method == 'initialize') {
        return <dynamic, dynamic>{
          'initializationStatus': initResult,
          'error': initResult ? null : 'boom',
        };
      }
      return null;
    });
    log.clear();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('initialize forwards appId/appKey and reports success', () async {
    initResult = true;
    var succeeded = false;
    await Mintegral.instance.initialize(
      appId: 'app-id',
      appKey: 'app-key',
      onInitSuccess: () => succeeded = true,
      onInitFail: (_) => fail('should not fail'),
    );

    final init = log.firstWhere((c) => c.method == 'initialize');
    expect(init.arguments, {'appId': 'app-id', 'appKey': 'app-key'});
    expect(succeeded, isTrue);
  });

  test('initialize reports failure with the error string', () async {
    initResult = false;
    String? error;
    await Mintegral.instance.initialize(
      appId: 'app-id',
      appKey: 'app-key',
      onInitSuccess: () => fail('should not succeed'),
      onInitFail: (e) => error = e,
    );
    expect(error, 'boom');
  });
}
