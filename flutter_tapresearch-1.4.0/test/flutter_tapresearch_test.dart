import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tapresearch/flutter_tapresearch.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('flutter_tapresearch');
  final log = <MethodCall>[];

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      log.add(call);
      switch (call.method) {
        case 'isReady':
        case 'canShowContentForPlacement':
          return true;
        default:
          return null;
      }
    });
    log.clear();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('initialize forwards token and user identifier', () async {
    await TapResearch.instance
        .initialize(apiToken: 'token', userIdentifier: 'user-1');
    expect(log.single.method, 'initialize');
    expect(log.single.arguments,
        {'apiToken': 'token', 'userIdentifier': 'user-1'});
  });

  test('canShowContentForPlacement passes the placement tag', () async {
    final result =
        await TapResearch.instance.canShowContentForPlacement('my_tag');
    expect(result, isTrue);
    expect(log.single.method, 'canShowContentForPlacement');
    expect(log.single.arguments, {'placementTag': 'my_tag'});
  });

  test('showContentForPlacement forwards custom parameters', () async {
    await TapResearch.instance
        .showContentForPlacement('my_tag', customParameters: {'k': 'v'});
    expect(log.single.method, 'showContentForPlacement');
    expect(log.single.arguments, {
      'placementTag': 'my_tag',
      'customParameters': {'k': 'v'},
    });
  });

  test('onRewards callback parses a batched reward list', () async {
    final received = <TRReward>[];
    TapResearch.instance.setRewardsListener(received.addAll);

    const codec = StandardMethodCodec();
    final message = codec.encodeMethodCall(const MethodCall('onRewards', [
      {
        'transactionIdentifier': 'tx-1',
        'placementIdentifier': 'p-1',
        'placementTag': 'tag',
        'currencyName': 'Coins',
        'rewardAmount': 50,
        'payoutEventType': 'reward',
      }
    ]));

    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage('flutter_tapresearch', message, (_) {});

    expect(received, hasLength(1));
    expect(received.single.transactionIdentifier, 'tx-1');
    expect(received.single.rewardAmount, 50);
  });
}
