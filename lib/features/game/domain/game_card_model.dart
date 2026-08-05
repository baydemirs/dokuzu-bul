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
