import 'package:flutter/material.dart';
import 'package:flutter_tapjoy/flutter_tapjoy.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TJPlacement myPlacement = TJPlacement(name: "LevelComplete");
  TJPlacement myPlacement2 = TJPlacement(name: "Placement02");
  String contentStateText = "";
  String connectionState = "";
  String iOSATTAuthResult = "";
  String balance = "";
  @override
  void initState() {
    super.initState();
    // set connection result handler
    TapJoyPlugin.shared.setConnectionResultHandler(_connectionResultHandler());
    // connect to TapJoy, all fields are required.
    TapJoyPlugin.shared.connect(
        androidApiKey: "tap_joy_android_api_key",
        iOSApiKey: "tap_joy_ios_api_key",
        debug: true);
    // set userID
    TapJoyPlugin.shared.setUserID(userID: "user_id123");
    // set contentState handler for each placement
    myPlacement.setHandler(_placementHandler());
    myPlacement2.setHandler(_placementHandler());
    // add placements.
    TapJoyPlugin.shared.addPlacement(myPlacement);
    TapJoyPlugin.shared.addPlacement(myPlacement2);
    // set currency Handlers
    TapJoyPlugin.shared.setGetCurrencyBalanceHandler(_currencyHandler());
    TapJoyPlugin.shared.setAwardCurrencyHandler(_currencyHandler());
    TapJoyPlugin.shared.setSpendCurrencyHandler(_currencyHandler());
    TapJoyPlugin.shared.setEarnedCurrencyAlertHandler(_currencyHandler());
  }

// currency handler
  TJSpendCurrencyHandler _currencyHandler() {
    TJSpendCurrencyHandler handler = (currencyName, amount, error) {
      setState(() {
        balance = "Currency Name: " +
            currencyName.toString() +
            " Amount:  " +
            amount.toString() +
            " Error:" +
            error.toString();
      });
    };
    return handler;
  }

  // connection result handler
  TJConnectionResultHandler _connectionResultHandler() {
    TJConnectionResultHandler handler = (result) {
      switch (result) {
        case TJConnectionResult.connected:
          setState(() {
            connectionState = "Connected";
          });
          break;
        case TJConnectionResult.disconnected:
          setState(() {
            connectionState = "Disconnected";
          });
          break;
      }
    };
    return handler;
  }

  // placement Handler
  TJPlacementHandler _placementHandler() {
    TJPlacementHandler handler = (contentState, name, error) {
      switch (contentState) {
        case TJContentState.contentReady:
          setState(() {
            contentStateText = "Content Ready for placement :  $name";
          });
          break;
        case TJContentState.contentDidAppear:
          setState(() {
            contentStateText = "Content Did Appear for placement :  $name";
          });
          break;
        case TJContentState.contentDidDisappear:
          setState(() {
            contentStateText = "Content Did Disappear for placement :  $name";
          });
          break;
        case TJContentState.contentRequestSuccess:
          setState(() {
            contentStateText = "Content Request Success for placement :  $name";
          });
          break;
        case TJContentState.contentRequestFail:
          setState(() {
            contentStateText =
                "Content Request Fail + $error for placement :  $name";
          });
          break;
        case TJContentState.userClickedAndroidOnly:
          setState(() {
            contentStateText = "Content User Clicked for placement :  $name";
          });
          break;
      }
    };
    return handler;
  }

  // get App Tracking Authentication . iOS ONLY
  Future<void> getAuth() async {
    TapJoyPlugin.shared.getIOSATTAuth().then((value) {
      switch (value) {
        case IOSATTAuthResult.notDetermined:
          setState(() {
            iOSATTAuthResult = "Not Determined";
          });
          break;
        case IOSATTAuthResult.restricted:
          setState(() {
            iOSATTAuthResult = "Restricted ";
          });
          break;
        case IOSATTAuthResult.denied:
          setState(() {
            iOSATTAuthResult = "Denied ";
          });
          break;
        case IOSATTAuthResult.authorized:
          setState(() {
            iOSATTAuthResult = "Authorized ";
          });
          break;
        case IOSATTAuthResult.none:
          setState(() {
            iOSATTAuthResult = "Error ";
          });
          break;
        case IOSATTAuthResult.iOSVersionNotSupported:
          setState(() {
            iOSATTAuthResult = "IOS Version Not Supported ";
          });
          break;
        case IOSATTAuthResult.android:
          setState(() {
            iOSATTAuthResult = "on Android";
          });
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
              Text("Connection State : $connectionState"),
              ElevatedButton(
                child: Text("get iOS App Tracking Auth"),
                onPressed: getAuth,
              ),
              Text("IOS Auth Result : $iOSATTAuthResult"),
              ElevatedButton(
                child: Text("request content for Placement 001"),
                onPressed: myPlacement.requestContent,
              ),
              ElevatedButton(
                child: Text("request content for Placement 002"),
                onPressed: myPlacement2.requestContent,
              ),
              Text("Content State : $contentStateText"),
              ElevatedButton(
                child: Text("show Placement 001"),
                onPressed: myPlacement.showPlacement,
              ),
              ElevatedButton(
                child: Text("show Placement 002"),
                onPressed: myPlacement2.showPlacement,
              ),
              ElevatedButton(
                child: Text("get balance"),
                onPressed: TapJoyPlugin.shared.getCurrencyBalance,
              ),
              ElevatedButton(
                child: Text("award balance"),
                onPressed: () {
                  TapJoyPlugin.shared.awardCurrency(15);
                },
              ),
              ElevatedButton(
                child: Text("spend balance"),
                onPressed: () {
                  TapJoyPlugin.shared.spendCurrency(5);
                },
              ),
              Text("Balance Response : $balance"),
            ],
          ),
        ),
      ),
    );
  }
}
