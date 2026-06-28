import 'package:shared_preferences/shared_preferences.dart';

class ProgressManager {
  ProgressManager._privateConstructor();
  static final ProgressManager instance = ProgressManager._privateConstructor();

  final Set<int> _completedLevels = {};
  static const String _storageKey = 'completed_levels';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final storedList = prefs.getStringList(_storageKey);
    if (storedList != null) {
      _completedLevels.clear();
      _completedLevels.addAll(storedList.map((e) => int.parse(e)));
    }
  }

  bool isLevelCompleted(int n) => _completedLevels.contains(n);

  bool isLevelUnlocked(int n) {
    if (n == 1) return true;
    return isLevelCompleted(n - 1);
  }

  Future<void> markLevelCompleted(int n) async {
    _completedLevels.add(n);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey, 
      _completedLevels.map((e) => e.toString()).toList(),
    );
  }
}
