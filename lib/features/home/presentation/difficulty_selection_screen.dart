import 'package:dokuzu_bul/features/game/domain/difficulty.dart';
import 'package:dokuzu_bul/features/game/extensions/difficulty_extension.dart';
import 'package:flutter/material.dart';

class DifficultySelectionScreen extends StatelessWidget {
  const DifficultySelectionScreen({
    super.key,
    required this.selectedDifficulty,
  });

  final Difficulty selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seviye Seç')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'Oyun zorluğunu seç',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Zorluk arttıkça kartlar daha fazla ve daha hızlı hareket eder.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  children: [
                    _DifficultyCard(
                      difficulty: Difficulty.easy,
                      selectedDifficulty: selectedDifficulty,
                      description: '3 hareket ve 6 saniye seçim süresi.',
                      icon: Icons.sentiment_satisfied_alt,
                    ),
                    const SizedBox(height: 16),
                    _DifficultyCard(
                      difficulty: Difficulty.medium,
                      selectedDifficulty: selectedDifficulty,
                      description: '6 hareket ve 4,5 saniye seçim süresi.',
                      icon: Icons.bolt,
                    ),
                    const SizedBox(height: 16),
                    _DifficultyCard(
                      difficulty: Difficulty.hard,
                      selectedDifficulty: selectedDifficulty,
                      description: '10 hızlı hareket ve 3 saniye seçim süresi.',
                      icon: Icons.local_fire_department,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  const _DifficultyCard({
    required this.difficulty,
    required this.selectedDifficulty,
    required this.description,
    required this.icon,
  });

  final Difficulty difficulty;
  final Difficulty selectedDifficulty;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = difficulty == selectedDifficulty;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pop(context, difficulty);
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
                child: Icon(
                  icon,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      difficulty.label,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                isSelected ? Icons.check_circle : Icons.arrow_forward_ios,
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
