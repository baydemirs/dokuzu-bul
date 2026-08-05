import 'package:dokuzu_bul/features/game/domain/difficulty.dart';
import 'package:dokuzu_bul/features/game/domain/game_card_model.dart';
import 'package:dokuzu_bul/features/game/domain/game_phase.dart';

class GameState {
  const GameState({
    required this.cards,
    required this.phase,
    required this.difficulty,
    required this.score,
    required this.lives,
    required this.currentRound,
    required this.correctAnswers,
    required this.remainingTime,
  });

  final List<GameCardModel> cards;
  final GamePhase phase;
  final Difficulty difficulty;
  final int score;
  final int lives;
  final int currentRound;
  final int correctAnswers;
  final double remainingTime;

  GameState copyWith({
    List<GameCardModel>? cards,
    GamePhase? phase,
    Difficulty? difficulty,
    int? score,
    int? lives,
    int? currentRound,
    int? correctAnswers,
    double? remainingTime,
  }) {
    return GameState(
      cards: cards ?? this.cards,
      phase: phase ?? this.phase,
      difficulty: difficulty ?? this.difficulty,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      currentRound: currentRound ?? this.currentRound,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }
}

GameState createInitialGameState() {
  final cards = List.generate(9, (index) {
    return GameCardModel(id: index + 1, number: index + 1, slot: index);
  });

  return GameState(
    cards: cards,
    phase: GamePhase.idle,
    difficulty: Difficulty.easy,
    score: 0,
    lives: 3,
    currentRound: 1,
    correctAnswers: 0,
    remainingTime: 1.0,
  );
}
