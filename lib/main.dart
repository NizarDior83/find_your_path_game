import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game/audio_manager.dart';
import 'game/progress_manager.dart';
import 'ui/intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hide status bar and navigation bar — no UI chrome
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // 9:16 portrait lock
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize persistent progress state
  await ProgressManager.instance.init();

  // Load saved volume settings before first audio playback
  await AudioManager.instance.loadSavedVolumes();

  runApp(const FindYourPathApp());
}

class FindYourPathApp extends StatelessWidget {
  const FindYourPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find Your Path',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        // Black background at all times — prevents white flash on any route
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          surface: Colors.black,
        ),
      ),
      home: const IntroScreen(),
    );
  }
}
