import 'dart:async';

import 'package:dokuzu_bul/features/game/constants/game_constants.dart';

class GameTimerService {
  Timer? _timer;

  bool get isRunning => _timer?.isActive ?? false;

  void start({
    required double totalSeconds,
    required void Function(double remainingSeconds, double progress) onTick,
    required void Function() onCompleted,
  }) {
    cancel();

    double remainingSeconds = totalSeconds;

    onTick(remainingSeconds, 1.0);

    _timer = Timer.periodic(GameConstants.timerTickDuration, (timer) {
      remainingSeconds = (remainingSeconds - 0.1)
          .clamp(0.0, totalSeconds)
          .toDouble();

      final double progress = remainingSeconds / totalSeconds;

      onTick(remainingSeconds, progress);

      if (remainingSeconds <= 0) {
        timer.cancel();
        onCompleted();
      }
    });
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    cancel();
  }
}
