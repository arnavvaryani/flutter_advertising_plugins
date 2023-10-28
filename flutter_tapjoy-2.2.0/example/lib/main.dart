import 'package:flutter/material.dart';
import 'package:flutter_tapjoy/flutter_tapjoy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final TJPlacement myPlacement = TJPlacement(name: "LevelComplete");
  final TJPlacement myPlacement2 = TJPlacement(name: "Placement02");
  String contentStateText = "";
  String connectionState = "";
  String iOSATTAuthResult = "";
  String balance = "";

  @override
  void initState() {
    super.initState();
    // set connection result handler
    TapJoyPlugin.shared.setConnectionResultHandler(_connectionResultHandler);
    // connect to TapJoy, all fields are required.
    TapJoyPlugin.shared.connect(
      androidApiKey: "tap_joy_android_api_key",
      iOSApiKey: "tap_joy_ios_api_key",
      debug: true,
    );
    // set userID
    TapJoyPlugin.shared.setUserID(userID: "user_id123");
    // set contentState handler for each placement
    myPlacement.setHandler(_placementHandler);
    myPlacement2.setHandler(_placementHandler);
    // add placements
    TapJoyPlugin.shared.addPlacement(myPlacement);
    TapJoyPlugin.shared.addPlacement(myPlacement2);
    // set currency handlers
    TapJoyPlugin.shared.setGetCurrencyBalanceHandler(_currencyHandler);
    TapJoyPlugin.shared.setAwardCurrencyHandler(_currencyHandler);
    TapJoyPlugin.shared.setSpendCurrencyHandler(_currencyHandler);
    TapJoyPlugin.shared.setEarnedCurrencyAlertHandler(_currencyHandler);
  }

  // currency handler
  void _currencyHandler(String? currencyName, int? amount, String? error) {
    setState(() {
      balance = "Currency Name: $currencyName Amount: $amount Error: $error";
    });
  }

  // connection result handler
  void _connectionResultHandler(TJConnectionResult result) {
    setState(() {
      connectionState = result == TJConnectionResult.connected
          ? "Connected"
          : "Disconnected";
    });
  }

  // placement handler
  void _placementHandler(
    TJContentState contentState,
    String? name,
    String? error,
  ) {
    setState(() {
      switch (contentState) {
        case TJContentState.contentReady:
          contentStateText = "Content Ready for placement: $name";
          break;
        case TJContentState.contentDidAppear:
          contentStateText = "Content Did Appear for placement: $name";
          break;
        case TJContentState.contentDidDisappear:
          contentStateText = "Content Did Disappear for placement: $name";
          break;
        case TJContentState.contentRequestSuccess:
          contentStateText =
              "Content Request Success for placement: $name";
          break;
        case TJContentState.contentRequestFail:
          contentStateText =
              "Content Request Fail + $error for placement: $name";
          break;
        case TJContentState.userClickedAndroidOnly:
          contentStateText = "Content User Clicked for placement: $name";
          break;
      }
    });
  }

  // get App Tracking Authentication (iOS only)
  Future<void> getAuth() async {
    final result = await TapJoyPlugin.shared.getIOSATTAuth();
    setState(() {
      switch (result) {
        case IOSATTAuthResult.notDetermined:
          iOSATTAuthResult = "Not Determined";
          break;
        case IOSATTAuthResult.restricted:
          iOSATTAuthResult = "Restricted";
          break;
        case IOSATTAuthResult.denied:
          iOSATTAuthResult = "Denied";
          break;
        case IOSATTAuthResult.authorized:
          iOSATTAuthResult = "Authorized";
          break;
        case IOSATTAuthResult.none:
          iOSATTAuthResult = "Error";
          break;
        case IOSATTAuthResult.iOSVersionNotSupported:
          iOSATTAuthResult = "iOS Version Not Supported";
          break;
        case IOSATTAuthResult.android:
          iOSATTAuthResult = "on Android";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TapJoy Flutter'),
        ),
        body: Center(
          child: Column(
            children: [
              Text("Connection State: $connectionState"),
              ElevatedButton(
                onPressed: getAuth,
                child: const Text("get iOS App Tracking Auth"),
              ),
              Text("IOS Auth Result: $iOSATTAuthResult"),
              ElevatedButton(
                onPressed: myPlacement.requestContent,
                child: const Text("request content for Placement 001"),
              ),
              ElevatedButton(
                onPressed: myPlacement2.requestContent,
                child: const Text("request content for Placement 002"),
              ),
              Text("Content State: $contentStateText"),
              ElevatedButton(
                onPressed: myPlacement.showPlacement,
                child: const Text("show Placement 001"),
              ),
              ElevatedButton(
                onPressed: myPlacement2.showPlacement,
                child: const Text("show Placement 002"),
              ),
              ElevatedButton(
                onPressed: TapJoyPlugin.shared.getCurrencyBalance,
                child: const Text("get balance"),
              ),
              ElevatedButton(
                onPressed: () {
                  TapJoyPlugin.shared.awardCurrency(15);
                },
                child: const Text("award balance"),
              ),
              ElevatedButton(
                onPressed: () {
                  TapJoyPlugin.shared.spendCurrency(5);
                },
                child: const Text("spend balance"),
              ),
              Text("Balance Response: $balance"),
            ],
          ),
        ),
      ),
    );
  }
}
