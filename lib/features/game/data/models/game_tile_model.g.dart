// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_tile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameTileModelImpl _$$GameTileModelImplFromJson(Map<String, dynamic> json) =>
    _$GameTileModelImpl(
      id: (json['id'] as num).toInt(),
      colorIndex: (json['colorIndex'] as num).toInt(),
      row: (json['row'] as num).toInt(),
      col: (json['col'] as num).toInt(),
      isSelected: json['isSelected'] as bool? ?? false,
    );

Map<String, dynamic> _$$GameTileModelImplToJson(_$GameTileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'colorIndex': instance.colorIndex,
      'row': instance.row,
      'col': instance.col,
      'isSelected': instance.isSelected,
    };
