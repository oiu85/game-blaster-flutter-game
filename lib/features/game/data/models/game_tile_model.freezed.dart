// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_tile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameTileModel _$GameTileModelFromJson(Map<String, dynamic> json) {
  return _GameTileModel.fromJson(json);
}

/// @nodoc
mixin _$GameTileModel {
  int get id => throw _privateConstructorUsedError;
  int get colorIndex => throw _privateConstructorUsedError;
  int get row => throw _privateConstructorUsedError;
  int get col => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;

  /// Serializes this GameTileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameTileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameTileModelCopyWith<GameTileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameTileModelCopyWith<$Res> {
  factory $GameTileModelCopyWith(
    GameTileModel value,
    $Res Function(GameTileModel) then,
  ) = _$GameTileModelCopyWithImpl<$Res, GameTileModel>;
  @useResult
  $Res call({int id, int colorIndex, int row, int col, bool isSelected});
}

/// @nodoc
class _$GameTileModelCopyWithImpl<$Res, $Val extends GameTileModel>
    implements $GameTileModelCopyWith<$Res> {
  _$GameTileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameTileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? colorIndex = null,
    Object? row = null,
    Object? col = null,
    Object? isSelected = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            colorIndex: null == colorIndex
                ? _value.colorIndex
                : colorIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            row: null == row
                ? _value.row
                : row // ignore: cast_nullable_to_non_nullable
                      as int,
            col: null == col
                ? _value.col
                : col // ignore: cast_nullable_to_non_nullable
                      as int,
            isSelected: null == isSelected
                ? _value.isSelected
                : isSelected // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameTileModelImplCopyWith<$Res>
    implements $GameTileModelCopyWith<$Res> {
  factory _$$GameTileModelImplCopyWith(
    _$GameTileModelImpl value,
    $Res Function(_$GameTileModelImpl) then,
  ) = __$$GameTileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int colorIndex, int row, int col, bool isSelected});
}

/// @nodoc
class __$$GameTileModelImplCopyWithImpl<$Res>
    extends _$GameTileModelCopyWithImpl<$Res, _$GameTileModelImpl>
    implements _$$GameTileModelImplCopyWith<$Res> {
  __$$GameTileModelImplCopyWithImpl(
    _$GameTileModelImpl _value,
    $Res Function(_$GameTileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameTileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? colorIndex = null,
    Object? row = null,
    Object? col = null,
    Object? isSelected = null,
  }) {
    return _then(
      _$GameTileModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        colorIndex: null == colorIndex
            ? _value.colorIndex
            : colorIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        row: null == row
            ? _value.row
            : row // ignore: cast_nullable_to_non_nullable
                  as int,
        col: null == col
            ? _value.col
            : col // ignore: cast_nullable_to_non_nullable
                  as int,
        isSelected: null == isSelected
            ? _value.isSelected
            : isSelected // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameTileModelImpl implements _GameTileModel {
  const _$GameTileModelImpl({
    required this.id,
    required this.colorIndex,
    required this.row,
    required this.col,
    this.isSelected = false,
  });

  factory _$GameTileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameTileModelImplFromJson(json);

  @override
  final int id;
  @override
  final int colorIndex;
  @override
  final int row;
  @override
  final int col;
  @override
  @JsonKey()
  final bool isSelected;

  @override
  String toString() {
    return 'GameTileModel(id: $id, colorIndex: $colorIndex, row: $row, col: $col, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameTileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.colorIndex, colorIndex) ||
                other.colorIndex == colorIndex) &&
            (identical(other.row, row) || other.row == row) &&
            (identical(other.col, col) || other.col == col) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, colorIndex, row, col, isSelected);

  /// Create a copy of GameTileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameTileModelImplCopyWith<_$GameTileModelImpl> get copyWith =>
      __$$GameTileModelImplCopyWithImpl<_$GameTileModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameTileModelImplToJson(this);
  }
}

abstract class _GameTileModel implements GameTileModel {
  const factory _GameTileModel({
    required final int id,
    required final int colorIndex,
    required final int row,
    required final int col,
    final bool isSelected,
  }) = _$GameTileModelImpl;

  factory _GameTileModel.fromJson(Map<String, dynamic> json) =
      _$GameTileModelImpl.fromJson;

  @override
  int get id;
  @override
  int get colorIndex;
  @override
  int get row;
  @override
  int get col;
  @override
  bool get isSelected;

  /// Create a copy of GameTileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameTileModelImplCopyWith<_$GameTileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
