import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_mintegral_platform_interface.dart';

/// An implementation of [FlutterMintegralPlatform] that uses method channels.
class MethodChannelFlutterMintegral extends FlutterMintegralPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_mintegral');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
