import 'package:equatable/equatable.dart';

/// Bullet entity for player/enemy projectiles
class Bullet extends Equatable {
  final String id;
  final double x;
  final double y;
  final double speed;
  final bool isPlayerBullet;
  final double width;
  final double height;
  final int damage;
  final int colorValue;

  const Bullet({
    required this.id,
    required this.x,
    required this.y,
    this.speed = 5,
    this.isPlayerBullet = true,
    this.width = 8,
    this.height = 20,
    this.damage = 1,
    this.colorValue = 0xFFFFFF00, // Yellow default
  });

  Bullet copyWith({
    String? id,
    double? x,
    double? y,
    double? speed,
    bool? isPlayerBullet,
    double? width,
    double? height,
    int? damage,
    int? colorValue,
  }) {
    return Bullet(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      speed: speed ?? this.speed,
      isPlayerBullet: isPlayerBullet ?? this.isPlayerBullet,
      width: width ?? this.width,
      height: height ?? this.height,
      damage: damage ?? this.damage,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  Bullet move() {
    final newY = isPlayerBullet ? y - speed : y + speed;
    return copyWith(y: newY);
  }

  @override
  List<Object?> get props => [id, x, y, speed, isPlayerBullet, width, height, damage, colorValue];
}

