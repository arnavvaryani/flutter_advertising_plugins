#import "FlutterInbrainPlugin.h"
#if __has_include(<flutter_inbrain/flutter_inbrain-Swift.h>)
#import <flutter_inbrain/flutter_inbrain-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_inbrain-Swift.h"
#endif

@implementation FlutterInbrainPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterInbrainPlugin registerWithRegistrar:registrar];
}
@end
