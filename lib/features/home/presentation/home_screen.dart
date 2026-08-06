import 'package:dokuzu_bul/features/game/domain/difficulty.dart';
import 'package:dokuzu_bul/features/game/extensions/difficulty_extension.dart';
import 'package:dokuzu_bul/features/game/presentation/game_screen.dart';
import 'package:dokuzu_bul/features/home/presentation/difficulty_selection_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Difficulty _selectedDifficulty = Difficulty.easy;

  Future<void> _openDifficultySelection() async {
    final Difficulty? selectedDifficulty = await Navigator.push<Difficulty>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DifficultySelectionScreen(
            selectedDifficulty: _selectedDifficulty,
          );
        },
      ),
    );

    if (!mounted || selectedDifficulty == null) {
      return;
    }

    setState(() {
      _selectedDifficulty = selectedDifficulty;
    });
  }

  void _startNewGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return GameScreen(difficulty: _selectedDifficulty);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'DOKUZU BUL',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  '9 kartını takip et ve doğru kartı bul.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                Chip(
                  avatar: const Icon(Icons.speed, size: 20),
                  label: Text(
                    'Seviye: ${_selectedDifficulty.label}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startNewGame,
                    child: const Text('Yeni Oyun'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _openDifficultySelection,
                    child: const Text('Seviye Seç'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(onPressed: () {}, child: const Text('Ayarlar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
