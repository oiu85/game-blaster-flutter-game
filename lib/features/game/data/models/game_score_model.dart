import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/game_score.dart';

part 'game_score_model.freezed.dart';
part 'game_score_model.g.dart';

@freezed
class GameScoreModel with _$GameScoreModel {
  const factory GameScoreModel({
    @Default(0) int score,
    @Default(1) int level,
    @Default(0) int moves,
    @Default(0) int matches,
  }) = _GameScoreModel;

  factory GameScoreModel.fromJson(Map<String, dynamic> json) =>
      _$GameScoreModelFromJson(json);
}

extension GameScoreModelX on GameScoreModel {
  GameScore toEntity() {
    return GameScore(
      score: score,
      level: level,
      moves: moves,
      matches: matches,
    );
  }
}

extension GameScoreX on GameScore {
  GameScoreModel toModel() {
    return GameScoreModel(
      score: score,
      level: level,
      moves: moves,
      matches: matches,
    );
  }
}

