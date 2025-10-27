import 'package:equatable/equatable.dart';

/// Enemy entity for game enemies
class Enemy extends Equatable {
  final String id;
  final double x;
  final double y;
  final double speed;
  final int health;
  final double width;
  final double height;
  final int type; // 0-5 = different enemy types with different shapes/behaviors

  const Enemy({
    required this.id,
    required this.x,
    required this.y,
    this.speed = 2,
    this.health = 1,
    this.width = 50,
    this.height = 50,
    this.type = 0,
  });

  Enemy copyWith({
    String? id,
    double? x,
    double? y,
    double? speed,
    int? health,
    double? width,
    double? height,
    int? type,
  }) {
    return Enemy(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      speed: speed ?? this.speed,
      health: health ?? this.health,
      width: width ?? this.width,
      height: height ?? this.height,
      type: type ?? this.type,
    );
  }

  Enemy move() {
    return copyWith(y: y + speed);
  }

  Enemy takeDamage() {
    return copyWith(health: health - 1);
  }

  @override
  List<Object?> get props => [id, x, y, speed, health, width, height, type];
}

