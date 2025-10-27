import 'package:equatable/equatable.dart';
import '../../domain/entities/enemy.dart';
import '../../domain/entities/powerup.dart';
import '../../domain/entities/coin.dart';
import '../../domain/entities/boss.dart';

abstract class ShooterEvent extends Equatable {
  const ShooterEvent();

  @override
  List<Object?> get props => [];
}

class GameInitialized extends ShooterEvent {
  final double screenWidth;
  final double screenHeight;

  const GameInitialized({
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  List<Object?> get props => [screenWidth, screenHeight];
}

class PlayerMoved extends ShooterEvent {
  final double deltaX;

  const PlayerMoved(this.deltaX);

  @override
  List<Object?> get props => [deltaX];
}

class PlayerShoot extends ShooterEvent {
  const PlayerShoot();
}

class PlayerShootStart extends ShooterEvent {
  const PlayerShootStart();
}

class PlayerShootStop extends ShooterEvent {
  const PlayerShootStop();
}

class GameUpdate extends ShooterEvent {
  const GameUpdate();
}

class GamePaused extends ShooterEvent {
  const GamePaused();
}

class GameResumed extends ShooterEvent {
  const GameResumed();
}

class GameReset extends ShooterEvent {
  const GameReset();
}

class LevelComplete extends ShooterEvent {
  const LevelComplete();
}

class NextLevel extends ShooterEvent {
  const NextLevel();
}

// Internal events - exported but only used within bloc
class ScreenShakeEvent extends ShooterEvent {
  final double intensity;

  const ScreenShakeEvent({required this.intensity});

  @override
  List<Object?> get props => [intensity];
}

class SpawnEnemyInternalEvent extends ShooterEvent {
  final Enemy enemy;

  SpawnEnemyInternalEvent(this.enemy);

  @override
  List<Object?> get props => [enemy];
}

class RemoveExplosionsEvent extends ShooterEvent {
  final List<String> explosionIds;

  RemoveExplosionsEvent(this.explosionIds);

  @override
  List<Object?> get props => [explosionIds];
}

class SpawnPowerUpInternalEvent extends ShooterEvent {
  final PowerUp powerUp;

  SpawnPowerUpInternalEvent(this.powerUp);

  @override
  List<Object?> get props => [powerUp];
}

class SpawnCoinInternalEvent extends ShooterEvent {
  final Coin coin;

  SpawnCoinInternalEvent(this.coin);

  @override
  List<Object?> get props => [coin];
}

class SpawnBossInternalEvent extends ShooterEvent {
  final Boss boss;

  SpawnBossInternalEvent(this.boss);

  @override
  List<Object?> get props => [boss];
}

class RemoveBoostEvent extends ShooterEvent {
  const RemoveBoostEvent();

  @override
  List<Object?> get props => [];
}

