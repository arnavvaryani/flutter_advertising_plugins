import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'trsurveys_platform_interface.dart';

/// An implementation of [TrsurveysPlatform] that uses method channels.
class MethodChannelTrsurveys extends TrsurveysPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('trsurveys');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
