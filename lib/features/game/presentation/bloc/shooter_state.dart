import 'package:equatable/equatable.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/bullet.dart';
import '../../domain/entities/enemy.dart';
import '../../domain/entities/powerup.dart';
import '../../domain/entities/coin.dart';
import '../../domain/entities/boss.dart';
import '../../../../core/utils/page_state.dart';

class ExplosionData extends Equatable {
  final double x;
  final double y;
  final DateTime timestamp;

  const ExplosionData({
    required this.x,
    required this.y,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [x, y, timestamp];
}

class ShooterState extends Equatable {
  final PageState pageState;
  final Player player;
  final List<Bullet> bullets;
  final List<Enemy> enemies;
  final List<PowerUp> powerUps;
  final int score;
  final int wave;
  final int level;
  final int coins;
  final bool isPaused;
  final bool isGameOver;
  final bool isLevelComplete;
  final String? errorMessage;
  final double screenWidth;
  final double screenHeight;
  final bool isShooting;
  final Map<String, ExplosionData> explosions; // Enemy ID -> Explosion position
  final double screenShake; // Screen shake intensity
  final List<Coin> coinsOnScreen;
  final Boss? currentBoss;

  const ShooterState({
    this.pageState = PageState.initial,
    required this.player,
    this.bullets = const [],
    this.enemies = const [],
    this.powerUps = const [],
    this.coinsOnScreen = const [],
    this.score = 0,
    this.wave = 1,
    this.level = 1,
    this.coins = 0,
    this.isPaused = false,
    this.isGameOver = false,
    this.isLevelComplete = false,
    this.errorMessage,
    this.screenWidth = 375,
    this.screenHeight = 812,
    this.isShooting = false,
    this.explosions = const {},
    this.screenShake = 0.0,
    this.currentBoss,
  });

  ShooterState copyWith({
    PageState? pageState,
    Player? player,
    List<Bullet>? bullets,
    List<Enemy>? enemies,
    List<PowerUp>? powerUps,
    List<Coin>? coinsOnScreen,
    int? score,
    int? wave,
    int? level,
    int? coins,
    bool? isPaused,
    bool? isGameOver,
    bool? isLevelComplete,
    String? errorMessage,
    double? screenWidth,
    double? screenHeight,
    bool? isShooting,
    Map<String, ExplosionData>? explosions,
    double? screenShake,
    Boss? currentBoss,
  }) {
    return ShooterState(
      pageState: pageState ?? this.pageState,
      player: player ?? this.player,
      bullets: bullets ?? this.bullets,
      enemies: enemies ?? this.enemies,
      powerUps: powerUps ?? this.powerUps,
      coinsOnScreen: coinsOnScreen ?? this.coinsOnScreen,
      score: score ?? this.score,
      wave: wave ?? this.wave,
      level: level ?? this.level,
      coins: coins ?? this.coins,
      isPaused: isPaused ?? this.isPaused,
      isGameOver: isGameOver ?? this.isGameOver,
      isLevelComplete: isLevelComplete ?? this.isLevelComplete,
      errorMessage: errorMessage,
      screenWidth: screenWidth ?? this.screenWidth,
      screenHeight: screenHeight ?? this.screenHeight,
      isShooting: isShooting ?? this.isShooting,
      explosions: explosions ?? this.explosions,
      screenShake: screenShake ?? this.screenShake,
      currentBoss: currentBoss ?? this.currentBoss,
    );
  }

  @override
  List<Object?> get props => [
        pageState,
        player,
        bullets,
        enemies,
        powerUps,
        coinsOnScreen,
        score,
        wave,
        level,
        coins,
        isPaused,
        isGameOver,
        isLevelComplete,
        errorMessage,
        screenWidth,
        screenHeight,
        isShooting,
        explosions,
        screenShake,
        currentBoss,
      ];
}

