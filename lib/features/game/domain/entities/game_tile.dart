import 'package:equatable/equatable.dart';

/// Game tile entity representing a single tile on the game board
class GameTile extends Equatable {
  final int id;
  final int colorIndex;
  final int row;
  final int col;
  final bool isSelected;

  const GameTile({
    required this.id,
    required this.colorIndex,
    required this.row,
    required this.col,
    this.isSelected = false,
  });

  GameTile copyWith({
    int? id,
    int? colorIndex,
    int? row,
    int? col,
    bool? isSelected,
  }) {
    return GameTile(
      id: id ?? this.id,
      colorIndex: colorIndex ?? this.colorIndex,
      row: row ?? this.row,
      col: col ?? this.col,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [id, colorIndex, row, col, isSelected];
}

