import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';
import '../models/swipe_file.dart';
import 'swipe_card.dart';

/// Callback when a card is swiped
typedef OnSwipe = void Function(SwipeDirection direction);

/// Swipe direction
enum SwipeDirection { left, right }

/// Stack of swipeable cards with gesture detection
class SwipeStack extends StatefulWidget {
  final List<SwipeFile> files;
  final int currentIndex;
  final OnSwipe onSwipe;
  final int visibleCards;

  const SwipeStack({
    super.key,
    required this.files,
    required this.currentIndex,
    required this.onSwipe,
    this.visibleCards = 3,
  });

  @override
  State<SwipeStack> createState() => SwipeStackState();
}

class SwipeStackState extends State<SwipeStack>
    with SingleTickerProviderStateMixin {
  // Animation
  late AnimationController _controller;
  late Animation<Offset> _position;
  late Animation<double> _rotation;
  late Animation<double> _scale;

  // Drag state
  Offset _dragStart = Offset.zero;
  Offset _dragPosition = Offset.zero;
  bool _isDragging = false;
  bool _thresholdCrossed = false;

  // Constants
  static const double _swipeThreshold = 100.0;
  static const double _maxRotation = 15.0; // degrees
  static const double _velocityThreshold = 1000.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.animationNormal,
      vsync: this,
    );
    _resetAnimations();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetAnimations() {
    _position = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    _rotation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(_controller);
  }

  /// Programmatic swipe (from button press)
  void swipe(SwipeDirection direction) {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetX = direction == SwipeDirection.left
        ? -screenWidth * 1.5
        : screenWidth * 1.5;

    setState(() {
      _position = Tween<Offset>(
        begin: _dragPosition,
        end: Offset(targetX, 0),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _rotation = Tween<double>(
        begin: _calculateRotation(_dragPosition.dx),
        end: direction == SwipeDirection.left ? -_maxRotation : _maxRotation,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
    });

    Haptics.medium();
    _controller.forward().then((_) {
      widget.onSwipe(direction);
      _resetState();
    });
  }

  void _resetState() {
    _controller.reset();
    setState(() {
      _dragPosition = Offset.zero;
      _isDragging = false;
      _thresholdCrossed = false;
    });
    _resetAnimations();
  }

  double _calculateRotation(double dragX) {
    final screenWidth = MediaQuery.of(context).size.width;
    final normalizedX = (dragX / screenWidth).clamp(-1.0, 1.0);
    return normalizedX * _maxRotation;
  }

  void _onPanStart(DragStartDetails details) {
    _controller.stop();
    setState(() {
      _dragStart = details.localPosition;
      _isDragging = true;
      _thresholdCrossed = false;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition = Offset(
        details.localPosition.dx - _dragStart.dx,
        (details.localPosition.dy - _dragStart.dy) * 0.3, // Dampen vertical
      );
    });

    // Check threshold crossing
    final crossedNow = _dragPosition.dx.abs() > _swipeThreshold;
    if (crossedNow && !_thresholdCrossed) {
      _thresholdCrossed = true;
      Haptics.light();
    } else if (!crossedNow && _thresholdCrossed) {
      _thresholdCrossed = false;
    }
  }

  void _onPanEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dx;
    final shouldSwipe = _dragPosition.dx.abs() > _swipeThreshold ||
        velocity.abs() > _velocityThreshold;

    if (shouldSwipe) {
      final direction = (_dragPosition.dx > 0 || velocity > _velocityThreshold)
          ? SwipeDirection.right
          : SwipeDirection.left;
      swipe(direction);
    } else {
      // Snap back
      setState(() {
        _position = Tween<Offset>(
          begin: _dragPosition,
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutBack,
        ));
        _rotation = Tween<double>(
          begin: _calculateRotation(_dragPosition.dx),
          end: 0.0,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutBack,
        ));
      });

      _controller.forward().then((_) {
        _resetState();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleFiles = <SwipeFile>[];
    for (var i = 0; i < widget.visibleCards; i++) {
      final index = widget.currentIndex + i;
      if (index < widget.files.length) {
        visibleFiles.add(widget.files[index]);
      }
    }

    if (visibleFiles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Background glow
        _buildGlowBackground(),

        // Card stack (back to front)
        ...visibleFiles.reversed.toList().asMap().entries.map((entry) {
          final reversedIndex = visibleFiles.length - 1 - entry.key;
          final file = entry.value;
          final isFront = reversedIndex == 0;

          Widget card = SwipeCard(
            file: file,
            isFront: isFront,
            stackIndex: reversedIndex.toDouble(),
          );

          // Only animate the front card
          if (isFront) {
            card = GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final position =
                      _isDragging ? _dragPosition : _position.value;
                  final rotation = _isDragging
                      ? _calculateRotation(_dragPosition.dx)
                      : _rotation.value;

                  return Transform.translate(
                    offset: position,
                    child: Transform.rotate(
                      angle: rotation * math.pi / 180,
                      child: child,
                    ),
                  );
                },
                child: card,
              ),
            );
          }

          return card;
        }).toList(),
      ],
    );
  }

  Widget _buildGlowBackground() {
    final intensity = (_dragPosition.dx.abs() / 200).clamp(0.0, 0.8);
    final isLeft = _dragPosition.dx < 0;

    if (intensity < 0.05) return const SizedBox.shrink();

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: isLeft
                ? const Alignment(-0.8, 0)
                : const Alignment(0.8, 0),
            radius: 1.5,
            colors: [
              (isLeft ? AppColors.lightDelete : AppColors.lightKeep)
                  .withOpacity(intensity * 0.3),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
