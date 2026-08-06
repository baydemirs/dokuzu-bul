import 'package:dokuzu_bul/features/game/constants/game_constants.dart';
import 'package:dokuzu_bul/features/game/domain/difficulty.dart';

extension DifficultyExtension on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.easy:
        return 'Kolay';

      case Difficulty.medium:
        return 'Orta';

      case Difficulty.hard:
        return 'Zor';
    }
  }

  int get moveCount {
    switch (this) {
      case Difficulty.easy:
        return GameConstants.easyMoveCount;

      case Difficulty.medium:
        return GameConstants.mediumMoveCount;

      case Difficulty.hard:
        return GameConstants.hardMoveCount;
    }
  }

  double get selectionSeconds {
    switch (this) {
      case Difficulty.easy:
        return GameConstants.easySelectionSeconds;

      case Difficulty.medium:
        return GameConstants.mediumSelectionSeconds;

      case Difficulty.hard:
        return GameConstants.hardSelectionSeconds;
    }
  }

  Duration get shuffleDuration {
    switch (this) {
      case Difficulty.easy:
        return GameConstants.easyShuffleDuration;

      case Difficulty.medium:
        return GameConstants.mediumShuffleDuration;

      case Difficulty.hard:
        return GameConstants.hardShuffleDuration;
    }
  }
}
