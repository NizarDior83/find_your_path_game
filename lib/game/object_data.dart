import 'package:flutter/foundation.dart';

/// Immutable data class describing a single hidden object in a level.
@immutable
class HiddenObject {
  /// Unique identifier — used as a map key and for debug logging.
  final String id;

  /// Human-readable display name (shown in future "found!" toast).
  final String name;

  /// Flutter asset path for the transparent-PNG sprite.
  final String assetPath;

  /// Horizontal position as a fraction of the canvas width (0.0 = left, 1.0 = right).
  final double xPercent;

  /// Vertical position as a fraction of the canvas height (0.0 = top, 1.0 = bottom).
  final double yPercent;

  /// Sprite render width as a fraction of the canvas width.
  final double widthPercent;

  /// Flutter asset path for the greyed-out and full-opacity thumbnail.
  final String thumbnailPath;

  const HiddenObject({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.xPercent,
    required this.yPercent,
    required this.widthPercent,
    required this.thumbnailPath,
  });
}

const Map<int, List<HiddenObject>> kLevelObjects = {
  1: [
    HiddenObject(
      id: 'boomerang',
      name: 'Boomerang',
      assetPath: 'assets/images/sprite_boomerang.png',
      xPercent: 0.305,
      yPercent: 0.404,
      widthPercent: 0.20,
      thumbnailPath: 'assets/images/thumb_boomerang.png',
    ),
    HiddenObject(
      id: 'scarab',
      name: 'Scarab Beetle',
      assetPath: 'assets/images/sprite_scarab.png',
      xPercent: 0.878,
      yPercent: 0.105,
      widthPercent: 0.16,
      thumbnailPath: 'assets/images/thumb_scarab.png',
    ),
    HiddenObject(
      id: 'quill',
      name: 'Quill',
      assetPath: 'assets/images/sprite_quill.png',
      xPercent: 0.313,
      yPercent: 0.720,
      widthPercent: 0.16,
      thumbnailPath: 'assets/images/thumb_quill.png',
    ),
    HiddenObject(
      id: 'key',
      name: 'Antique Key',
      assetPath: 'assets/images/sprite_key.png',
      xPercent: 0.232,
      yPercent: 0.220,
      widthPercent: 0.14,
      thumbnailPath: 'assets/images/thumb_key.png',
    ),
    HiddenObject(
      id: 'gecko',
      name: 'Gecko',
      assetPath: 'assets/images/sprite_gecko.png',
      xPercent: 0.091,
      yPercent: 0.448,
      widthPercent: 0.16,
      thumbnailPath: 'assets/images/thumb_gecko.png',
    ),
  ],
  2: [
    HiddenObject(
      id: 'potion',
      name: 'Teardrop Potion Bottle',
      assetPath: 'assets/images/sprite_potion.png',
      xPercent: 0.25,
      yPercent: 0.40,
      widthPercent: 0.08,
      thumbnailPath: 'assets/images/thumb_potion.png',
    ),
    HiddenObject(
      id: 'crystal',
      name: 'Swirling Crystal Ball',
      assetPath: 'assets/images/sprite_crystal.png',
      xPercent: 0.65,
      yPercent: 0.30,
      widthPercent: 0.10,
      thumbnailPath: 'assets/images/thumb_crystal.png',
    ),
    HiddenObject(
      id: 'mortar',
      name: 'Mortar and Glowing Pestle',
      assetPath: 'assets/images/sprite_mortar.png',
      xPercent: 0.45,
      yPercent: 0.65,
      widthPercent: 0.10,
      thumbnailPath: 'assets/images/thumb_mortar.png',
    ),
    HiddenObject(
      id: 'herbs',
      name: 'Bundle of Magical Herbs',
      assetPath: 'assets/images/sprite_herbs.png',
      xPercent: 0.15,
      yPercent: 0.55,
      widthPercent: 0.08,
      thumbnailPath: 'assets/images/thumb_herbs.png',
    ),
    HiddenObject(
      id: 'hat',
      name: 'Floppy Witch\'s Hat',
      assetPath: 'assets/images/sprite_hat.png',
      xPercent: 0.75,
      yPercent: 0.50,
      widthPercent: 0.10,
      thumbnailPath: 'assets/images/thumb_hat.png',
    ),
  ],
  3: [
    HiddenObject(
      id: 'conductor_hat',
      name: 'Vintage Conductor\'s Hat',
      assetPath: 'assets/images/sprite_conductor_hat.png',
      xPercent: 0.20,
      yPercent: 0.30,
      widthPercent: 0.10,
      thumbnailPath: 'assets/images/thumb_conductor_hat.png',
    ),
    HiddenObject(
      id: 'bell',
      name: 'Antique Brass Trolley Bell',
      assetPath: 'assets/images/sprite_bell.png',
      xPercent: 0.70,
      yPercent: 0.25,
      widthPercent: 0.08,
      thumbnailPath: 'assets/images/thumb_bell.png',
    ),
    HiddenObject(
      id: 'pocket_watch',
      name: 'Golden Pocket Watch',
      assetPath: 'assets/images/sprite_pocket_watch.png',
      xPercent: 0.40,
      yPercent: 0.55,
      widthPercent: 0.06,
      thumbnailPath: 'assets/images/thumb_pocket_watch.png',
    ),
    HiddenObject(
      id: 'satchel',
      name: 'Weathered Traveler\'s Satchel',
      assetPath: 'assets/images/sprite_satchel.png',
      xPercent: 0.30,
      yPercent: 0.75,
      widthPercent: 0.12,
      thumbnailPath: 'assets/images/thumb_satchel.png',
    ),
    HiddenObject(
      id: 'lantern',
      name: 'Rusty Iron Lantern',
      assetPath: 'assets/images/sprite_lantern.png',
      xPercent: 0.80,
      yPercent: 0.65,
      widthPercent: 0.08,
      thumbnailPath: 'assets/images/thumb_lantern.png',
    ),
  ],
  4: [
    HiddenObject(
      id: 'perfume',
      name: 'Jeweled Perfume Bottle',
      assetPath: 'assets/images/sprite_perfume.png',
      xPercent: 0.55,
      yPercent: 0.40,
      widthPercent: 0.07,
      thumbnailPath: 'assets/images/thumb_perfume.png',
    ),
    HiddenObject(
      id: 'mirror',
      name: 'Antique Hand Mirror',
      assetPath: 'assets/images/sprite_mirror.png',
      xPercent: 0.20,
      yPercent: 0.50,
      widthPercent: 0.10,
      thumbnailPath: 'assets/images/thumb_mirror.png',
    ),
    HiddenObject(
      id: 'necklace',
      name: 'Pearl and Ruby Necklace',
      assetPath: 'assets/images/sprite_necklace.png',
      xPercent: 0.65,
      yPercent: 0.65,
      widthPercent: 0.10,
      thumbnailPath: 'assets/images/thumb_necklace.png',
    ),
    HiddenObject(
      id: 'bow',
      name: 'Cobalt Velvet Hair Bow',
      assetPath: 'assets/images/sprite_bow.png',
      xPercent: 0.35,
      yPercent: 0.35,
      widthPercent: 0.07,
      thumbnailPath: 'assets/images/thumb_bow.png',
    ),
    HiddenObject(
      id: 'compact',
      name: 'Open Powder Compact',
      assetPath: 'assets/images/sprite_compact.png',
      xPercent: 0.75,
      yPercent: 0.55,
      widthPercent: 0.08,
      thumbnailPath: 'assets/images/thumb_compact.png',
    ),
  ],
  5: [
    HiddenObject(
      id: 'acorn',
      name: 'Glowing Golden Acorn',
      assetPath: 'assets/images/sprite_acorn.png',
      xPercent: 0.30,
      yPercent: 0.55,
      widthPercent: 0.06,
      thumbnailPath: 'assets/images/thumb_acorn.png',
    ),
    HiddenObject(
      id: 'flute',
      name: 'Carved Fairy Flute',
      assetPath: 'assets/images/sprite_flute.png',
      xPercent: 0.70,
      yPercent: 0.45,
      widthPercent: 0.10,
      thumbnailPath: 'assets/images/thumb_flute.png',
    ),
    HiddenObject(
      id: 'leaf_cup',
      name: 'Dewdrop Leaf Cup',
      assetPath: 'assets/images/sprite_leaf_cup.png',
      xPercent: 0.15,
      yPercent: 0.70,
      widthPercent: 0.08,
      thumbnailPath: 'assets/images/thumb_leaf_cup.png',
    ),
    HiddenObject(
      id: 'snail',
      name: 'Swirling Magenta Snail Shell',
      assetPath: 'assets/images/sprite_snail.png',
      xPercent: 0.50,
      yPercent: 0.75,
      widthPercent: 0.07,
      thumbnailPath: 'assets/images/thumb_snail.png',
    ),
    HiddenObject(
      id: 'moth',
      name: 'Jewel-Toned Luna Moth',
      assetPath: 'assets/images/sprite_moth.png',
      xPercent: 0.60,
      yPercent: 0.25,
      widthPercent: 0.10,
      thumbnailPath: 'assets/images/thumb_moth.png',
    ),
  ],
};

List<HiddenObject> getObjectsForLevel(int levelNumber) {
  return kLevelObjects[levelNumber] ?? [];
}
