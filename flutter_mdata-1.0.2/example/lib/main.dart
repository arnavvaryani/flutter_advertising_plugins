import 'package:flutter/material.dart';
import 'package:flutter_mdata/flutter_mdata.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  void isSDKReady(bool isReady) {
    if (isReady) {
      MoneDataSDK.instance.consent();
    }
  }

  void consentListener(bool consent) {
    print('consent: $consent');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MoneDataSDK example app'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text("Init SDK"),
              onPressed: () {
                MoneDataSDK.instance
                    .init(apiToken: 'api_token', oguryToken: 'ogury_token');
                MoneDataSDK.instance.setConsentListener(consentListener);
                MoneDataSDK.instance.setisReadyListener(isSDKReady);
              },
            ),
          ],
        )),
      ),
    );
  }
}
