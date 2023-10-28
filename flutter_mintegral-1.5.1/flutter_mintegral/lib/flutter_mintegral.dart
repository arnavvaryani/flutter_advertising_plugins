
import 'flutter_mintegral_platform_interface.dart';

class FlutterMintegral {
  Future<String?> getPlatformVersion() {
    return FlutterMintegralPlatform.instance.getPlatformVersion();
  }
}
