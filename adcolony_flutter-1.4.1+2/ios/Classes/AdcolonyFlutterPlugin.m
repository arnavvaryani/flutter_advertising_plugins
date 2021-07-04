#import "AdcolonyFlutterPlugin.h"
#if __has_include(<adcolony_flutter/adcolony_flutter-Swift.h>)
#import <adcolony_flutter/adcolony_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "adcolony_flutter-Swift.h"
#endif

@implementation AdcolonyFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAdcolonyFlutterPlugin registerWithRegistrar:registrar];
}
@end
