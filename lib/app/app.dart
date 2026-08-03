import 'package:dokuzu_bul/app/theme/app_theme.dart';
import 'package:dokuzu_bul/features/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';

class DokuzuBulApp extends StatelessWidget {
  const DokuzuBulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dokuzu Bul',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
