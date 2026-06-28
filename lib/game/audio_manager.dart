import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioManager {
  AudioManager._privateConstructor();
  static final AudioManager instance = AudioManager._privateConstructor();

  final AudioPlayer _musicPlayer = AudioPlayer();
  String? _currentMusicAsset;

  double _musicVolume = 1.0;
  double _sfxVolume = 1.0;

  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  // Constants for asset paths (Note: AssetSource implies 'assets/' prefix)
  static const String introMusic = 'audio/intro_music.mp3';
  static const String gameplayMusic = 'audio/gameplay_music.mp3';
  static const String sfxSpriteTap = 'audio/sound_sprite_tap.mp3';
  static const String sfxSparkle = 'audio/sound_sparkle.mp3';
  static const String sfxWin = 'audio/sound_win.mp3';
  static const String sfxLose = 'audio/sound_lose.mp3';
  static const String sfxLevelComplete = 'audio/sound_level_complete.mp3';

  /// Loads saved volume settings from SharedPreferences.
  /// Call this from main() before runApp.
  Future<void> loadSavedVolumes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _musicVolume = (prefs.getDouble('music_volume') ?? 1.0).clamp(0.0, 1.0);
      _sfxVolume = (prefs.getDouble('sfx_volume') ?? 1.0).clamp(0.0, 1.0);
      await _musicPlayer.setVolume(_musicVolume);
    } catch (e) {
      debugPrint('Failed to load saved volumes: $e');
    }
  }

  /// Sets music volume (0.0–1.0), applies immediately, persists.
  Future<void> setMusicVolume(double v) async {
    _musicVolume = v.clamp(0.0, 1.0);
    try {
      await _musicPlayer.setVolume(_musicVolume);
    } catch (e) {
      debugPrint('Failed to set music player volume: $e');
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('music_volume', _musicVolume);
    } catch (e) {
      debugPrint('Failed to persist music volume: $e');
    }
  }

  /// Sets SFX volume (0.0–1.0), persists. Applied on next playEffect call.
  Future<void> setSfxVolume(double v) async {
    _sfxVolume = v.clamp(0.0, 1.0);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('sfx_volume', _sfxVolume);
    } catch (e) {
      debugPrint('Failed to persist sfx volume: $e');
    }
  }

  Future<void> playMusic(String assetPath, {bool loop = true}) async {
    if (_currentMusicAsset == assetPath && _musicPlayer.state == PlayerState.playing) {
      return; // Already playing
    }

    try {
      await _musicPlayer.stop();
      _currentMusicAsset = assetPath;
      await _musicPlayer.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.release);
      await _musicPlayer.play(AssetSource(assetPath));
      await _musicPlayer.setVolume(_musicVolume);
    } catch (e) {
      debugPrint('Failed to play music: $e');
    }
  }

  Future<void> stopMusic() async {
    try {
      await _musicPlayer.stop();
      _currentMusicAsset = null;
    } catch (e) {
      debugPrint('Failed to stop music: $e');
    }
  }

  Future<void> playEffect(String assetPath) async {
    try {
      final player = AudioPlayer();
      await player.setVolume(_sfxVolume);
      player.onPlayerComplete.listen((_) {
        player.dispose();
      });
      await player.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('Failed to play effect: $e');
    }
  }
}
