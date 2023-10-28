#import "FlutterTapjoyPlugin.h"

@interface FlutterTapjoyPlugin()

@property (nonatomic, strong) FlutterMethodChannel *tapJoyChannel;
@property (nonatomic, strong) FlutterViewController *flutterViewController;
@property (nonatomic, strong) NSMutableDictionary *placements;

@end

@implementation FlutterTapjoyPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterTapjoyPlugin* instance = [[FlutterTapjoyPlugin alloc] init];
    instance.tapJoyChannel = [FlutterMethodChannel methodChannelWithName:@"flutter_tapjoy" binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:instance channel:instance.tapJoyChannel];
    
    instance.flutterViewController = [[FlutterViewController alloc] initWithProject:nil nibName:nil bundle:nil];
    [Tapjoy setDefaultViewController:instance.flutterViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(tjcConnectSuccess:) name:TJC_CONNECT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(tjcConnectFail:) name:TJC_CONNECT_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(showEarnedCurrencyAlert:) name:TJC_CURRENCY_EARNED_NOTIFICATION object:nil];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *methodDictionary = @{
        @"connectTapJoy": NSStringFromSelector(@selector(connectTapJoy:arguments:result:)),
        @"setUserID": NSStringFromSelector(@selector(setUserID:arguments:result:)),
        @"isConnected": NSStringFromSelector(@selector(isConnected:arguments:result:)),
        @"createPlacement": NSStringFromSelector(@selector(createPlacement:arguments:result:)),
        @"requestContent": NSStringFromSelector(@selector(requestContent:arguments:result:)),
        @"showPlacement": NSStringFromSelector(@selector(showPlacement:arguments:result:)),
        @"getCurrencyBalance": NSStringFromSelector(@selector(getCurrencyBalance:arguments:result:)),
        @"spendCurrency": NSStringFromSelector(@selector(spendCurrency:arguments:result:)),
        @"awardCurrency": NSStringFromSelector(@selector(awardCurrency:arguments:result:)),
        @"getATT": NSStringFromSelector(@selector(getATT:arguments:result:))
    };
    
    SEL methodSelector = NSSelectorFromString(methodDictionary[call.method]);
    if ([self respondsToSelector:methodSelector]) {
        [self performSelector:methodSelector withObject:call.arguments withObject:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)connectTapJoy:(NSDictionary *)dict result:(FlutterResult)result {
    NSString *apiKey = dict[@"iOSApiKey"];
    NSNumber *methodDebug = dict[@"debug"];
    [Tapjoy setDebugEnabled:methodDebug.boolValue];
    [Tapjoy connect:apiKey];
}

- (void)setUserID:(NSDictionary *)dict result:(FlutterResult)result {
    NSString *userID = dict[@"userID"];
    [Tapjoy setUserID:userID];
}

- (void)isConnected:(NSDictionary *)dict result:(FlutterResult)result {
    BOOL isConnected = [Tapjoy isConnected];
    if (isConnected) {
        result(@YES);
    } else {
        result(@NO);
    }
}

- (void)createPlacement:(NSDictionary *)dict result:(FlutterResult)result {
    NSString *placementName = dict[@"placementName"];
    [self addPlacement:placementName];
}

- (void)requestContent:(NSDictionary *)dict result:(FlutterResult)result {
    NSString *placementName = dict[@"placementName"];
    TJPlacement *myPlacement = self.placements[placementName];
    if (myPlacement) {
        [myPlacement requestContent];
    } else {
        NSDictionary *args;
        args = @{ @"error" : @"Placement Not Found, Please Add placement first",@"placementName":placementName};
        [self.tapJoyChannel invokeMethod:@"requestFail" arguments:args];
    }
}

- (void)showPlacement:(NSDictionary *)dict result:(FlutterResult)result {
    NSString *placementName = dict[@"placementName"];
    TJPlacement *myPlacement = self.placements[placementName];
    [myPlacement showContentWithViewController:self.flutterViewController];
}

- (void)getCurrencyBalance:(NSDictionary *)dict result:(FlutterResult)result {
    [Tapjoy getCurrencyBalanceWithCompletion: ^ (NSDictionary * parameters, NSError * error) {
        NSDictionary *args;
        if (error) {
            args = @{ @"error" : error.description};
        } else {
            args = @{ @"currencyName" : parameters[@"currencyName"],@"balance":parameters[@"amount"]};
        }
        [self.tapJoyChannel invokeMethod:@"onGetCurrencyBalanceResponse" arguments:args];
    }];
}

- (void)spendCurrency:(NSDictionary *)dict result:(FlutterResult)result {
    NSNumber *amountToSpend = dict[@"amount"];
    [Tapjoy spendCurrency:amountToSpend.intValue completion:^(NSDictionary *parameters, NSError *error) {
        NSDictionary *args;
        if (error) {
            args = @{ @"error" : error.description};
        } else {
                       args = @{ @"currencyName" : parameters[@"currencyName"],@"balance":parameters[@"amount"]};
        }
        [self.tapJoyChannel invokeMethod:@"onSpendCurrencyResponse" arguments:args];
    }];
}

- (void)awardCurrency:(NSDictionary *)dict result:(FlutterResult)result {
    NSNumber *amountToAward = dict[@"amount"];
    [Tapjoy awardCurrency:amountToAward.intValue completion:^(NSDictionary *parameters, NSError *error) {
        NSDictionary *args;
        if (error) {
            args = @{ @"error" : error.description};
        } else {
            args = @{ @"currencyName" : parameters[@"currencyName"],@"balance":parameters[@"amount"]};
        }
        [self.tapJoyChannel invokeMethod:@"onAwardCurrencyResponse" arguments:args];
    }];
}

- (void)getATT:(NSDictionary *)dict result:(FlutterResult)result {
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            switch (status) {
                case ATTrackingManagerAuthorizationStatusNotDetermined:
                    result(@"NotDetermined");
                    break;
                case ATTrackingManagerAuthorizationStatusRestricted:
                    result(@"Restricted");
                    break;
                case ATTrackingManagerAuthorizationStatusDenied:
                    result(@"Denied");
                    break;
                case ATTrackingManagerAuthorizationStatusAuthorized:
                    result(@"Authorized");
                    break;
                default:
                    result(@"NotFound");
                    break;
            }
        }];
    } else {
        result(@"NOT");
    }
}

