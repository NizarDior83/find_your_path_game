import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;

import '../ui/bottom_panel.dart';
import '../ui/confirm_home_dialog.dart';
import '../ui/hint_card.dart';

import '../ui/level_select_screen.dart';
import 'object_data.dart';
import 'hint_data.dart';
import 'progress_manager.dart';
import 'audio_manager.dart';
import 'level_manager.dart';
import 'magic_move_controller.dart';
import 'magnifying_loop.dart';
import '../ui/level_complete_screen.dart';
import '../ui/lose_screen.dart';

class GameScreen extends StatefulWidget {
  final int levelNumber;
  const GameScreen({super.key, this.levelNumber = 1});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final TransformationController _transformController = TransformationController();
  final MagicMoveController _magicMove = MagicMoveController();
  final GlobalKey _interactiveViewerKey = GlobalKey();
  
  // GlobalKeys to track the positions of inventory slots (one per object)
  late final List<GlobalKey> _slotKeys;
  
  // Track found objects and temporarily hidden objects (while flying)
  final Set<String> _foundIds = {};
  final Set<String> _hiddenIds = {};

  int _livesRemaining = 3;
  Offset? _cursorPosition;
  
  double _canvasWidth = 0;
  double _canvasHeight = 0;

  // Sparkle state
  bool _showSparkle = false;
  Offset? _sparklePos;

  // Home confirmation dialog state
  bool _showHomeConfirm = false;

  // Hint state
  bool _showHintCard = false;
  String? _currentHintQuote;

  // Animation controller for the flying Magic Move
  late final AnimationController _magicMoveController;

  List<HiddenObject> get _currentLevelObjects => getObjectsForLevel(widget.levelNumber);

  bool get _isWin =>
      _currentLevelObjects.isNotEmpty &&
      _foundIds.length == _currentLevelObjects.length;
  bool get _isLose => _livesRemaining == 0;
  bool get _isGameOver => _isWin || _isLose;

  Future<void> _resetGame() async {
    _magicMoveController.reset();
    _magicMove.endAnimation();
    setState(() {
      _foundIds.clear();
      _hiddenIds.clear();
      _livesRemaining = 3;
      _showSparkle = false;
      _cursorPosition = null;
      _transformController.value = Matrix4.identity();
    });
    
    await AudioManager.instance.stopMusic();
    await AudioManager.instance.playMusic(AudioManager.gameplayMusic, loop: true);
  }

