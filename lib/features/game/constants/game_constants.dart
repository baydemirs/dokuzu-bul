abstract final class GameConstants {
  static const int totalCards = 9;
  static const int totalRounds = 5;
  static const int initialLives = 3;

  static const int baseScore = 100;

  static const int easyMoveCount = 3;
  static const int mediumMoveCount = 6;
  static const int hardMoveCount = 10;

  static const double easySelectionSeconds = 6;
  static const double mediumSelectionSeconds = 4.5;
  static const double hardSelectionSeconds = 3;

  static const Duration previewDuration = Duration(milliseconds: 1800);

  static const Duration cardHideDuration = Duration(milliseconds: 600);

  static const Duration easyShuffleDuration = Duration(milliseconds: 600);

  static const Duration mediumShuffleDuration = Duration(milliseconds: 450);

  static const Duration hardShuffleDuration = Duration(milliseconds: 300);

  static const Duration feedbackDuration = Duration(milliseconds: 1400);

  static const Duration timerTickDuration = Duration(milliseconds: 100);
}
