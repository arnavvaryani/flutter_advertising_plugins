import 'package:flutter/material.dart';
import 'package:flutter_ayetstudios/flutter_ayetstudios.dart';
import 'package:flutter_ayetstudios/ios.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      AyeTStudios.instance.init(uid: 'uid');
      AyeTStudios.instance.setInitilizationFailedListener(initializationFailed);
      AyeTStudios.instance.setUserAvailableBalance(userAvailableBalance);
      AyeTStudios.instance.setUserBalanceChanged(userBalanceChanged);
      AyeTStudios.instance.setUserPendingBalance(userPendingBalance);
    } else if (Platform.isIOS) {
      AyeTStudiosIOS.instance.sdkLogEnable();
      AyeTStudiosIOS.instance.init(appKey: 'api_key', uid: 'uid');
      AyeTStudiosIOS.instance.setUserAvailableBalance(userAvailableBalance);
      AyeTStudiosIOS.instance.setUserBalanceChanged(userBalanceChanged);
      AyeTStudiosIOS.instance.setUserPendingBalance(userPendingBalance);
      AyeTStudiosIOS.instance.userAvailableBalance();
      AyeTStudiosIOS.instance.userPendingBalance();
    }
  }

  void initializationFailed(int failed) {
    print('AyetSdk", "initializationFailed $failed');
  }

  void userAvailableBalance(int balance) {
    print('AyetSdk available balance = $balance');
  }

  void userBalanceChanged(int balance) {
    print('AyetSdk balance changed = $balance');
  }

  void userPendingBalance(int balance) {
    print('AyetSdk pending balance = $balance');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ListView(
            children: <Widget>[
              ElevatedButton(
                onPressed: () => AyeTStudios.instance.show('placement_name'),
                child: Text('Show Offerwall'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