  @override
  void initState() {
    super.initState();
    _slotKeys = List.generate(_currentLevelObjects.length, (_) => GlobalKey());
    _magicMoveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _magicMoveController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        final id = _magicMove.objectId;
        if (id != null) {
          setState(() {
            _foundIds.add(id);
          });
        }
        AudioManager.instance.playEffect(AudioManager.sfxWin);
        _magicMove.endAnimation();

        if (_isWin) {
          await AudioManager.instance.stopMusic();
          AudioManager.instance.playEffect(AudioManager.sfxLevelComplete);
          await ProgressManager.instance.markLevelCompleted(widget.levelNumber);
        }

        // Force rebuild to remove flying sprite
        if (mounted) {
          setState(() {});
        }
      }
    });

    AudioManager.instance.stopMusic().then((_) {
      AudioManager.instance.playMusic(AudioManager.gameplayMusic, loop: true);
    });
  }

  @override
  void dispose() {
    _transformController.dispose();
    _magicMoveController.dispose();
    _magicMove.dispose();
    super.dispose();
  }



  void _onObjectTapped(HiddenObject obj) {
    // Guard against multiple taps or animating state
    if (_isGameOver || _foundIds.contains(obj.id) || _hiddenIds.contains(obj.id) || _magicMove.isAnimating) {
      return;
    }

    final index = _currentLevelObjects.indexOf(obj);
    if (index == -1) return;

    // 1. Target slot position in screen space
    final slotContext = _slotKeys[index].currentContext;
    final ivRenderBox = _interactiveViewerKey.currentContext?.findRenderObject() as RenderBox?;
    if (slotContext == null || ivRenderBox == null) return;

    final slotBox = slotContext.findRenderObject() as RenderBox?;
    if (slotBox == null) return;
    
    // Center of the 48x48 inventory slot
    final endPos = slotBox.localToGlobal(const Offset(24, 24));

    // 2. Start position using TransformationController (matrix)
    final localX = obj.xPercent * _canvasWidth;
    final localY = obj.yPercent * _canvasHeight;
    final localPoint = vmath.Vector3(localX, localY, 0);
    
    final transformedPoint = _transformController.value.transform3(localPoint);
    final startPos = ivRenderBox.localToGlobal(Offset(transformedPoint.x, transformedPoint.y));

    // Hide original sprite, show sparkle, start magic move
    setState(() {
      _hiddenIds.add(obj.id);
      _showSparkle = true;
      _sparklePos = startPos;
    });

    AudioManager.instance.playEffect(AudioManager.sfxSpriteTap);
    Future.delayed(
      const Duration(milliseconds: 150),
      () => AudioManager.instance.playEffect(AudioManager.sfxSparkle),
    );

    _magicMove.startAnimation(
      objectId: obj.id,
      startPosition: startPos,
      endPosition: endPos,
    );
    
    _magicMoveController.forward(from: 0.0);

    // Stop sparkle after 600ms
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _showSparkle = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Base Layer: 80/20 Layout ──────────────────────────────────────
          Column(
            children: [
              // Top 80%: Interactive canvas with pointer tracking
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    InteractiveViewer(
                      key: _interactiveViewerKey,
                      transformationController: _transformController,
                      minScale: 1.0,
                      maxScale: 3.0,
                      boundaryMargin: EdgeInsets.zero,
                      constrained: true,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          _canvasWidth = constraints.maxWidth;
                          _canvasHeight = constraints.maxHeight;
                          return Stack(
                            children: [
                              // Background fills the full canvas
                              GestureDetector(
                                  onTap: () async {
                                    if (_livesRemaining > 0 && !_isGameOver) {
                                      if (_livesRemaining == 1) {
                                        await AudioManager.instance.stopMusic();
                                        AudioManager.instance.playEffect(AudioManager.sfxLose);
                                        setState(() {
                                          _livesRemaining--;
                                        });
                                      } else {
                                        AudioManager.instance.playEffect(AudioManager.sfxLose);
                                        setState(() {
                                          _livesRemaining--;
                                        });
                                      }
                                    }
                                  },
                                child: Image.asset(
                                  getBackgroundAssetForLevel(widget.levelNumber),
                                  fit: BoxFit.cover,
                                  width: _canvasWidth,
                                  height: _canvasHeight,
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint('[GameScreen] ${getBackgroundAssetForLevel(widget.levelNumber)} missing.');
                                    return Container(
                                      color: const Color(0xFF1A1A1A),
                                      width: _canvasWidth,
                                      height: _canvasHeight,
                                    );
                                  },
                                ),
                              ),
                              // Hidden object sprites
                              for (final obj in _currentLevelObjects)
                                _buildSprite(obj),
                            ],
                          );
                        },
                      ),
                    ),
                    Positioned.fill(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.none,
                        opaque: false,
                        onEnter: (e) => setState(() => _cursorPosition = e.position),
                        onHover: (e) => setState(() => _cursorPosition = e.position),
                        onExit: (_) => setState(() => _cursorPosition = null),
                        child: Listener(
                          behavior: HitTestBehavior.translucent,
                          onPointerHover: (e) => setState(() => _cursorPosition = e.position),
                          onPointerDown: (e) => setState(() => _cursorPosition = e.position),
                          onPointerMove: (e) => setState(() => _cursorPosition = e.position),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom 20%: Panel
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: BottomPanel(
                  objects: _currentLevelObjects,
                  foundIds: _foundIds,
                  livesRemaining: _livesRemaining,
                  slotKeys: _slotKeys,
                  onHintPressed: () {
                    setState(() {
                      _currentHintQuote = getRandomHintForLevel(widget.levelNumber);
                      _showHintCard = true;
                    });
                  },
                  onHomePressed: () => setState(() => _showHomeConfirm = true),
                ),
              ),
            ],
          ),

          // ── Overlay: Magnifying Loop Cursor ───────────────────────────────
          if (_cursorPosition != null && !_isGameOver)
            MagnifyingLoop(position: _cursorPosition!),

          // ── Overlay: Sparkle Effect ───────────────────────────────────────
          if (_showSparkle && _sparklePos != null)
            Positioned(
              left: _sparklePos!.dx - 50,
              top: _sparklePos!.dy - 50,
              width: 100,
              height: 100,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/images/sparkle_effect.gif',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
            ),

          // ── Overlay: Magic Move (Flying Sprite) ───────────────────────────
          if (_magicMove.isAnimating && _magicMove.objectId != null)
            AnimatedBuilder(
              animation: _magicMoveController,
              builder: (context, child) {
                final progress = Curves.easeInOutCubic.transform(_magicMoveController.value);
                final currentPos = Offset.lerp(
                  _magicMove.startPosition!,
                  _magicMove.endPosition!,
                  progress,
                )!;
                
                final obj = _currentLevelObjects.firstWhere((o) => o.id == _magicMove.objectId);
                
                final startSize = obj.widthPercent * _canvasWidth;
                const endSize = 48.0;
                final currentSize = startSize + (endSize - startSize) * progress;

                return Positioned(
                  left: currentPos.dx - (currentSize / 2),
                  top: currentPos.dy - (currentSize / 2),
                  width: currentSize,
                  height: currentSize,
                  child: IgnorePointer(
                    child: Image.asset(
                      obj.assetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ),
                );
              },
            ),
            
          // ── Overlays: Win/Lose Screens ─────────────────────────────────────
          if (_isWin)
            Positioned.fill(
              child: LevelCompleteScreen(
                levelNumber: widget.levelNumber,
                onTryAgain: _resetGame,
                onNextLevel: hasNextLevel(widget.levelNumber)
                    ? () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GameScreen(
                              levelNumber: widget.levelNumber + 1,
                            ),
                          ),
                        );
                      }
                    : null,
                onHome: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LevelSelectScreen(),
                    ),
                  );
                },
              ),
            ),
          if (_isLose)
            Positioned.fill(
              child: LoseScreen(
                onTryAgain: _resetGame,
              ),
            ),

          // ── Overlay: Home Confirmation Dialog (topmost) ────────────────────
          if (_showHomeConfirm)
            Positioned.fill(
              child: ConfirmHomeDialog(
                onCancel: () => setState(() => _showHomeConfirm = false),
                onConfirm: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LevelSelectScreen()),
                  );
                },
              ),
            ),

          // ── Overlay: Hint Card (topmost) ───────────────────────────────────
          if (_showHintCard && _currentHintQuote != null)
            Positioned.fill(
              child: HintCard(
                quote: _currentHintQuote!,
                onClose: () {
                  setState(() {
                    _showHintCard = false;
                    _currentHintQuote = null;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSprite(HiddenObject obj) {
    if (_foundIds.contains(obj.id) || _hiddenIds.contains(obj.id)) {
      return const SizedBox.shrink();
    }

    final left = obj.xPercent * _canvasWidth;
    final top = obj.yPercent * _canvasHeight;
    final spriteWidth = obj.widthPercent * _canvasWidth;

    return Positioned(
      left: left,
      top: top,
      width: spriteWidth,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: GestureDetector(
          onTap: () => _onObjectTapped(obj),
          child: Image.asset(
            obj.assetPath,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('[GameScreen] Sprite ${obj.id} missing.');
              return SizedBox(width: spriteWidth, height: spriteWidth);
            },
          ),
        ),
      ),
    );
  }
}
