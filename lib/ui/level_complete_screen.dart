import 'package:flutter/material.dart';

class LevelCompleteScreen extends StatefulWidget {
  final int levelNumber;
  final VoidCallback onTryAgain;
  final VoidCallback? onNextLevel;
  final VoidCallback onHome;

  const LevelCompleteScreen({
    super.key,
    required this.levelNumber,
    required this.onTryAgain,
    this.onNextLevel,
    required this.onHome,
  });

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _opacity = 1.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isFinalLevel = widget.levelNumber >= 5;

    final titleText = isFinalLevel ? 'Congratulations!' : 'Level Complete';
    final subtitleText = isFinalLevel
        ? 'You have completed Find Your Path.\nWant to go home?'
        : 'You found all 5 hidden treasures.';

    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 400),
      child: Stack(
        children: [
          // Semi-transparent backdrop
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.7),
            ),
          ),
          
          // Centered Card
          Center(
            child: Container(
              width: screenWidth * 0.8,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2520),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    titleText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Color(0x88E8C46A),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Subtitle
                  Text(
                    subtitleText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Buttons
                  // Button 1: Try Again
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: widget.onTryAgain,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8C46A),
                        foregroundColor: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  // Button 2: Next Level (only if onNextLevel != null)
                  if (widget.onNextLevel != null) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: widget.onNextLevel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8C46A),
                          foregroundColor: const Color(0xFF1A1A1A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Next Level',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 12),
                  
                  // Button 3: Home
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: widget.onHome,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFE8C46A),
                          width: 1.5,
                        ),
                        foregroundColor: const Color(0xFFE8C46A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      child: const Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
