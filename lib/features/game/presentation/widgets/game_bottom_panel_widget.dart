import 'package:dokuzu_bul/features/game/presentation/widgets/game_timer_widget.dart';
import 'package:flutter/material.dart';

class GameBottomPanelWidget extends StatelessWidget {
  const GameBottomPanelWidget({
    super.key,
    required this.isGameFinished,
    required this.timerProgress,
    required this.remainingSeconds,
    required this.onRestart,
  });

  final bool isGameFinished;
  final double timerProgress;
  final double remainingSeconds;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    if (isGameFinished) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onRestart,
          child: const Text('Tekrar Oyna'),
        ),
      );
    }

    return GameTimerWidget(
      progress: timerProgress,
      remainingSeconds: remainingSeconds,
    );
  }
}
