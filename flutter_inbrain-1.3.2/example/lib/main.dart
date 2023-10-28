import 'package:flutter/material.dart';
import 'package:flutter_inbrain/flutter_inbrain.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    FlutterInBrain.instance.init(
        apiClientId: 'your_api_token',
        apiSecret: 'your_api_secret',
        isS2S: false,
        userId: 'user_id');
    FlutterInBrain.instance.setDidReceiveRewardListener((int? reward) {
      debugPrint('callback message:$reward');
      debugPrint('Inbrain: did recieve reward callback');
    });
    FlutterInBrain.instance.setIsSurveyWallAvailableListener((List? list) {
      debugPrint('callback message:$list');
      debugPrint('Inbrain: surveywall available callback');
    });
    FlutterInBrain.instance.setIsSurveyWallFailureListener((List? list) {
      debugPrint('callback message:$list');
      debugPrint('Inbrain: surveywall failure callback');
    });
    FlutterInBrain.instance.setIsSurveyWallSuccessListener(() {
      debugPrint('Inbrain: surveywall success callback');
    });
    FlutterInBrain.instance.setSurveyClosedListener(() {
      debugPrint('Inbrain: surveywall closed callback');
    });
    FlutterInBrain.instance.setSurveyWallClosedFromPageListener(() {
      debugPrint('Inbrain: surveywall closed callback');
    });
    FlutterInBrain.instance.setDidRecieveiOSSurveywallListener((reward) {
      debugPrint('callback message:$reward');
      debugPrint('Inbrain: did recieve ios reward callback');
    });
    FlutterInBrain.instance.setIsSurveyWalliOSSuccessListener((available) {
      debugPrint('Inbrain: surveywall ios success callback');
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
                child: const Text("Launch FlutterInBrain"),
                onPressed: () {
                  FlutterInBrain.instance.show();
                })),
      ),
    );
  }
}
