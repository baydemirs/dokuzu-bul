import 'package:dokuzu_bul/features/game/constants/game_constants.dart';
import 'package:dokuzu_bul/features/game/domain/game_card_model.dart';
import 'package:dokuzu_bul/features/game/domain/game_state.dart';
import 'package:dokuzu_bul/features/game/extensions/difficulty_extension.dart';
import 'package:dokuzu_bul/features/game/presentation/widgets/game_board_widget.dart';
import 'package:dokuzu_bul/features/game/presentation/widgets/game_bottom_panel_widget.dart';
import 'package:dokuzu_bul/features/game/presentation/widgets/game_header_widget.dart';
import 'package:dokuzu_bul/features/game/presentation/widgets/game_status_widget.dart';
import 'package:dokuzu_bul/features/game/services/game_engine.dart';
import 'package:dokuzu_bul/features/game/services/game_timer_service.dart';
import 'package:dokuzu_bul/features/game/services/score_service.dart';
import 'package:dokuzu_bul/features/game/services/shuffle_service.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState gameState;

  final GameEngine _gameEngine = const GameEngine();
  final ShuffleService _shuffleService = ShuffleService();
  final ScoreService _scoreService = const ScoreService();
  final GameTimerService _timerService = GameTimerService();

  double _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();

    gameState = createInitialGameState();
    _remainingSeconds = gameState.difficulty.selectionSeconds;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startGame();
    });
  }

  @override
  void dispose() {
    _timerService.dispose();
    super.dispose();
  }

  Future<void> _startGame() async {
    _timerService.cancel();

    setState(() {
      _remainingSeconds = gameState.difficulty.selectionSeconds;
      gameState = _gameEngine.startPreview(gameState);
    });

    await Future.delayed(GameConstants.previewDuration);

    if (!mounted) {
      return;
    }

    await _hideCardsAndShuffle();
  }

  Future<void> _hideCardsAndShuffle() async {
    setState(() {
      gameState = _gameEngine.startHiding(gameState);
    });

    await Future.delayed(GameConstants.cardHideDuration);

    if (!mounted) {
      return;
    }

    await _shuffleBoard();
  }

  Future<void> _shuffleBoard() async {
    setState(() {
      gameState = _gameEngine.startShuffling(gameState);
    });

    final int moveCount = gameState.difficulty.moveCount;

    for (int move = 0; move < moveCount; move++) {
      final swap = _shuffleService.createRandomSwap(gameState.cards.length);

      final updatedCards = _shuffleService.swapCards(
        cards: gameState.cards,
        firstIndex: swap.firstIndex,
        secondIndex: swap.secondIndex,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        gameState = gameState.copyWith(cards: updatedCards);
      });

      await Future.delayed(gameState.difficulty.shuffleDuration);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      gameState = _gameEngine.waitForSelection(gameState);
    });

    _startSelectionTimer();
  }

  void _startSelectionTimer() {
    final double totalSeconds = gameState.difficulty.selectionSeconds;

    _timerService.start(
      totalSeconds: totalSeconds,
      onTick: (remainingSeconds, progress) {
        if (!mounted || !_gameEngine.canSelectCard(gameState)) {
          _timerService.cancel();
          return;
        }

        setState(() {
          _remainingSeconds = remainingSeconds;

          gameState = gameState.copyWith(remainingTime: progress);
        });
      },
      onCompleted: () {
        if (!mounted || !_gameEngine.canSelectCard(gameState)) {
          return;
        }

        _handleTimeExpired();
      },
    );
  }

  Future<void> _handleCardSelected(GameCardModel selectedCard) async {
    if (!_gameEngine.canSelectCard(gameState)) {
      return;
    }

    _timerService.cancel();

    await _showRoundResult(
      isCorrect: selectedCard.isTarget,
      selectedNumber: selectedCard.number,
    );
  }

  Future<void> _handleTimeExpired() async {
    if (!_gameEngine.canSelectCard(gameState)) {
      return;
    }

    await _showRoundResult(isCorrect: false, didTimeExpire: true);
  }

  Future<void> _showRoundResult({
    required bool isCorrect,
    int? selectedNumber,
    bool didTimeExpire = false,
  }) async {
    final RoundResult result = _scoreService.calculateResult(
      isCorrect: isCorrect,
      currentScore: gameState.score,
      currentCombo: gameState.combo,
      currentLives: gameState.lives,
      currentCorrectAnswers: gameState.correctAnswers,
    );

    setState(() {
      _remainingSeconds = 0;

      gameState = _gameEngine.showRoundFeedback(
        state: gameState,
        score: result.score,
        combo: result.combo,
        lives: result.lives,
        correctAnswers: result.correctAnswers,
      );
    });

    if (didTimeExpire) {
      debugPrint('Süre doldu - Kalan can: ${result.lives}');
    } else if (isCorrect) {
      debugPrint(
        'Doğru seçim: $selectedNumber - '
        'Combo: ${result.combo} - '
        'Kazanılan puan: ${result.earnedScore} - '
        'Toplam skor: ${result.score}',
      );
    } else {
      debugPrint(
        'Yanlış seçim: $selectedNumber - '
        'Kalan can: ${result.lives}',
      );
    }

    await Future.delayed(GameConstants.feedbackDuration);

    if (!mounted) {
      return;
    }

    if (_gameEngine.shouldFinishGame(gameState)) {
      setState(() {
        gameState = _gameEngine.finishGame(gameState);
      });

      return;
    }

    await _startNextRound();
  }

  Future<void> _startNextRound() async {
    setState(() {
      _remainingSeconds = gameState.difficulty.selectionSeconds;
      gameState = _gameEngine.startNextRound(gameState);
    });

    await Future.delayed(GameConstants.previewDuration);

    if (!mounted) {
      return;
    }

    await _hideCardsAndShuffle();
  }

  void _restartGame() {
    _timerService.cancel();

    setState(() {
      gameState = createInitialGameState();
      _remainingSeconds = gameState.difficulty.selectionSeconds;
    });

    _startGame();
  }

  @override
  Widget build(BuildContext context) {
    final bool canSelectCard = _gameEngine.canSelectCard(gameState);

    final bool isGameFinished = _gameEngine.isGameFinished(gameState);

    final double levelProgress = _gameEngine.calculateLevelProgress(gameState);

    final String instructionText = _gameEngine.getInstructionText(
      gameState.phase,
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GameHeaderWidget(
                lives: gameState.lives,
                level: gameState.difficulty.label,
                score: gameState.score,
              ),
              const SizedBox(height: 12),
              GameStatusWidget(
                currentRound: gameState.currentRound,
                totalRounds: GameConstants.totalRounds,
                levelProgress: levelProgress,
                combo: gameState.combo,
                phase: gameState.phase,
                instructionText: instructionText,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: GameBoardWidget(
                    cards: gameState.cards,
                    onCardSelected: canSelectCard ? _handleCardSelected : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GameBottomPanelWidget(
                isGameFinished: isGameFinished,
                timerProgress: gameState.remainingTime,
                remainingSeconds: _remainingSeconds,
                onRestart: _restartGame,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