#pragma mark - Tapjoy Delegate Methods

- (void)tjcConnectSuccess:(NSNotification *)notifyObj {
    [self.tapJoyChannel invokeMethod:@"connectionSuccess" arguments:nil];
}

- (void)tjcConnectFail:(NSNotification *)notifyObj {
    [self.tapJoyChannel invokeMethod:@"connectionFail" arguments:nil];
}

- (void)requestDidSucceed:(TJPlacement*)placement {
    NSDictionary *args = @{ @"placementName" : placement.placementName };
    [self.tapJoyChannel invokeMethod:@"requestSuccess" arguments:args];
}

- (void)requestDidFail:(TJPlacement*)placement error:(NSError*)error {
    NSDictionary *args = @{ @"placementName" : placement.placementName, @"error":error.description};
    [self.tapJoyChannel invokeMethod:@"requestFail" arguments:args];
}

- (void)contentIsReady:(TJPlacement*)placement {
    NSDictionary *args = @{ @"placementName" : placement.placementName };
    [self.tapJoyChannel invokeMethod:@"contentReady" arguments:args];
}

- (void)contentDidAppear:(TJPlacement*)placement {
    NSDictionary *args = @{ @"placementName" : placement.placementName };
    [self.tapJoyChannel invokeMethod:@"contentDidAppear" arguments:args];
}

- (void)contentDidDisappear:(TJPlacement*)placement {
    NSDictionary *args = @{ @"placementName" : placement.placementName };
    [self.tapJoyChannel invokeMethod:@"contentDidDisappear" arguments:args];
}

- (void)addPlacement:(NSString*)placementName {
    TJPlacement *myPlacement = [TJPlacement placementWithName:placementName delegate:self];
    [self.placements setObject:myPlacement forKey:placementName];
}

- (void)showEarnedCurrencyAlert:(NSNotification*)notifyObj {
    NSDictionary *args = @{ @"earnedAmount" : notifyObj.object};
    [self.tapJoyChannel invokeMethod:@"onAwardCurrencyResponse" arguments:args];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_CURRENCY_EARNED_NOTIFICATION object:nil];
}

@end

