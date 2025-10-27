import 'package:equatable/equatable.dart';

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

