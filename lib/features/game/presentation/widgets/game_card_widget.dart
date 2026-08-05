import 'package:flutter/material.dart';

class GameCardWidget extends StatelessWidget {
  const GameCardWidget({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final bool isTarget = number == 9;

    return Container(
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
    );
  }
}
