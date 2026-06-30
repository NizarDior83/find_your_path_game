import 'package:flutter/material.dart';

class LoseScreen extends StatelessWidget {
  final VoidCallback onTryAgain;

  const LoseScreen({
    super.key,
    required this.onTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO(assets): Replace this Color with an Image.asset(...) for the Lose background
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TODO(assets): Replace this Text with a stylized Lose Graphic/Sprite
            const Text(
              'OUT OF LIVES',
              style: TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 29,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onTryAgain,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                textStyle: const TextStyle(fontFamily: 'Cinzel', fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: const Text('TRY AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
