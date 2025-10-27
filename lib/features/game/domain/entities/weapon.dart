import 'package:equatable/equatable.dart';

enum WeaponType {
  basic,    // Standard single shot
  rapid,    // Fast firing rate
  spread,   // Multiple bullets at once
  laser,    // High damage, slower rate
  rocket,   // Explosive damage
}

class Weapon extends Equatable {
  final WeaponType type;
  final String name;
  final double fireRate;      // Shots per second (lower = faster)
  final int damage;
  final double bulletSpeed;
  final int spreadCount;      // Number of bullets per shot
  final double spreadAngle;   // Angle between spread bullets
  final int bulletColorValue;

  const Weapon({
    required this.type,
    required this.name,
    required this.fireRate,
    required this.damage,
    required this.bulletSpeed,
    this.spreadCount = 1,
    this.spreadAngle = 0,
    required this.bulletColorValue,
  });

  static const Map<WeaponType, Weapon> weapons = {
    WeaponType.basic: Weapon(
      type: WeaponType.basic,
      name: 'Basic Blaster',
      fireRate: 15,  // frames between shots
      damage: 1,
      bulletSpeed: 8,
      bulletColorValue: 0xFFFFFF00, // Yellow
    ),
    WeaponType.rapid: Weapon(
      type: WeaponType.rapid,
      name: 'Rapid Fire',
      fireRate: 8,
      damage: 1,
      bulletSpeed: 10,
      bulletColorValue: 0xFF00FFFF, // Cyan
    ),
    WeaponType.spread: Weapon(
      type: WeaponType.spread,
      name: 'Spread Shot',
      fireRate: 20,
      damage: 1,
      bulletSpeed: 7,
      spreadCount: 3,
      spreadAngle: 0.3,
      bulletColorValue: 0xFF00FF00, // Green
    ),
    WeaponType.laser: Weapon(
      type: WeaponType.laser,
      name: 'Laser Cannon',
      fireRate: 25,
      damage: 3,
      bulletSpeed: 12,
      bulletColorValue: 0xFFFF0000, // Red
    ),
    WeaponType.rocket: Weapon(
      type: WeaponType.rocket,
      name: 'Rocket Launcher',
      fireRate: 30,
      damage: 5,
      bulletSpeed: 6,
      bulletColorValue: 0xFFFFA500, // Orange
    ),
  };

  @override
  List<Object?> get props => [type, name, fireRate, damage, bulletSpeed, spreadCount, spreadAngle, bulletColorValue];
}

