import 'package:equatable/equatable.dart';

class Boss extends Equatable {
  final String id;
  final double x;
  final double y;
  final double speed;
  final int health;
  final int maxHealth;
  final double width;
  final double height;
  final int level;
  final BossType type;

  const Boss({
    required this.id,
    required this.x,
    required this.y,
    this.speed = 1.0,
    required this.health,
    required this.maxHealth,
    this.width = 80,
    this.height = 80,
    required this.level,
    required this.type,
  });

  Boss copyWith({
    String? id,
    double? x,
    double? y,
    double? speed,
    int? health,
    int? maxHealth,
    double? width,
    double? height,
    int? level,
    BossType? type,
  }) {
    return Boss(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      speed: speed ?? this.speed,
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      width: width ?? this.width,
      height: height ?? this.height,
      level: level ?? this.level,
      type: type ?? this.type,
    );
  }

  Boss takeDamage() {
    return copyWith(health: (health - 1).clamp(0, maxHealth));
  }

  Boss move() {
    return copyWith(y: y + speed);
  }

  @override
  List<Object?> get props => [id, x, y, speed, health, maxHealth, width, height, level, type];
}

enum BossType {
  basic,
  advanced,
  elite,
  ultimate,
}
