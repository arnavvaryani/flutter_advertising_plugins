import 'package:flutter/material.dart';
import 'package:flutter_tapresearch/flutter_tapresearch.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    TapResearch.instance.configure(apiToken: 'api_token');
    TapResearch.instance.setUniqueUserIdentifier('uid');
    TapResearch.instance.initPlacement(placementId: 'placement_id');
    TapResearch.instance.setDebugMode(true);
    TapResearch.instance.setRewardListener();
    TapResearch.instance.setDidReceiveRewardListener(onTapResearchReward);
    TapResearch.instance
        .setIsSurveyWallAvailableListener(onTapResearchSurveyAvailable);
    TapResearch.instance.setSurveyWallOpenedListener(onTapResearchOpened);
    TapResearch.instance.setSurveyWallDismissedListener(onTapResearchDismissed);
    super.initState();
  }

  void onTapResearchReward(int quantity) {
    print('TR: $quantity');
  }

  void onTapResearchSurveyAvailable(int survey) {
    print('TR: $survey');
  }

  void onTapResearchDismissed() {
    print('TR: closed');
  }

  void onTapResearchOpened() {
    print('TR: opened');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TapResearch example app'),
        ),
        body: Center(
            child: ElevatedButton(
                child: Text("Launch TapResearch"),
                onPressed: () {
                  TapResearch.instance.showSurveyWall();
                })),
      ),
    );
  }
}
