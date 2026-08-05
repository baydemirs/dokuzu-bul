import 'package:dokuzu_bul/features/game/domain/difficulty.dart';

class LevelModel {
  const LevelModel({
    required this.difficulty,
    required this.moveCount,
    required this.previewDuration,
    required this.swapDuration,
    required this.selectionDuration,
  });

  final Difficulty difficulty;
  final int moveCount;
  final Duration previewDuration;
  final Duration swapDuration;
  final Duration selectionDuration;
}

const LevelModel easyLevel = LevelModel(
  difficulty: Difficulty.easy,
  moveCount: 5,
  previewDuration: Duration(milliseconds: 1500),
  swapDuration: Duration(milliseconds: 650),
  selectionDuration: Duration(seconds: 6),
);

const LevelModel mediumLevel = LevelModel(
  difficulty: Difficulty.medium,
  moveCount: 10,
  previewDuration: Duration(milliseconds: 1100),
  swapDuration: Duration(milliseconds: 420),
  selectionDuration: Duration(milliseconds: 4500),
);

const LevelModel hardLevel = LevelModel(
  difficulty: Difficulty.hard,
  moveCount: 16,
  previewDuration: Duration(milliseconds: 800),
  swapDuration: Duration(milliseconds: 280),
  selectionDuration: Duration(seconds: 3),
);
