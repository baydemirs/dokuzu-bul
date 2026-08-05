import 'package:dokuzu_bul/features/game/presentation/widgets/level_widget.dart';
import 'package:flutter/material.dart';

class GameHeaderWidget extends StatelessWidget {
  const GameHeaderWidget({
    super.key,
    this.lives = 3,
    this.level = 'Kolay',
    this.score = 0,
  });

  final int lives;
  final String level;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.favorite, color: Colors.red),
            const SizedBox(width: 4),
            Text(
              '$lives',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        LevelWidget(level: level),
        Text(
          '$score Puan',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
