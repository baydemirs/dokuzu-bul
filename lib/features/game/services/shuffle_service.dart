import 'dart:math';

import 'package:dokuzu_bul/features/game/domain/game_card_model.dart';

class ShuffleService {
  ShuffleService({Random? random}) : _random = random ?? Random();

  final Random _random;

  List<GameCardModel> swapCards({
    required List<GameCardModel> cards,
    required int firstIndex,
    required int secondIndex,
  }) {
    if (firstIndex < 0 ||
        secondIndex < 0 ||
        firstIndex >= cards.length ||
        secondIndex >= cards.length) {
      return List<GameCardModel>.from(cards);
    }

    if (firstIndex == secondIndex) {
      return List<GameCardModel>.from(cards);
    }

    final GameCardModel firstCard = cards[firstIndex];
    final GameCardModel secondCard = cards[secondIndex];

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

  ({int firstIndex, int secondIndex}) createRandomSwap(int cardCount) {
    if (cardCount < 2) {
      throw ArgumentError('Karıştırma için en az iki kart gereklidir.');
    }

    final int firstIndex = _random.nextInt(cardCount);

    int secondIndex = _random.nextInt(cardCount);

    while (secondIndex == firstIndex) {
      secondIndex = _random.nextInt(cardCount);
    }

    return (firstIndex: firstIndex, secondIndex: secondIndex);
  }
}
