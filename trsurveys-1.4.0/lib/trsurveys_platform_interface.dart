import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'trsurveys_method_channel.dart';

abstract class TrsurveysPlatform extends PlatformInterface {
  /// Constructs a TrsurveysPlatform.
  TrsurveysPlatform() : super(token: _token);

  static final Object _token = Object();

  static TrsurveysPlatform _instance = MethodChannelTrsurveys();

  /// The default instance of [TrsurveysPlatform] to use.
  ///
  /// Defaults to [MethodChannelTrsurveys].
  static TrsurveysPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TrsurveysPlatform] when
  /// they register themselves.
  static set instance(TrsurveysPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
