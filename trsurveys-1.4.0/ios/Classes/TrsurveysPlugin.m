#import "TrsurveysPlugin.h"
#if __has_include(<trsurveys/trsurveys-Swift.h>)
#import <trsurveys/trsurveys-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "trsurveys-Swift.h"
#endif

@implementation TrsurveysPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTrsurveysPlugin registerWithRegistrar:registrar];
}
@end
