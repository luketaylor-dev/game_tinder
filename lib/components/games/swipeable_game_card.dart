import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/game.dart';
import 'game_card.dart';

/// A swipeable game card that handles swipe gestures
/// Similar to Tinder's swipeable cards
class SwipeableGameCard extends ConsumerStatefulWidget {
  final GameTinderGame game;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onTap;

  const SwipeableGameCard({
    super.key,
    required this.game,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUp,
    this.onTap,
  });

  @override
  ConsumerState<SwipeableGameCard> createState() => _SwipeableGameCardState();
}

class _SwipeableGameCardState extends ConsumerState<SwipeableGameCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _rotationAnimation;

  double _dragStartX = 0;
  bool _isDragging = false;
  double _currentOffset = 0;
  double _currentRotation = 0;
  double _lastOffset = 0;
  double _lastRotation = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200), // Faster animation
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Use animation values when animating, current values when dragging
        final offset = _isDragging ? _currentOffset : _animation.value;
        final rotation = _isDragging
            ? _currentRotation
            : _rotationAnimation.value;

        return ClipRect(
          child: Transform.translate(
            offset: Offset(offset, 0),
            child: Transform.rotate(
              angle: rotation,
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: Stack(
                  children: [
                    // Main game card - use RepaintBoundary to prevent unnecessary repaints
                    RepaintBoundary(
                      child: GameCard(game: widget.game, onTap: widget.onTap),
                    ),

                    // Swipe feedback overlays
                    if (_isDragging) _buildSwipeFeedback(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onPanStart(DragStartDetails details) {
    _dragStartX = details.localPosition.dx;
    _isDragging = true;
    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final deltaX = details.localPosition.dx - _dragStartX;

    // Update current values
    _currentOffset = deltaX;
    _currentRotation = (deltaX * 0.01).clamp(
      -0.2,
      0.2,
    ); // Limit rotation to prevent excessive spinning

    // Only call setState if the values actually changed significantly
    // Increased threshold to reduce jitter
    if ((_currentOffset - _lastOffset).abs() > 2.0 ||
        (_currentRotation - _lastRotation).abs() > 0.02) {
      _lastOffset = _currentOffset;
      _lastRotation = _currentRotation;
      setState(() {});
    }
  }

  void _onPanEnd(DragEndDetails details) {
    _isDragging = false;

    final velocity = details.velocity.pixelsPerSecond.dx;
    final dragDistance = _currentOffset;

    // Determine swipe direction and threshold
    const swipeThreshold = 100.0;
    const velocityThreshold = 500.0;

    if (dragDistance.abs() > swipeThreshold ||
        velocity.abs() > velocityThreshold) {
      if (dragDistance > 0 || velocity > 0) {
        // Swipe right (like)
        _animateSwipeRight();
      } else {
        // Swipe left (dislike)
        _animateSwipeLeft();
      }
    } else if (details.velocity.pixelsPerSecond.dy < -velocityThreshold) {
      // Swipe up (skip)
      _animateSwipeUp();
    } else {
      // Return to center
      _animateToCenter();
    }

    setState(() {});
  }

  void _animateSwipeRight() {
    _animationController.reset();
    _animation =
        Tween<double>(
          begin: _currentOffset,
          end:
              MediaQuery.of(context).size.width *
              2.0, // Go completely off-screen
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
        );

    _rotationAnimation = Tween<double>(begin: _currentRotation, end: 0.3)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
        );

    _animationController.forward().then((_) {
      // Add a small delay to ensure the card is completely off-screen
      Future.delayed(const Duration(milliseconds: 50), () {
        widget.onSwipeRight?.call();
      });
    });
  }

  void _animateSwipeLeft() {
    _animationController.reset();
    _animation =
        Tween<double>(
          begin: _currentOffset,
          end:
              -MediaQuery.of(context).size.width *
              2.0, // Go completely off-screen
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
        );

    _rotationAnimation = Tween<double>(begin: _currentRotation, end: -0.3)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
        );

    _animationController.forward().then((_) {
      // Add a small delay to ensure the card is completely off-screen
      Future.delayed(const Duration(milliseconds: 50), () {
        widget.onSwipeLeft?.call();
      });
    });
  }

  void _animateSwipeUp() {
    _animationController.reset();
    _animation = Tween<double>(begin: _currentOffset, end: _currentOffset)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _rotationAnimation = Tween<double>(begin: _currentRotation, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Animate upward movement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward().then((_) {
        // This would need a separate animation for Y movement
        widget.onSwipeUp?.call();
      });
    });
  }

  void _animateToCenter() {
    // Reset animation controller
    _animationController.reset();

    // Animate back to center
    _animation = Tween<double>(begin: _currentOffset, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: _currentRotation, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  Widget _buildSwipeFeedback() {
    final dragDistance = _currentOffset;
    final screenWidth = MediaQuery.of(context).size.width;

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            // Like feedback (green overlay when swiping right)
            if (dragDistance > 0)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.green.withOpacity(
                    (dragDistance / screenWidth * 0.5).clamp(0.0, 0.5),
                  ),
                ),
                child: Center(
                  child: Opacity(
                    opacity: (dragDistance / screenWidth * 2).clamp(0.0, 1.0),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
              ),

            // Dislike feedback (red overlay when swiping left)
            if (dragDistance < 0)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red.withOpacity(
                    (dragDistance.abs() / screenWidth * 0.5).clamp(0.0, 0.5),
                  ),
                ),
                child: Center(
                  child: Opacity(
                    opacity: (dragDistance.abs() / screenWidth * 2).clamp(
                      0.0,
                      1.0,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
