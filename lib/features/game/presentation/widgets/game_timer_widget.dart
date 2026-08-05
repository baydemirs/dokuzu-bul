import 'package:flutter/material.dart';

class GameTimerWidget extends StatelessWidget {
  const GameTimerWidget({
    super.key,
    this.progress = 0.75,
    this.remainingSeconds = 4.5,
  });

  final double progress;
  final double remainingSeconds;

  @override
  Widget build(BuildContext context) {
    final safeProgress = progress.clamp(0.0, 1.0);

    return Column(
      children: [
        LinearProgressIndicator(
          value: safeProgress,
          minHeight: 10,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        const SizedBox(height: 12),
        Text(
          '${remainingSeconds.toStringAsFixed(1).replaceAll('.', ',')} saniye',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
