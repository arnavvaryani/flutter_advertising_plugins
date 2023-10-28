import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_tapjoy_method_channel.dart';

abstract class FlutterTapjoyPlatform extends PlatformInterface {
  /// Constructs a FlutterTapjoyPlatform.
  FlutterTapjoyPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTapjoyPlatform _instance = MethodChannelFlutterTapjoy();

  /// The default instance of [FlutterTapjoyPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterTapjoy].
  static FlutterTapjoyPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterTapjoyPlatform] when
  /// they register themselves.
  static set instance(FlutterTapjoyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
