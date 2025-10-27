import 'package:equatable/equatable.dart';

class Coin extends Equatable {
  final String id;
  final double x;
  final double y;
  final double speed;
  final int value;
  final double width;
  final double height;

  const Coin({
    required this.id,
    required this.x,
    required this.y,
    this.speed = 2.0,
    this.value = 1,
    this.width = 20,
    this.height = 20,
  });

  Coin copyWith({
    String? id,
    double? x,
    double? y,
    double? speed,
    int? value,
    double? width,
    double? height,
  }) {
    return Coin(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      speed: speed ?? this.speed,
      value: value ?? this.value,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  Coin move() {
    return copyWith(y: y + speed);
  }

  @override
  List<Object?> get props => [id, x, y, speed, value, width, height];
}

