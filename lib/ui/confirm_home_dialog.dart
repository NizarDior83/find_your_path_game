import 'package:flutter/material.dart';

/// Modal confirmation dialog for returning to the Level Select menu.
///
/// Uses the Stack-overlay pattern (not showDialog) for visual consistency
/// with other game overlays.
class ConfirmHomeDialog extends StatefulWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmHomeDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<ConfirmHomeDialog> createState() => _ConfirmHomeDialogState();
}

class _ConfirmHomeDialogState extends State<ConfirmHomeDialog> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Trigger fade-in on next frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _opacity = 1.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 250),
      child: Stack(
        children: [
          // Semi-transparent backdrop — tap outside dismisses
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.onCancel,
              child: Container(
                color: Colors.black.withValues(alpha: 0.7),
              ),
            ),
          ),

          // Centered card
          Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {}, // Absorb taps on the card body
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
                    const Text(
                      'Return to Menu?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Body
                    Text(
                      'Are you sure? Your progress in this level will be lost.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      children: [
                        // Cancel button (outline)
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: OutlinedButton(
                              onPressed: widget.onCancel,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFFE8C46A),
                                  width: 1.5,
                                ),
                                foregroundColor: const Color(0xFFE8C46A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Confirm button (filled)
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: widget.onConfirm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE8C46A),
                                foregroundColor: const Color(0xFF1A1A1A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Return to Menu',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
