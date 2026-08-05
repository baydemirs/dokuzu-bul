import 'package:dokuzu_bul/features/game/domain/game_card_model.dart';
import 'package:dokuzu_bul/features/game/domain/game_state.dart';
import 'package:dokuzu_bul/features/game/presentation/widgets/game_board_widget.dart';
import 'package:dokuzu_bul/features/game/presentation/widgets/game_header_widget.dart';
import 'package:dokuzu_bul/features/game/presentation/widgets/game_timer_widget.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState gameState;

  @override
  void initState() {
    super.initState();
    gameState = createInitialGameState();
  }

  void _handleCardSelected(GameCardModel selectedCard) {
    if (selectedCard.isTarget) {
      setState(() {
        gameState = gameState.copyWith(
          score: gameState.score + 100,
          correctAnswers: gameState.correctAnswers + 1,
        );
      });

      debugPrint(
        'Doğru seçim: ${selectedCard.number} - Skor: ${gameState.score}',
      );

      return;
    }

    setState(() {
      gameState = gameState.copyWith(
        lives: gameState.lives > 0 ? gameState.lives - 1 : 0,
      );
    });

    debugPrint(
      'Yanlış seçim: ${selectedCard.number} - Kalan can: ${gameState.lives}',
    );
  }

  void _swapFirstTwoCards() {
    final firstCard = gameState.cards[0];
    final secondCard = gameState.cards[1];

    final updatedCards = gameState.cards.map((card) {
      if (card.id == firstCard.id) {
        return card.copyWith(slot: secondCard.slot);
      }

      if (card.id == secondCard.id) {
        return card.copyWith(slot: firstCard.slot);
      }

      return card;
    }).toList();

    setState(() {
      gameState = gameState.copyWith(cards: updatedCards);
    });
  }

  void _toggleCardFaces() {
    final updatedCards = gameState.cards.map((card) {
      if (card.isFaceVisible) {
        return card.close();
      }

      return card.open();
    }).toList();

    setState(() {
      gameState = gameState.copyWith(cards: updatedCards);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool cardsAreVisible = gameState.cards.every(
      (card) => card.isFaceVisible,
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GameHeaderWidget(
                lives: gameState.lives,
                level: 'Kolay',
                score: gameState.score,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tur ${gameState.currentRound} / 5',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Dokuzu takip et',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: GameBoardWidget(
                    cards: gameState.cards,
                    onCardSelected: _handleCardSelected,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _swapFirstTwoCards,
                      child: const Text('Kartları Taşı'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _toggleCardFaces,
                      child: Text(
                        cardsAreVisible ? 'Kartları Kapat' : 'Kartları Aç',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GameTimerWidget(
                progress: gameState.remainingTime,
                remainingSeconds: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
