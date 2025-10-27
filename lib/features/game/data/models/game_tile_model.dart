import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/game_tile.dart';

part 'game_tile_model.freezed.dart';
part 'game_tile_model.g.dart';

@freezed
class GameTileModel with _$GameTileModel {
  const factory GameTileModel({
    required int id,
    required int colorIndex,
    required int row,
    required int col,
    @Default(false) bool isSelected,
  }) = _GameTileModel;

  factory GameTileModel.fromJson(Map<String, dynamic> json) =>
      _$GameTileModelFromJson(json);
}

extension GameTileModelX on GameTileModel {
  GameTile toEntity() {
    return GameTile(
      id: id,
      colorIndex: colorIndex,
      row: row,
      col: col,
      isSelected: isSelected,
    );
  }
}

extension GameTileX on GameTile {
  GameTileModel toModel() {
    return GameTileModel(
      id: id,
      colorIndex: colorIndex,
      row: row,
      col: col,
      isSelected: isSelected,
    );
  }
}

