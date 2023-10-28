import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_inbrain_platform_interface.dart';

/// An implementation of [FlutterInbrainPlatform] that uses method channels.
class MethodChannelFlutterInbrain extends FlutterInbrainPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_inbrain');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
