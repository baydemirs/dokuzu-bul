import 'package:dokuzu_bul/features/game/presentation/widgets/game_timer_widget.dart';
import 'package:dokuzu_bul/features/game/presentation/widgets/game_header_widget.dart';
import 'package:dokuzu_bul/features/game/presentation/widgets/game_board_widget.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const GameHeaderWidget(),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tur 1 / 5',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Dokuzu takip et',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              const Expanded(child: Center(child: GameBoardWidget())),
              const SizedBox(height: 24),
              const GameTimerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
