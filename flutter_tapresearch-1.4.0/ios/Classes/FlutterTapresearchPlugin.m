#import "FlutterTapresearchPlugin.h"

@implementation FlutterTapresearchPlugin

TRPlacement *tapresearchPlacement;
 FlutterMethodChannel* channel;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
 channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_tapresearch"
            binaryMessenger:[registrar messenger]];
  FlutterTapresearchPlugin* instance = [[FlutterTapresearchPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
   NSDictionary *dict = call.arguments;
  if ([@"configure" isEqualToString:call.method]) {
    NSString *apiKey = dict[@"user_id"];
    [TapResearch initWithApiToken:apiKey delegate:nil];
  } else if ([@"setUniqueUserIdentifier" isEqualToString:call.method]) {
    NSString *placementId = dict[@"placement_id"];
    [TapResearch setUniqueUserIdentifier:placementId];
  } else if ([@"initPlacement" isEqualToString:call.method]) {
      NSString *placement_id = dict[@"user_id"];
    [TapResearch initPlacementWithIdentifier:placement_id placementBlock:^(TRPlacement *placement) {
    tapresearchPlacement = placement;
        if (tapresearchPlacement.placementCode != PLACEMENT_CODE_SDK_NOT_READY) {
            [channel invokeMethod:@"isSurveyWallAvailable" arguments:[NSNumber numberWithBool:tapresearchPlacement.isSurveyWallAvailable]];
        } else {
            [channel invokeMethod:@"isSurveyWallAvailable" arguments:[NSNumber numberWithBool:tapresearchPlacement.isSurveyWallAvailable]];
        }
  }];
  } else if ([@"showSurveyWall" isEqualToString:call.method]) {
    [tapresearchPlacement showSurveyWallWithDelegate:nil];
  } else if ([@"setNavigationBarText" isEqualToString:call.method]) {
    NSString *navBarText = dict[@"navBarText"];
    [TapResearch setNavigationBarText:navBarText];
  } else if ([@"setNavigationBarColor" isEqualToString:call.method]) {
      CGFloat red = (CGFloat) [call.arguments[@"red"]floatValue];
      CGFloat blue = (CGFloat) [call.arguments[@"blue"]floatValue];
      CGFloat green = (CGFloat) [call.arguments[@"green"]floatValue];
      CGFloat alpha = (CGFloat) [call.arguments[@"alpha"]floatValue];
      [TapResearch setNavigationBarColor:[UIColor colorWithRed:red green:green blue:blue alpha:alpha]];
  } else if ([@"setNavigationBarTextColor" isEqualToString:call.method]) {
      CGFloat red = (CGFloat) [call.arguments[@"red"]floatValue];
      CGFloat blue = (CGFloat) [call.arguments[@"blue"]floatValue];
      CGFloat green = (CGFloat) [call.arguments[@"green"]floatValue];
      CGFloat alpha = (CGFloat) [call.arguments[@"alpha"]floatValue];
      [TapResearch setNavigationBarTextColor:[UIColor colorWithRed:red green:green blue:blue alpha:alpha]];
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}
- (void)tapResearchDidReceiveReward:(TRReward *)reward
{
  [channel invokeMethod:@"tapResearchDidReceive" arguments:[NSNumber numberWithInteger:reward.rewardAmount]];
}
- (void)tapResearchSurveyWallOpenedWithPlacement:(TRPlacement *)placement
{
  [channel invokeMethod:@"tapResearchSurveyWallOpened" arguments:nil];
}

- (void)tapResearchSurveyWallDismissedWithPlacement:(TRPlacement *)placement
{
  [channel invokeMethod:@"tapResearchSurveyWallDismissed" arguments:nil];
}
@end
