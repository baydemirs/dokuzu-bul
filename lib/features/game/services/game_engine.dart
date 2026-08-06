import 'package:dokuzu_bul/features/game/constants/game_constants.dart';
import 'package:dokuzu_bul/features/game/domain/game_card_model.dart';
import 'package:dokuzu_bul/features/game/domain/game_phase.dart';
import 'package:dokuzu_bul/features/game/domain/game_state.dart';

class GameEngine {
  const GameEngine();

  GameState startPreview(GameState state) {
    return state.copyWith(
      phase: GamePhase.preview,
      cards: openAllCards(state.cards),
      remainingTime: 1.0,
    );
  }

  GameState startHiding(GameState state) {
    return state.copyWith(
      phase: GamePhase.hiding,
      cards: closeAllCards(state.cards),
    );
  }

  GameState startShuffling(GameState state) {
    return state.copyWith(phase: GamePhase.shuffling);
  }

  GameState waitForSelection(GameState state) {
    return state.copyWith(
      phase: GamePhase.waitingForSelection,
      remainingTime: 1.0,
    );
  }

  GameState showRoundFeedback({
    required GameState state,
    required int score,
    required int combo,
    required int lives,
    required int correctAnswers,
  }) {
    return state.copyWith(
      phase: GamePhase.feedback,
      cards: openAllCards(state.cards),
      score: score,
      combo: combo,
      lives: lives,
      correctAnswers: correctAnswers,
      remainingTime: 0,
    );
  }

  GameState startNextRound(GameState state) {
    return state.copyWith(
      currentRound: state.currentRound + 1,
      phase: GamePhase.preview,
      cards: openAllCards(state.cards),
      remainingTime: 1.0,
    );
  }

  GameState finishGame(GameState state) {
    if (state.lives <= 0) {
      return state.copyWith(phase: GamePhase.gameOver);
    }

    if (state.currentRound >= GameConstants.totalRounds) {
      return state.copyWith(phase: GamePhase.levelCompleted);
    }

    return state;
  }

  List<GameCardModel> openAllCards(List<GameCardModel> cards) {
    return cards.map((card) {
      return card.open();
    }).toList();
  }

  List<GameCardModel> closeAllCards(List<GameCardModel> cards) {
    return cards.map((card) {
      return card.close();
    }).toList();
  }

  bool shouldFinishGame(GameState state) {
    return state.lives <= 0 || state.currentRound >= GameConstants.totalRounds;
  }

  bool canSelectCard(GameState state) {
    return state.phase == GamePhase.waitingForSelection;
  }

  bool isGameFinished(GameState state) {
    return state.phase == GamePhase.levelCompleted ||
        state.phase == GamePhase.gameOver;
  }

  double calculateLevelProgress(GameState state) {
    int completedRounds = state.currentRound - 1;

    if (state.phase == GamePhase.feedback ||
        state.phase == GamePhase.levelCompleted ||
        state.phase == GamePhase.gameOver) {
      completedRounds = state.currentRound;
    }

    return (completedRounds / GameConstants.totalRounds)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  String getInstructionText(GamePhase phase) {
    switch (phase) {
      case GamePhase.idle:
        return 'Oyun hazırlanıyor';

      case GamePhase.preview:
        return 'Dokuzu takip et';

      case GamePhase.hiding:
        return 'Kartlar kapanıyor';

      case GamePhase.shuffling:
        return 'Dokuzu takip et';

      case GamePhase.waitingForSelection:
        return 'Dokuz hangi kartta?';

      case GamePhase.feedback:
        return 'Sonuç gösteriliyor';

      case GamePhase.levelCompleted:
        return 'Seviye tamamlandı';

      case GamePhase.gameOver:
        return 'Oyun bitti';
    }
  }
}
