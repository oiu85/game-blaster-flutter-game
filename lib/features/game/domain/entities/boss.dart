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
  final int type; // 0-2 for different boss types
  final int phase; // Current phase of the boss (for multi-phase bosses)
  final DateTime spawnTime;

  const Boss({
    required this.id,
    required this.x,
    required this.y,
    this.speed = 1.5,
    required this.health,
    required this.maxHealth,
    this.width = 100,
    this.height = 100,
    this.type = 0,
    this.phase = 1,
    required this.spawnTime,
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
    int? type,
    int? phase,
    DateTime? spawnTime,
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
      type: type ?? this.type,
      phase: phase ?? this.phase,
      spawnTime: spawnTime ?? this.spawnTime,
    );
  }

  Boss move() {
    return copyWith(y: y + speed);
  }

  Boss takeDamage(int damage) {
    final newHealth = (health - damage).clamp(0, maxHealth);
    // Check for phase transitions (every 33% health)
    int newPhase = phase;
    final healthPercent = newHealth / maxHealth;
    if (healthPercent <= 0.33 && phase == 1) {
      newPhase = 2;
    } else if (healthPercent <= 0.66 && phase == 2) {
      newPhase = 3;
    }
    
    return copyWith(
      health: newHealth,
      phase: newPhase,
    );
  }

  bool get isDead => health <= 0;

  @override
  List<Object?> get props => [id, x, y, speed, health, maxHealth, width, height, type, phase, spawnTime];
}

