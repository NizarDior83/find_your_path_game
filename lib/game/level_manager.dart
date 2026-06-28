const int kTotalLevels = 5;

String getBackgroundAssetForLevel(int levelNumber) {
  return 'assets/images/level${levelNumber}_bg.png';
}

bool hasNextLevel(int currentLevel) => currentLevel < kTotalLevels;

const Map<int, String> _levelNames = {
  1: "The Explorer's Study",
  2: "The Alchemist's Laboratory",
  3: "The Overgrown Trolley Depot",
  4: "The Elegant Vintage Bedroom",
  5: "The Enchanted Woodland Clearing",
};

String getLevelNameForLevel(int n) {
  return _levelNames[n] ?? 'Level $n';
}

String getLevelIconForLevel(int n) {
  return 'assets/images/icon_level_$n.png';
}
