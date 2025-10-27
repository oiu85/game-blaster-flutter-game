// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_score_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameScoreModelImpl _$$GameScoreModelImplFromJson(Map<String, dynamic> json) =>
    _$GameScoreModelImpl(
      score: (json['score'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      moves: (json['moves'] as num?)?.toInt() ?? 0,
      matches: (json['matches'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$GameScoreModelImplToJson(
  _$GameScoreModelImpl instance,
) => <String, dynamic>{
  'score': instance.score,
  'level': instance.level,
  'moves': instance.moves,
  'matches': instance.matches,
};
