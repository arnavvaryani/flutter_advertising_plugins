import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'adcolony_flutter_platform_interface.dart';

/// An implementation of [AdcolonyFlutterPlatform] that uses method channels.
class MethodChannelAdcolonyFlutter extends AdcolonyFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('adcolony_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
