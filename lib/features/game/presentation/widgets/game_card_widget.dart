import 'dart:math' as math;

import 'package:flutter/material.dart';

class GameCardWidget extends StatelessWidget {
  const GameCardWidget({
    super.key,
    required this.number,
    required this.isFaceVisible,
    this.onTap,
  });

  final int number;
  final bool isFaceVisible;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: isFaceVisible ? 0 : 1),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        builder: (context, animationValue, child) {
          final double angle = animationValue * math.pi;
          final bool showFront = animationValue < 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: showFront
                ? _buildFrontFace(context)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _buildBackFace(context),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFrontFace(BuildContext context) {
    final bool isTarget = number == 9;

    return AnimatedOpacity(
      opacity: isFaceVisible ? 1 : 0,
      duration: const Duration(milliseconds: 250),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isTarget
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.primary,
            width: isTarget ? 3 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '$number',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            if (isTarget)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.adjust,
                  size: 22,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackFace(BuildContext context) {
    return AnimatedOpacity(
      opacity: isFaceVisible ? 0 : 1,
      duration: const Duration(milliseconds: 250),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          Icons.question_mark,
          size: 36,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
