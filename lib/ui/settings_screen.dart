import 'package:flutter/material.dart';

import '../game/audio_manager.dart';

/// Settings screen with Music and SFX volume sliders.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final musicVol = AudioManager.instance.musicVolume;
    final sfxVol = AudioManager.instance.sfxVolume;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ─────────────────────────────────────────
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // ── Body ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GROUP 1 — Music Volume
                  const Text(
                    'Music',
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      color: Color(0xFFE8C46A),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.music_note,
                        size: 24,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Slider(
                          value: musicVol,
                          min: 0.0,
                          max: 1.0,
                          divisions: 20,
                          activeColor: const Color(0xFFE8C46A),
                          inactiveColor: const Color(0xFF3D3530),
                          onChanged: (value) async {
                            setState(() {});
                            await AudioManager.instance.setMusicVolume(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 48,
                        child: Text(
                          '${(musicVol * 100).round()}%',
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // GROUP 2 — SFX Volume
                  const Text(
                    'Sound Effects',
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      color: Color(0xFFE8C46A),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.graphic_eq,
                        size: 24,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Slider(
                          value: sfxVol,
                          min: 0.0,
                          max: 1.0,
                          divisions: 20,
                          activeColor: const Color(0xFFE8C46A),
                          inactiveColor: const Color(0xFF3D3530),
                          onChanged: (value) async {
                            setState(() {});
                            await AudioManager.instance.setSfxVolume(value);
                            // Play a sample SFX so the player hears the new volume
                            AudioManager.instance.playEffect(AudioManager.sfxSpriteTap);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 48,
                        child: Text(
                          '${(sfxVol * 100).round()}%',
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
