import 'ad_instance_manager.dart';

class Mintegral {
  Mintegral._();

  static final Mintegral _instance = Mintegral._().._init();

  /// Shared instance to initialize the Mintegral SDK.
  static Mintegral get instance => _instance;

  Future<void> initialize({
    required String appId,
    required String appKey,
    void Function()? onInitSuccess,
    void Function(String error)? onInitFail,
  }) async {
    Map<dynamic, dynamic> result = await instanceManager.initialize(appId: appId, appKey: appKey);
    bool initializationStatus = result['initializationStatus'];
    if (initializationStatus) {
      onInitSuccess?.call();
    } else {
      onInitFail?.call(result['error']);
    }
  }

  void _init() {
    instanceManager.channel.invokeMethod('_init');
  }
}