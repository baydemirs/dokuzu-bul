import 'dart:async';
import 'dart:math';

import 'package:dokuzu_bul/features/game/domain/difficulty.dart';
import 'package:dokuzu_bul/features/game/domain/game_card_model.dart';
import 'package:dokuzu_bul/features/game/domain/game_phase.dart';
import 'package:dokuzu_bul/features/game/domain/game_state.dart';
import 'package:dokuzu_bul/features/game/presentation/widgets/game_board_widget.dart';
import 'package:dokuzu_bul/features/game/presentation/widgets/game_header_widget.dart';
import 'package:dokuzu_bul/features/game/presentation/widgets/game_timer_widget.dart';
import 'package:dokuzu_bul/features/game/presentation/widgets/level_widget.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState gameState;

  final Random _random = Random();

  Timer? _selectionTimer;

  double _remainingSeconds = 6;

  @override
  void initState() {
    super.initState();

    gameState = createInitialGameState();
    _remainingSeconds = _getSelectionDuration();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startGame();
    });
  }

  @override
  void dispose() {
    _selectionTimer?.cancel();
    super.dispose();
  }

  Future<void> _startGame() async {
    _selectionTimer?.cancel();

    setState(() {
      _remainingSeconds = _getSelectionDuration();

      gameState = gameState.copyWith(
        phase: GamePhase.preview,
        cards: _openAllCards(gameState.cards),
        remainingTime: 1.0,
      );
    });

    await Future.delayed(const Duration(milliseconds: 1800));

    if (!mounted) {
      return;
    }

    await _hideCardsAndShuffle();
  }

  Future<void> _hideCardsAndShuffle() async {
    setState(() {
      gameState = gameState.copyWith(
        phase: GamePhase.hiding,
        cards: _closeAllCards(gameState.cards),
      );
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) {
      return;
    }

    await _shuffleBoard();
  }

  Future<void> _shuffleBoard() async {
    setState(() {
      gameState = gameState.copyWith(phase: GamePhase.shuffling);
    });

    final int moveCount = _getMoveCount();

    for (int move = 0; move < moveCount; move++) {
      final int firstIndex = _getRandomCardIndex();

      int secondIndex = _getRandomCardIndex();

      while (secondIndex == firstIndex) {
        secondIndex = _getRandomCardIndex();
      }

      final updatedCards = _swapCards(
        cards: gameState.cards,
        firstIndex: firstIndex,
        secondIndex: secondIndex,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        gameState = gameState.copyWith(cards: updatedCards);
      });

      await Future.delayed(const Duration(milliseconds: 600));
    }

    if (!mounted) {
      return;
    }

    setState(() {
      gameState = gameState.copyWith(
        phase: GamePhase.waitingForSelection,
        remainingTime: 1.0,
      );
    });

    _startSelectionTimer();
  }

  void _startSelectionTimer() {
    _selectionTimer?.cancel();

    final double totalSeconds = _getSelectionDuration();

    setState(() {
      _remainingSeconds = totalSeconds;

      gameState = gameState.copyWith(remainingTime: 1.0);
    });

    _selectionTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      if (!mounted || gameState.phase != GamePhase.waitingForSelection) {
        timer.cancel();
        return;
      }

      final double updatedSeconds = max(0, _remainingSeconds - 0.1).toDouble();

      final double updatedProgress = updatedSeconds / totalSeconds;

      setState(() {
        _remainingSeconds = updatedSeconds;

        gameState = gameState.copyWith(remainingTime: updatedProgress);
      });

      if (updatedSeconds <= 0) {
        timer.cancel();
        unawaited(_handleTimeExpired());
      }
    });
  }

  Future<void> _handleCardSelected(GameCardModel selectedCard) async {
    if (gameState.phase != GamePhase.waitingForSelection) {
      return;
    }

    _selectionTimer?.cancel();

    final bool isCorrect = selectedCard.isTarget;

    await _showRoundResult(
      isCorrect: isCorrect,
      selectedNumber: selectedCard.number,
    );
  }

  Future<void> _handleTimeExpired() async {
    if (gameState.phase != GamePhase.waitingForSelection) {
      return;
    }

    await _showRoundResult(isCorrect: false, didTimeExpire: true);
  }

  Future<void> _showRoundResult({
    required bool isCorrect,
    int? selectedNumber,
    bool didTimeExpire = false,
  }) async {
    final int updatedCombo = isCorrect ? gameState.combo + 1 : 0;

    final int earnedScore = isCorrect ? 100 * updatedCombo : 0;

    final int updatedScore = gameState.score + earnedScore;

    final int updatedCorrectAnswers = isCorrect
        ? gameState.correctAnswers + 1
        : gameState.correctAnswers;

    final int updatedLives = isCorrect
        ? gameState.lives
        : max(0, gameState.lives - 1);

    setState(() {
      _remainingSeconds = 0;

      gameState = gameState.copyWith(
        phase: GamePhase.feedback,
        cards: _openAllCards(gameState.cards),
        score: updatedScore,
        combo: updatedCombo,
        correctAnswers: updatedCorrectAnswers,
        lives: updatedLives,
        remainingTime: 0,
      );
    });

    if (didTimeExpire) {
      debugPrint('Süre doldu - Kalan can: $updatedLives');
    } else if (isCorrect) {
      debugPrint(
        'Doğru seçim: $selectedNumber - '
        'Combo: $updatedCombo - '
        'Kazanılan puan: $earnedScore - '
        'Toplam skor: $updatedScore',
      );
    } else {
      debugPrint(
        'Yanlış seçim: $selectedNumber - '
        'Kalan can: $updatedLives',
      );
    }

    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) {
      return;
    }

    if (gameState.lives <= 0) {
      setState(() {
        gameState = gameState.copyWith(phase: GamePhase.gameOver);
      });

      return;
    }

    if (gameState.currentRound >= 5) {
      setState(() {
        gameState = gameState.copyWith(phase: GamePhase.levelCompleted);
      });

      return;
    }

    await _startNextRound();
  }

  Future<void> _startNextRound() async {
    setState(() {
      _remainingSeconds = _getSelectionDuration();

      gameState = gameState.copyWith(
        currentRound: gameState.currentRound + 1,
        phase: GamePhase.preview,
        cards: _openAllCards(gameState.cards),
        remainingTime: 1.0,
      );
    });

    await Future.delayed(const Duration(milliseconds: 1800));

    if (!mounted) {
      return;
    }

    await _hideCardsAndShuffle();
  }

  void _restartGame() {
    _selectionTimer?.cancel();

    setState(() {
      gameState = createInitialGameState();
      _remainingSeconds = _getSelectionDuration();
    });

    _startGame();
  }

  List<GameCardModel> _openAllCards(List<GameCardModel> cards) {
    return cards.map((card) {
      return card.open();
    }).toList();
  }

  List<GameCardModel> _closeAllCards(List<GameCardModel> cards) {
    return cards.map((card) {
      return card.close();
    }).toList();
  }

  List<GameCardModel> _swapCards({
    required List<GameCardModel> cards,
    required int firstIndex,
    required int secondIndex,
  }) {
    final firstCard = cards[firstIndex];
    final secondCard = cards[secondIndex];

    return cards.map((card) {
      if (card.id == firstCard.id) {
        return card.copyWith(slot: secondCard.slot);
      }

      if (card.id == secondCard.id) {
        return card.copyWith(slot: firstCard.slot);
      }

      return card;
    }).toList();
  }

  int _getRandomCardIndex() {
    return _random.nextInt(gameState.cards.length);
  }

  int _getMoveCount() {
    switch (gameState.difficulty) {
      case Difficulty.easy:
        return 3;

      case Difficulty.medium:
        return 6;

      case Difficulty.hard:
        return 10;
    }
  }

  double _getSelectionDuration() {
    switch (gameState.difficulty) {
      case Difficulty.easy:
        return 6;

      case Difficulty.medium:
        return 4.5;

      case Difficulty.hard:
        return 3;
    }
  }

  String _getDifficultyText() {
    switch (gameState.difficulty) {
      case Difficulty.easy:
        return 'Kolay';

      case Difficulty.medium:
        return 'Orta';

      case Difficulty.hard:
        return 'Zor';
    }
  }

  String _getInstructionText() {
    switch (gameState.phase) {
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

  double _getLevelProgress() {
    int completedRounds = gameState.currentRound - 1;

    if (gameState.phase == GamePhase.feedback ||
        gameState.phase == GamePhase.levelCompleted ||
        gameState.phase == GamePhase.gameOver) {
      completedRounds = gameState.currentRound;
    }

    return (completedRounds / 5).clamp(0.0, 1.0);
  }

  bool get _canSelectCard {
    return gameState.phase == GamePhase.waitingForSelection;
  }

  bool get _isGameFinished {
    return gameState.phase == GamePhase.levelCompleted ||
        gameState.phase == GamePhase.gameOver;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GameHeaderWidget(
                lives: gameState.lives,
                level: _getDifficultyText(),
                score: gameState.score,
              ),
              const SizedBox(height: 12),
              LevelWidget(
                level: 'Tur ${gameState.currentRound} / 5',
                progress: _getLevelProgress(),
              ),
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: gameState.combo > 1
                    ? Chip(
                        key: ValueKey(gameState.combo),
                        avatar: const Icon(
                          Icons.local_fire_department,
                          size: 19,
                        ),
                        label: Text(
                          '${gameState.combo}x Combo',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    : const SizedBox(key: ValueKey('empty-combo'), height: 32),
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  _getInstructionText(),
                  key: ValueKey(gameState.phase),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: GameBoardWidget(
                    cards: gameState.cards,
                    onCardSelected: _canSelectCard ? _handleCardSelected : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_isGameFinished)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _restartGame,
                    child: const Text('Tekrar Oyna'),
                  ),
                )
              else
                GameTimerWidget(
                  progress: gameState.remainingTime,
                  remainingSeconds: _remainingSeconds,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
