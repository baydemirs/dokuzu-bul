import 'package:dokuzu_bul/features/game/domain/game_card_model.dart';
import 'package:dokuzu_bul/features/game/presentation/widgets/game_card_widget.dart';
import 'package:flutter/material.dart';

class GameBoardWidget extends StatelessWidget {
  const GameBoardWidget({super.key, required this.cards, this.onCardSelected});

  final List<GameCardModel> cards;
  final ValueChanged<GameCardModel>? onCardSelected;

  @override
  Widget build(BuildContext context) {
    const double spacing = 12;

    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double boardSize = constraints.maxWidth;
          final double cardSize = (boardSize - (spacing * 2)) / 3;

          return Stack(
            children: cards.map((card) {
              final double left = card.column * (cardSize + spacing);
              final double top = card.row * (cardSize + spacing);

              return AnimatedPositioned(
                key: ValueKey(card.id),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                left: left,
                top: top,
                width: cardSize,
                height: cardSize,
                child: GameCardWidget(
                  number: card.number,
                  isFaceVisible: card.isFaceVisible,
                  onTap: onCardSelected == null
                      ? null
                      : () {
                          onCardSelected!(card);
                        },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
