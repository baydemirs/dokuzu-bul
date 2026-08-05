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
    final bool isTarget = number == 9;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isFaceVisible && isTarget
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.primary,
            width: isFaceVisible && isTarget ? 3 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: isFaceVisible
            ? Stack(
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
        )
            : Center(
          child: Icon(
            Icons.question_mark,
            size: 34,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}