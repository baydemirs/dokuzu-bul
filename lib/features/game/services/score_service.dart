import 'dart:math';

import 'package:dokuzu_bul/features/game/constants/game_constants.dart';

class RoundResult {
  const RoundResult({
    required this.score,
    required this.combo,
    required this.lives,
    required this.correctAnswers,
    required this.earnedScore,
  });

  final int score;
  final int combo;
  final int lives;
  final int correctAnswers;
  final int earnedScore;
}

class ScoreService {
  const ScoreService();

  RoundResult calculateResult({
    required bool isCorrect,
    required int currentScore,
    required int currentCombo,
    required int currentLives,
    required int currentCorrectAnswers,
  }) {
    final int updatedCombo = isCorrect ? currentCombo + 1 : 0;

    final int earnedScore = isCorrect
        ? GameConstants.baseScore * updatedCombo
        : 0;

    final int updatedScore = currentScore + earnedScore;

    final int updatedLives = isCorrect
        ? currentLives
        : max(0, currentLives - 1);

    final int updatedCorrectAnswers = isCorrect
        ? currentCorrectAnswers + 1
        : currentCorrectAnswers;

    return RoundResult(
      score: updatedScore,
      combo: updatedCombo,
      lives: updatedLives,
      correctAnswers: updatedCorrectAnswers,
      earnedScore: earnedScore,
    );
  }
}
