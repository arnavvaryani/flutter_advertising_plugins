import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_mintegral_method_channel.dart';

abstract class FlutterMintegralPlatform extends PlatformInterface {
  /// Constructs a FlutterMintegralPlatform.
  FlutterMintegralPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterMintegralPlatform _instance = MethodChannelFlutterMintegral();

  /// The default instance of [FlutterMintegralPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterMintegral].
  static FlutterMintegralPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterMintegralPlatform] when
  /// they register themselves.
  static set instance(FlutterMintegralPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
