import 'package:flutter/material.dart';

class LevelWidget extends StatelessWidget {
  const LevelWidget({super.key, required this.level});

  final String level;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(level, style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      side: BorderSide(color: Theme.of(context).colorScheme.primary),
    );
  }
}
