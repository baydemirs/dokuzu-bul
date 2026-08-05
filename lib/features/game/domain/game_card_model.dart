class GameCardModel {
  const GameCardModel({
    required this.id,
    required this.number,
    required this.slot,
    this.isFaceVisible = true,
  });

  final int id;
  final int number;
  final int slot;
  final bool isFaceVisible;

  bool get isTarget => number == 9;

  int get row => slot ~/ 3;

  int get column => slot % 3;

  GameCardModel open() {
    return copyWith(isFaceVisible: true);
  }

  GameCardModel close() {
    return copyWith(isFaceVisible: false);
  }

  GameCardModel copyWith({
    int? id,
    int? number,
    int? slot,
    bool? isFaceVisible,
  }) {
    return GameCardModel(
      id: id ?? this.id,
      number: number ?? this.number,
      slot: slot ?? this.slot,
      isFaceVisible: isFaceVisible ?? this.isFaceVisible,
    );
  }
}