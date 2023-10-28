import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_tapjoy_platform_interface.dart';

/// An implementation of [FlutterTapjoyPlatform] that uses method channels.
class MethodChannelFlutterTapjoy extends FlutterTapjoyPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_tapjoy');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
