import 'package:dokuzu_bul/features/game/domain/game_phase.dart';
import 'package:dokuzu_bul/features/game/presentation/widgets/level_widget.dart';
import 'package:flutter/material.dart';

class GameStatusWidget extends StatelessWidget {
  const GameStatusWidget({
    super.key,
    required this.currentRound,
    required this.totalRounds,
    required this.levelProgress,
    required this.combo,
    required this.phase,
    required this.instructionText,
  });

  final int currentRound;
  final int totalRounds;
  final double levelProgress;
  final int combo;
  final GamePhase phase;
  final String instructionText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LevelWidget(
          level: 'Tur $currentRound / $totalRounds',
          progress: levelProgress,
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: combo > 1
              ? Chip(
                  key: ValueKey(combo),
                  avatar: const Icon(Icons.local_fire_department, size: 19),
                  label: Text(
                    '${combo}x Combo',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              : const SizedBox(key: ValueKey('empty-combo'), height: 32),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            instructionText,
            key: ValueKey(phase),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
