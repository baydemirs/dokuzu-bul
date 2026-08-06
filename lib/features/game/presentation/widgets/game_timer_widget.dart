import 'package:flutter/material.dart';

class GameTimerWidget extends StatelessWidget {
  const GameTimerWidget({
    super.key,
    required this.progress,
    required this.remainingSeconds,
  });

  final double progress;
  final double remainingSeconds;

  @override
  Widget build(BuildContext context) {
    final double safeProgress = progress.clamp(0.0, 1.0).toDouble();
    final double safeSeconds = remainingSeconds < 0 ? 0 : remainingSeconds;

    return Column(
      children: [
        LinearProgressIndicator(
          value: safeProgress,
          minHeight: 10,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        const SizedBox(height: 12),
        Text(
          '${safeSeconds.toStringAsFixed(1).replaceAll('.', ',')} saniye',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
