import 'package:flutter/material.dart';
import '../game/object_data.dart';

class BottomPanel extends StatelessWidget {
  final List<HiddenObject> objects;
  final Set<String> foundIds;
  final int livesRemaining;
  final VoidCallback onHintPressed;
  final VoidCallback onHomePressed;
  final List<GlobalKey> slotKeys;

  const BottomPanel({
    super.key,
    required this.objects,
    required this.foundIds,
    required this.livesRemaining,
    required this.onHintPressed,
    required this.onHomePressed,
    required this.slotKeys,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
      ),
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/ui_panel.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top row: inventory slots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(objects.length, (index) {
                    final obj = objects[index];
                    final isFound = foundIds.contains(obj.id);
                    
                    return Padding(
                      padding: EdgeInsets.only(
                          right: index < objects.length - 1 ? 8.0 : 0.0),
                      child: Container(
                        key: slotKeys[index],
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1.0,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: isFound ? 1.0 : 0.4,
                              child: Image.asset(
                                obj.thumbnailPath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const SizedBox.shrink(),
                              ),
                            ),
                            if (isFound)
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Image.asset(
                                  'assets/images/icon_found_checkmark.png',
                                  width: 16,
                                  height: 16,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const SizedBox.shrink(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                
                // Bottom row: home, counter, lives, hint
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Far left: Home button
                    GestureDetector(
                      onTap: onHomePressed,
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: Image.asset(
                          'assets/images/icon_home.png',
                          width: 32,
                          height: 32,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.home, color: Colors.white, size: 24),
                        ),
                      ),
                    ),

                    // Counter
                    Text(
                      '${foundIds.length} / ${objects.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    // Center: Lives
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        final isAlive = index < livesRemaining;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Opacity(
                            opacity: isAlive ? 1.0 : 0.25,
                            child: Image.asset(
                              'assets/images/icon_heart.png',
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox.shrink(),
                            ),
                          ),
                        );
                      }),
                    ),
                    
                    // Right side: Hint button
                    GestureDetector(
                      onTap: onHintPressed,
                      child: Image.asset(
                        'assets/images/icon_hint.png',
                        width: 32,
                        height: 32,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
