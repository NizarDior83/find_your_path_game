import 'package:flutter/material.dart';

import '../game/game_screen.dart';
import '../game/level_manager.dart';
import '../game/progress_manager.dart';
import '../game/audio_manager.dart';
import 'settings_screen.dart';

/// Level Select Screen — shows 5 tappable cards, one per level.
class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioManager.instance.stopMusic();
    });

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content column
            Column(
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Center(
                    child: Text(
                      'Choose Your Adventure',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(
                            color: Color(0x88E8C46A),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Level cards
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        for (int n = 1; n <= kTotalLevels; n++) ...[
                          _LevelCard(levelNumber: n),
                          if (n < kTotalLevels) const SizedBox(height: 16),
                        ],
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Settings gear icon — top-right
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
                icon: Image.asset(
                  'assets/images/icon_settings.png',
                  width: 32,
                  height: 32,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 28,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int levelNumber;

  const _LevelCard({required this.levelNumber});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = ProgressManager.instance.isLevelUnlocked(levelNumber);

    Widget cardContent = Container(
      height: 96,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2520),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Level icon
            SizedBox(
              width: 64,
              height: 64,
              child: Image.asset(
                getLevelIconForLevel(levelNumber),
                width: 64,
                height: 64,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3530),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$levelNumber',
                      style: const TextStyle(
                        color: Color(0xFFE8C46A),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            // Level name and number
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Level $levelNumber',
                    style: const TextStyle(
                      color: Color(0xFFE8C46A),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    getLevelNameForLevel(levelNumber),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Chevron arrow
            Icon(
              Icons.chevron_right,
              size: 24,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ],
        ),
      );

    if (!isUnlocked) {
      cardContent = Opacity(
        opacity: 0.4,
        child: cardContent,
      );
    }

    return GestureDetector(
      onTap: isUnlocked
          ? () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => GameScreen(levelNumber: levelNumber),
                ),
              );
            }
          : null,
      child: cardContent,
    );
  }
}
