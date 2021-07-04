import 'package:flutter/material.dart';
import 'package:flutter_inbrain/flutter_inbrain.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FlutterInBrain.instance.init(
        apiClientId: 'your_api_token',
        apiSecret:
            'your_api_secret',
        isS2S: false,
        userId: 'user_id');
    FlutterInBrain.instance.setDidReceiveRewardListener((int reward) {
      print('callback message:$reward');
      print('Inbrain: did recieve reward callback');
    });
    FlutterInBrain.instance.setIsSurveyWallAvailableListener((List list) {
      print('callback message:$list');
      print('Inbrain: surveywall available callback');
    });
    FlutterInBrain.instance.setIsSurveyWallFailureListener((List list) {
      print('callback message:$list');
      print('Inbrain: surveywall failure callback');
    });
    FlutterInBrain.instance.setIsSurveyWallSuccessListener(() {
      print('Inbrain: surveywall success callback');
    });
    FlutterInBrain.instance.setSurveyClosedListener(() {
      print('Inbrain: surveywall closed callback');
    });
    FlutterInBrain.instance.setSurveyWallClosedFromPageListener(() {
      print('Inbrain: surveywall closed callback');
    });
    FlutterInBrain.instance.setDidRecieveiOSSurveywallListener((reward) { 
        print('callback message:$reward');
      print('Inbrain: did recieve ios reward callback');
    });
    FlutterInBrain.instance.setIsSurveyWalliOSSuccessListener((available) { 
      print('Inbrain: surveywall ios success callback');
    });
    super.initState();
  }

  @override
  void dispose() {
    FlutterInBrain.instance.destroyCallback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Inbrain SDK example'),
        ),
        body: Center(
            child: ElevatedButton(
                child: Text("Launch FlutterInBrain"),
                onPressed: () {
                  FlutterInBrain.instance.show();
                })),
      ),
    );
  }
}
