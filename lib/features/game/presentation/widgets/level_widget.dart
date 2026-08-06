import 'package:flutter/material.dart';

class LevelWidget extends StatelessWidget {
  const LevelWidget({super.key, required this.level, this.progress});

  final String level;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final double? safeProgress = progress?.clamp(0.0, 1.0).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Chip(
          label: Text(
            level,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        if (safeProgress != null) ...[
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: safeProgress,
            minHeight: 7,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
        ],
      ],
    );
  }
}
