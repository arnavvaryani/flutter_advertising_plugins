import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'adcolony_flutter_method_channel.dart';

abstract class AdcolonyFlutterPlatform extends PlatformInterface {
  /// Constructs a AdcolonyFlutterPlatform.
  AdcolonyFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static AdcolonyFlutterPlatform _instance = MethodChannelAdcolonyFlutter();

  /// The default instance of [AdcolonyFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelAdcolonyFlutter].
  static AdcolonyFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AdcolonyFlutterPlatform] when
  /// they register themselves.
  static set instance(AdcolonyFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
