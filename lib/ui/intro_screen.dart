import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../game/audio_manager.dart';
import 'level_select_screen.dart';

/// Fullscreen MP4 intro player.
///
/// Behavior:
/// - Plays [assets/videos/intro.mp4] (or web/intro.mp4 on Chrome) muted,
///   edge-to-edge with BoxFit.cover.
/// - A Play button image fades in over 800ms once playback enters the
///   final 2 seconds of the video.
/// - Tapping the Play button is the ONLY way to enter the GameScreen.
/// - If the video fails to initialize OR the asset is missing, the Play
///   button appears immediately on a black background (it is the failsafe).
/// - If play_button.png is missing, an ElevatedButton labelled "PLAY"
///   is rendered in its place via Image.asset's errorBuilder.
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late final VideoPlayerController _controller;

  /// True once the player widget can safely render the video.
  bool _videoReady = false;

  /// Controls Play button visibility + tappability.
  /// - false: invisible and ignores pointer events
  /// - true:  fades to opacity 1.0 over 800ms, becomes tappable immediately
  bool _showPlayButton = false;
  
  /// Controls Skip Intro button visibility + tappability.
  bool _showSkipButton = false;

  @override
  void initState() {
    super.initState();

    // Platform-aware video loading (preserved from Stage 1 fixes).
    _controller = kIsWeb
        ? VideoPlayerController.networkUrl(Uri.parse('intro.mp4'))
        : VideoPlayerController.asset('assets/videos/intro.mp4');

    _controller.initialize().then((_) {
      if (!mounted) return;
      // Mute is required for Chrome autoplay policy.
      _controller.setVolume(0.0);
      _controller.addListener(_onVideoTick);
      _controller.play();

      // Start intro music (will fail silently on web if autoplay is blocked)
      AudioManager.instance.playMusic(AudioManager.introMusic, loop: true);

      setState(() {
        _videoReady = true;
      });
    }).catchError((Object error) {
      // Video missing or failed to load — the Play button IS the failsafe.
      if (!mounted) return;
      setState(() {
        _showPlayButton = true;
        _showSkipButton = true;
      });
    });
  }

  void _onVideoTick() {
    if (!_controller.value.isInitialized) return;

    final position = _controller.value.position;
    final duration = _controller.value.duration;

    // Guard against zero/unknown duration before doing arithmetic.
    if (duration <= Duration.zero) return;

    if (!_showSkipButton && position >= const Duration(seconds: 2)) {
      setState(() {
        _showSkipButton = true;
      });
    }

    if (!_showPlayButton && position >= duration - const Duration(seconds: 2)) {
      setState(() {
        _showPlayButton = true;
      });
    }
  }

  void _skipToLevelSelect() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LevelSelectScreen()),
    );
  }

  void _enterLevelOne() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LevelSelectScreen()),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoTick);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Layer 1 — Video (only mounted when ready; black Scaffold shows otherwise).
          if (_videoReady && _controller.value.isInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),

          // Layer 2 — Play button, lower-center, 15% from bottom.
          Positioned(
            left: 0,
            right: 0,
            bottom: screenHeight * 0.15,
            child: IgnorePointer(
              ignoring: !_showPlayButton,
              child: AnimatedOpacity(
                opacity: _showPlayButton ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                child: Center(
                  child: GestureDetector(
                    onTap: _enterLevelOne,
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Image.asset(
                        'assets/images/play_button.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          // Asset missing — fall back to a plain PLAY button.
                          return SizedBox(
                            width: 120,
                            height: 120,
                            child: ElevatedButton(
                              onPressed: _enterLevelOne,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF1A1A1A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text(
                                'PLAY',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Layer 3 — Skip button, top-right
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: IgnorePointer(
                ignoring: !_showSkipButton,
                child: AnimatedOpacity(
                  opacity: _showSkipButton ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
                  child: GestureDetector(
                    onTap: _skipToLevelSelect,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0x66000000),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Skip Intro ›',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
