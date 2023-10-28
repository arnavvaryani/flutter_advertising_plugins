#import "FlutterAyetstudiosPlugin.h"
#if __has_include(<flutter_ayetstudios/flutter_ayetstudios-Swift.h>)
#import <flutter_ayetstudios/flutter_ayetstudios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_ayetstudios-Swift.h"
#endif

@implementation FlutterAyetstudiosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAyetstudiosPlugin registerWithRegistrar:registrar];
}
@end
