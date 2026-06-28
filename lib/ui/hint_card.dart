import 'package:flutter/material.dart';

class HintCard extends StatelessWidget {
  final String quote;
  final VoidCallback onClose;

  const HintCard({
    super.key,
    required this.quote,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Stack(
            children: [
              // Semi-transparent backdrop — tap outside dismisses
              Positioned.fill(
                child: GestureDetector(
                  onTap: onClose,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ),

              // Centered Card
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {}, // Absorb taps so card doesn't close
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
                        // Top row: close button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: onClose,
                              icon: Icon(
                                Icons.close,
                                size: 24,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        
                        // Center: quote Text
                        const Icon(
                          Icons.format_quote,
                          size: 32,
                          color: Color(0x66E8C46A), // #E8C46A at 40%
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            quote,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.95),
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
