import 'package:equatable/equatable.dart';

enum PowerUpType {
  health,
  boost,
}

class PowerUp extends Equatable {
  final String id;
  final double x;
  final double y;
  final PowerUpType type;
  final double speed;
  final double width;
  final double height;

  const PowerUp({
    required this.id,
    required this.x,
    required this.y,
    required this.type,
    this.speed = 3,
    this.width = 40,
    this.height = 40,
  });

  PowerUp copyWith({
    String? id,
    double? x,
    double? y,
    PowerUpType? type,
    double? speed,
    double? width,
    double? height,
  }) {
    return PowerUp(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      type: type ?? this.type,
      speed: speed ?? this.speed,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  PowerUp move() {
    return copyWith(y: y + speed);
  }

  @override
  List<Object?> get props => [id, x, y, type, speed, width, height];
}

