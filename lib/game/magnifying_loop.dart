import 'package:flutter/material.dart';

/// A pure visual widget representing a magnifying loop cursor.
class MagnifyingLoop extends StatelessWidget {
  final Offset position;

  const MagnifyingLoop({
    super.key,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    // The image is 80x80. Center it precisely over the pointer position.
    return Positioned(
      left: position.dx - 40,
      top: position.dy - 40,
      child: IgnorePointer(
        child: Image.asset(
          'assets/images/icon_loop.png',
          width: 80,
          height: 80,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
