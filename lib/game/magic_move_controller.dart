import 'package:flutter/material.dart';

/// A pure data class that holds the state for the Magic Move animation.
class MagicMoveController extends ChangeNotifier {
  bool _isAnimating = false;
  String? _objectId;
  Offset? _startPosition;
  Offset? _endPosition;

  bool get isAnimating => _isAnimating;
  String? get objectId => _objectId;
  Offset? get startPosition => _startPosition;
  Offset? get endPosition => _endPosition;

  void startAnimation({
    required String objectId,
    required Offset startPosition,
    required Offset endPosition,
  }) {
    _isAnimating = true;
    _objectId = objectId;
    _startPosition = startPosition;
    _endPosition = endPosition;
    notifyListeners();
  }

  void endAnimation() {
    _isAnimating = false;
    _objectId = null;
    _startPosition = null;
    _endPosition = null;
    notifyListeners();
  }
}
