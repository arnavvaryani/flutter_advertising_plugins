import 'package:flutter/material.dart';
import 'package:flutter_tapresearch/flutter_tapresearch.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// Replace with your real values from the TapResearch dashboard.
const String _apiToken = 'YOUR_API_TOKEN';
const String _userIdentifier = 'user-123';
const String _placementTag = 'YOUR_PLACEMENT_TAG';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TapResearch _tapResearch = TapResearch.instance;
  String _status = 'Initializing…';
  bool _contentAvailable = false;

  @override
  void initState() {
    super.initState();
    _setUpTapResearch();
  }

  Future<void> _setUpTapResearch() async {
    // Register listeners BEFORE initialize so early callbacks aren't missed.
    _tapResearch
      ..setSdkReadyListener(_onSdkReady)
      ..setRewardsListener(_onRewards)
      ..setErrorListener((error) => setState(() => _status = 'Error: $error'))
      ..setContentShownListener((tag) => debugPrint('TR: content shown ($tag)'))
      ..setContentDismissedListener(
          (tag) => debugPrint('TR: content dismissed ($tag)'));

    await _tapResearch.initialize(
      apiToken: _apiToken,
      userIdentifier: _userIdentifier,
    );
  }

  Future<void> _onSdkReady() async {
    final available =
        await _tapResearch.canShowContentForPlacement(_placementTag);
    setState(() {
      _contentAvailable = available;
      _status = available ? 'Content available' : 'No content available';
    });
  }

  void _onRewards(List<TRReward> rewards) {
    final total = rewards.fold<int>(0, (sum, r) => sum + r.rewardAmount);
    debugPrint('TR: received ${rewards.length} reward(s), total $total');
    setState(() => _status = 'Received $total reward(s)');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('TapResearch example app')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_status),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _contentAvailable
                    ? () => _tapResearch.showContentForPlacement(_placementTag)
                    : null,
                child: const Text('Show TapResearch content'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
