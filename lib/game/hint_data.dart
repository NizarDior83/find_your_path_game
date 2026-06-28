import 'dart:math';

const Map<int, List<String>> _hintsByLevel = {
  1: [
    "What is hidden in plain sight reveals itself only to the patient eye.",
    "Every great discovery begins with a question no one else thought to ask.",
    "The bones of giants teach us that even the mightiest were once small.",
    "Maps show where we have been — wonder shows where we might go.",
    "To find what is lost, first lose yourself in looking.",
  ],
  2: [
    "To change lead into gold, one must first change oneself.",
    "The most powerful potion is the one brewed slowly, with intention.",
    "Magic is simply what science has not yet learned to explain.",
    "Every herb knows its purpose — do you know yours?",
    "The crystal does not predict the future — it reflects what you already know.",
  ],
  3: [
    "What we build, the earth eventually borrows back.",
    "Rust is iron's memory of the rain.",
    "A pocket watch counts the seconds — moss counts the seasons.",
    "The journey forgotten is the journey most deeply taken.",
    "Every lantern dims, but the light it once held remains.",
  ],
  4: [
    "Mirrors show only the surface — true reflection happens inward.",
    "Beauty fades, but the kindness we wore each day remains.",
    "Every pearl began as something the oyster tried to forget.",
    "A perfume bottle holds memory more faithfully than any photograph.",
    "The vanity is not in being seen — it is in fearing being unseen.",
  ],
  5: [
    "Listen — the forest speaks to those who learn its silence.",
    "A single acorn carries the patience of a thousand oaks.",
    "The moth seeks the light it can never reach — and is beautiful for trying.",
    "Magic lives in the dewdrop just as much as in the dragon.",
    "At the end of every path, you find the self you began with — but now you know it.",
  ],
};

final _random = Random();
final Map<int, List<int>> _queueByLevel = {};

String getRandomHintForLevel(int levelNumber) {
  final hints = _hintsByLevel[levelNumber];
  if (hints == null || hints.isEmpty) {
    return "Sometimes the best hint is just to keep looking.";
  }

  // Refill and shuffle the queue if empty
  if (_queueByLevel[levelNumber] == null || _queueByLevel[levelNumber]!.isEmpty) {
    final newQueue = List<int>.generate(hints.length, (i) => i);
    newQueue.shuffle(_random);
    _queueByLevel[levelNumber] = newQueue;
  }

  // Remove and return the first index
  final nextIndex = _queueByLevel[levelNumber]!.removeAt(0);
  return hints[nextIndex];
}
