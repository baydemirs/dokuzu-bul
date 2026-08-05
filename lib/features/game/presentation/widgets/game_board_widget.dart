import 'package:dokuzu_bul/features/game/domain/game_card_model.dart';
import 'package:dokuzu_bul/features/game/presentation/widgets/game_card_widget.dart';
import 'package:flutter/material.dart';

class GameBoardWidget extends StatelessWidget {
  const GameBoardWidget({
    super.key,
    required this.cards,
    this.onCardSelected,
  });

  final List<GameCardModel> cards;
  final ValueChanged<GameCardModel>? onCardSelected;

  @override
  Widget build(BuildContext context) {
    final sortedCards = [...cards]
      ..sort((firstCard, secondCard) {
        return firstCard.slot.compareTo(secondCard.slot);
      });

    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sortedCards.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final card = sortedCards[index];

          return GameCardWidget(
            key: ValueKey(card.id),
            number: card.number,
            isFaceVisible: card.isFaceVisible,
            onTap: onCardSelected == null
                ? null
                : () {
              onCardSelected!(card);
            },
          );
        },
      ),
    );
  }
}