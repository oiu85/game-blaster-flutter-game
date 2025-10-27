import 'package:equatable/equatable.dart';
import 'weapon.dart';

/// Player entity representing the game player
class Player extends Equatable {
  final double x;
  final double y;
  final double width;
  final double height;
  final int health;
  final int score;
  final int lives;
  final bool hasBoost;
  final WeaponType currentWeapon;

  const Player({
    required this.x,
    required this.y,
    this.width = 60,
    this.height = 60,
    this.health = 100,
    this.score = 0,
    this.lives = 3,
    this.hasBoost = false,
    this.currentWeapon = WeaponType.basic,
  });

  Player copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    int? health,
    int? score,
    int? lives,
    bool? hasBoost,
    WeaponType? currentWeapon,
  }) {
    return Player(
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      health: health ?? this.health,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      hasBoost: hasBoost ?? this.hasBoost,
      currentWeapon: currentWeapon ?? this.currentWeapon,
    );
  }

  @override
  List<Object?> get props => [x, y, width, height, health, score, lives, hasBoost, currentWeapon];
}

