import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/bullet.dart';
import '../../domain/entities/enemy.dart';
import '../../domain/entities/powerup.dart';
import '../../domain/entities/coin.dart';
import '../../domain/entities/boss.dart';
import '../../domain/entities/weapon.dart';
import '../../../../core/utils/page_state.dart';
import '../../../../core/utils/game_settings.dart';
import 'shooter_event.dart';
import 'shooter_state.dart';

class ShooterBloc extends Bloc<ShooterEvent, ShooterState> {
  final GameRepository _repository;
  Timer? _gameTimer;
  Timer? _enemySpawnTimer;
    Timer? _powerUpSpawnTimer;
  final Random _random = Random();
  int _bulletIdCounter = 0;
  int _powerUpIdCounter = 0;
  int _enemiesKilledThisWave = 0;
  int _currentWave = 1;

  ShooterBloc(this._repository)
      : super(
          ShooterState(
            player: const Player(x: 0, y: 0),
            pageState: PageState.initial,
          ),
        ) {
    on<GameInitialized>(_onGameInitialized);
    on<PlayerMoved>(_onPlayerMoved);
    on<PlayerShoot>(_onPlayerShoot);
    on<PlayerShootStart>(_onPlayerShootStart);
    on<PlayerShootStop>(_onPlayerShootStop);
    on<GameUpdate>(_onGameUpdate);
    on<GamePaused>(_onGamePaused);
    on<GameResumed>(_onGameResumed);
    on<GameReset>(_onGameReset);
    on<LevelComplete>(_onLevelComplete);
    on<NextLevel>(_onNextLevel);
    on<SpawnEnemyInternalEvent>(_onSpawnEnemy);
    on<RemoveExplosionsEvent>(_onRemoveExplosions);
    on<SpawnPowerUpInternalEvent>(_onSpawnPowerUp);
    on<SpawnCoinInternalEvent>(_onSpawnCoin);
    on<SpawnBossInternalEvent>(_onSpawnBoss);
    on<RemoveBoostEvent>(_onRemoveBoost);
    on<ScreenShakeEvent>(_onScreenShake);
  }

  void _onSpawnEnemy(
    SpawnEnemyInternalEvent event,
    Emitter<ShooterState> emit,
  ) {
    emit(state.copyWith(enemies: [...state.enemies, event.enemy]));
  }

  Future<void> _onGameInitialized(
    GameInitialized event,
    Emitter<ShooterState> emit,
  ) async {
    emit(state.copyWith(pageState: PageState.loading));

          try {
            final player = await _repository.initializePlayer(
              event.screenWidth,
              event.screenHeight,
            );

            // Load selected weapon from settings
            final prefs = await SharedPreferences.getInstance();
            final weaponIndex = prefs.getInt('selected_weapon') ?? 0;
            final selectedWeapon = WeaponType.values[weaponIndex.clamp(0, WeaponType.values.length - 1)];

            // Load coins from storage
            final prefsCoins = await SharedPreferences.getInstance();
            final savedCoins = prefsCoins.getInt('player_coins') ?? 0;

            emit(
              state.copyWith(
                pageState: PageState.success,
                player: player.copyWith(lives: 3, currentWeapon: selectedWeapon),
                screenWidth: event.screenWidth,
                screenHeight: event.screenHeight,
                score: 0,
                wave: 1,
                level: 1,
                coins: savedCoins,
                bullets: [],
                enemies: [],
                powerUps: [],
                coinsOnScreen: [],
                isGameOver: false,
                isPaused: false,
                isLevelComplete: false,
                currentBoss: null,
              ),
            );
      
      _enemiesKilledThisWave = 0;
      _currentWave = 1;

      _startGameLoop();
    } catch (e) {
      emit(
        state.copyWith(
          pageState: PageState.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onPlayerMoved(
    PlayerMoved event,
    Emitter<ShooterState> emit,
  ) {
    if (state.isPaused || state.isGameOver) return;

    final newX = (state.player.x + event.deltaX)
        .clamp(0.0, state.screenWidth - state.player.width);

    emit(
      state.copyWith(
        player: state.player.copyWith(x: newX),
      ),
    );
  }

  void _onPlayerShoot(
    PlayerShoot event,
    Emitter<ShooterState> emit,
  ) {
    if (state.isPaused || state.isGameOver) return;
    _shootBullet(emit);
  }

  void _onPlayerShootStart(
    PlayerShootStart event,
    Emitter<ShooterState> emit,
  ) {
    emit(state.copyWith(isShooting: true));
    // Reset bullet counter and shoot immediately
    _bulletIdCounter = 0;
    if (!state.isPaused && !state.isGameOver) {
      _shootBullet(emit);
    }
  }

  void _onPlayerShootStop(
    PlayerShootStop event,
    Emitter<ShooterState> emit,
  ) {
    emit(state.copyWith(isShooting: false));
    // Reset bullet counter when stopping
    _bulletIdCounter = 0;
  }

  void _shootBullet(Emitter<ShooterState> emit) {
    final weapon = Weapon.weapons[state.player.currentWeapon]!;
    final bulletId = DateTime.now().millisecondsSinceEpoch.toString();
    
      // Handle spread weapons
      if (weapon.spreadCount > 1) {
        final bullets = <Bullet>[];
        for (int i = 0; i < weapon.spreadCount; i++) {
          final angle = (i - (weapon.spreadCount - 1) / 2) * weapon.spreadAngle;
          final offsetX = angle * 30; // Horizontal spread offset
          final bullet = Bullet(
            id: '${bulletId}_$i',
            x: state.player.x + state.player.width / 2 - 4 + offsetX,
            y: state.player.y,
            speed: weapon.bulletSpeed,
            isPlayerBullet: true,
            damage: weapon.damage,
            colorValue: weapon.bulletColorValue,
          );
          bullets.add(bullet);
        }
        emit(
          state.copyWith(
            bullets: [...state.bullets, ...bullets],
          ),
        );
      } else {
        // Single bullet
        final bullet = Bullet(
          id: bulletId,
          x: state.player.x + state.player.width / 2 - 4,
          y: state.player.y,
          speed: weapon.bulletSpeed,
          isPlayerBullet: true,
          damage: weapon.damage,
          colorValue: weapon.bulletColorValue,
        );

        emit(
          state.copyWith(
            bullets: [...state.bullets, bullet],
          ),
        );
      }
  }

  Future<void> _onGameUpdate(
    GameUpdate event,
    Emitter<ShooterState> emit,
  ) async {
    if (state.isPaused || state.isGameOver) return;

    // Shoot continuously while dragging (shooting mode active)
    // Use weapon-specific fire rate
    if (state.isShooting) {
      final weapon = Weapon.weapons[state.player.currentWeapon]!;
      _bulletIdCounter++;
      final fireRate = weapon.fireRate.round();
      if (_bulletIdCounter % fireRate == 0) {
        _shootBullet(emit);
      }
    }

    // Move bullets
    final updatedBullets = state.bullets
        .map((b) => b.move())
        .where((b) => b.y > -50 && b.y < state.screenHeight + 50)
        .toList();

    // Move enemies
    final updatedEnemies = state.enemies
        .map((e) => e.move())
        .where((e) => e.y < state.screenHeight + 100)
        .toList();

    // Move power-ups
    var updatedPowerUps = state.powerUps
        .map((p) => p.move())
        .where((p) => p.y < state.screenHeight + 100)
        .toList();

    // Move coins
    final updatedCoins = state.coinsOnScreen
        .map((c) => c.move())
        .where((c) => c.y < state.screenHeight + 100)
        .toList();

    // Move boss
    Boss? updatedBoss = state.currentBoss?.move();
    if (updatedBoss != null && updatedBoss.y > state.screenHeight + 100) {
      updatedBoss = null;
    }

    // Check collisions: bullets vs enemies
    final remainingBullets = <Bullet>[];
    final remainingEnemies = <Enemy>[];
    final killedEnemies = <String>[];
    int newScore = state.score;
    final bulletsToRemoveFromBoss = <Bullet>[];

    for (final bullet in updatedBullets) {
      bool hit = false;
      for (final enemy in updatedEnemies) {
        if (_checkCollision(bullet, enemy)) {
          hit = true;
          // Apply bullet damage
          var damagedEnemy = enemy;
          for (int i = 0; i < bullet.damage; i++) {
            damagedEnemy = damagedEnemy.takeDamage();
          }
          if (damagedEnemy.health > 0) {
            // Enemy still alive - update it
            if (!remainingEnemies.any((e) => e.id == enemy.id)) {
              remainingEnemies.add(damagedEnemy);
            } else {
              // Replace existing enemy with damaged version
              final index = remainingEnemies.indexWhere((e) => e.id == enemy.id);
              if (index != -1) {
                remainingEnemies[index] = damagedEnemy;
              }
            }
          } else {
            // Enemy killed - add to killed list for explosion effect
            killedEnemies.add(enemy.id);
            _enemiesKilledThisWave++;
            
            // Apply difficulty multiplier to score
            final difficulty = await GameSettings.getDifficulty();
            final multiplier = GameSettings.getDifficultyMultiplier(difficulty);
            newScore += (10 * (enemy.type + 1) * _currentWave * multiplier).round();
            
            // Spawn coin when enemy is killed
            final coin = Coin(
              id: 'coin_${DateTime.now().millisecondsSinceEpoch}',
              x: enemy.x + enemy.width / 2 - 10,
              y: enemy.y + enemy.height / 2,
              value: 1 + (enemy.type ~/ 2),
            );
            add(SpawnCoinInternalEvent(coin));
            
            // Add screen shake on kill (if enabled)
            final shakeEnabled = await GameSettings.isScreenShakeEnabled();
            if (shakeEnabled) {
              add(const ScreenShakeEvent(intensity: 5.0));
            }
          }
          break;
        }
      }
      if (!hit && bullet.isPlayerBullet) {
        remainingBullets.add(bullet);
      }
    }

    // Add enemies that weren't hit
    for (final enemy in updatedEnemies) {
      if (!remainingEnemies.any((e) => e.id == enemy.id) && 
          !killedEnemies.contains(enemy.id)) {
        remainingEnemies.add(enemy);
      }
    }

    // Check player collision with power-ups
    final remainingPowerUps = <PowerUp>[];
    Player updatedPlayer = state.player;
    
    for (final powerUp in updatedPowerUps) {
      if (_checkPowerUpCollision(state.player, powerUp)) {
        // Collect power-up
        if (powerUp.type == PowerUpType.health) {
          updatedPlayer = updatedPlayer.copyWith(
            health: (updatedPlayer.health + 20).clamp(0, 100),
          );
        } else if (powerUp.type == PowerUpType.boost) {
          updatedPlayer = updatedPlayer.copyWith(hasBoost: true);
          // Boost expires after 5 seconds
          Future.delayed(const Duration(seconds: 5), () {
            if (!isClosed) {
              add(const RemoveBoostEvent());
            }
          });
        }
      } else {
        remainingPowerUps.add(powerUp);
      }
    }

    // Check player collision with coins
    final remainingCoins = <Coin>[];
    int coinsCollected = 0;
    
    for (final coin in updatedCoins) {
      if (_checkCoinCollision(state.player, coin)) {
        coinsCollected += coin.value;
      } else {
        remainingCoins.add(coin);
      }
    }

    // Check bullet collision with boss
    Boss? boss = updatedBoss;
    if (boss != null) {
      for (final bullet in remainingBullets) {
        final currentBoss = boss;
        if (currentBoss != null && _checkBossCollision(bullet, currentBoss)) {
          bulletsToRemoveFromBoss.add(bullet);
          // Damage boss
          var damagedBoss = currentBoss;
          for (int i = 0; i < bullet.damage; i++) {
            damagedBoss = damagedBoss.takeDamage();
          }
          boss = damagedBoss;
          
          if (damagedBoss.health <= 0) {
            // Boss killed
            final bossX = damagedBoss.x;
            final bossY = damagedBoss.y;
            newScore += 500 * state.level;
            // Spawn multiple coins
            for (int i = 0; i < 10; i++) {
              final coin = Coin(
                id: 'boss_coin_${DateTime.now().millisecondsSinceEpoch}_$i',
                x: bossX + (i * 8),
                y: bossY,
                value: 5,
              );
              add(SpawnCoinInternalEvent(coin));
            }
            boss = null;
            updatedBoss = null;
          }
          break;
        }
      }
    }
    
    // Filter out bullets that hit boss
    final finalRemainingBullets = remainingBullets.where((b) => !bulletsToRemoveFromBoss.contains(b)).toList();

    // Check player collision with enemies
    bool gameOver = false;
    for (final enemy in remainingEnemies) {
      if (_checkPlayerCollision(updatedPlayer, enemy)) {
        // Player loses a life
        if (updatedPlayer.lives > 1) {
          updatedPlayer = updatedPlayer.copyWith(
            lives: updatedPlayer.lives - 1,
            health: 100, // Reset health
          );
        } else {
          gameOver = true;
        }
        break;
      }
    }

    // Enemy spawning is handled by _enemySpawnTimer
    List<Enemy> enemiesWithSpawn = List.from(remainingEnemies);

    // Add explosion effects for killed enemies
    final updatedExplosions = Map<String, ExplosionData>.from(state.explosions);
    for (final enemyId in killedEnemies) {
      final enemy = updatedEnemies.firstWhere(
        (e) => e.id == enemyId,
        orElse: () => enemiesWithSpawn.firstWhere(
          (e) => e.id == enemyId,
          orElse: () => const Enemy(id: '', x: 0, y: 0),
        ),
      );
      if (enemy.id.isNotEmpty) {
        updatedExplosions[enemyId] = ExplosionData(
          x: enemy.x,
          y: enemy.y,
          timestamp: DateTime.now(),
        );
      }
    }

    // Check for wave progression (every 10 enemies killed = 1 level)
    int updatedWave = state.wave;
    int updatedLevel = state.level;
    bool levelComplete = false;
    
    if (_enemiesKilledThisWave >= 10) {
      updatedWave++;
      _enemiesKilledThisWave = 0;
      _currentWave = updatedWave;
      
      // Complete level after 10 waves
      if (updatedWave > state.level * 10) {
        updatedLevel++;
        levelComplete = true;
        // Stop game loop for level complete screen
        _stopGameLoop();
      }
      
      // Spawn boss every 4 levels
      if (updatedLevel % 4 == 0 && updatedLevel > state.level && state.currentBoss == null) {
        final boss = Boss(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          x: state.screenWidth / 2 - 40,
          y: -80,
          speed: 0.8,
          health: 20 + (updatedLevel * 5),
          maxHealth: 20 + (updatedLevel * 5),
          level: updatedLevel,
          type: _getBossType(updatedLevel),
        );
        add(SpawnBossInternalEvent(boss));
      }
      
      // Big screen shake on wave completion (if enabled)
      final shakeEnabled = await GameSettings.isScreenShakeEnabled();
      if (shakeEnabled) {
        add(const ScreenShakeEvent(intensity: 15.0));
      }
    }

    // Reduce screen shake over time - check if enabled in settings
    double updatedShake = state.screenShake * 0.9;
    if (updatedShake < 0.1) updatedShake = 0.0;
    
    // Apply screen shake setting
    final shakeEnabledFinal = await GameSettings.isScreenShakeEnabled();
    if (!shakeEnabledFinal) updatedShake = 0.0;

    emit(
      state.copyWith(
        bullets: finalRemainingBullets,
        enemies: enemiesWithSpawn,
        powerUps: remainingPowerUps,
        coinsOnScreen: remainingCoins,
        player: updatedPlayer,
        score: newScore,
        wave: updatedWave,
        level: updatedLevel,
        coins: state.coins + coinsCollected,
        isGameOver: gameOver,
        isLevelComplete: levelComplete,
        explosions: updatedExplosions,
        screenShake: updatedShake,
        currentBoss: boss,
      ),
    );

    // Save coins if collected
    if (coinsCollected > 0) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('player_coins', state.coins + coinsCollected);
    }

    // Remove explosions after animation duration
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!isClosed) {
        add(RemoveExplosionsEvent(killedEnemies));
      }
    });

    if (gameOver) {
      _stopGameLoop();
      _repository.saveScore(newScore);
    }
  }

  void _onGamePaused(
    GamePaused event,
    Emitter<ShooterState> emit,
  ) {
    _stopGameLoop();
    emit(state.copyWith(isPaused: true));
  }

  void _onGameResumed(
    GameResumed event,
    Emitter<ShooterState> emit,
  ) {
    emit(state.copyWith(isPaused: false));
    _startGameLoop();
  }

  Future<void> _onGameReset(
    GameReset event,
    Emitter<ShooterState> emit,
  ) async {
    _stopGameLoop();
    
    final player = await _repository.initializePlayer(
      state.screenWidth,
      state.screenHeight,
    );

      emit(
        state.copyWith(
          player: player.copyWith(lives: 3),
          bullets: [],
          enemies: [],
          powerUps: [],
          score: 0,
          wave: 1,
          isGameOver: false,
          isPaused: false,
          explosions: {},
        ),
      );
      
      _enemiesKilledThisWave = 0;
      _currentWave = 1;

    _startGameLoop();
  }

  void _startGameLoop() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      add(const GameUpdate());
    });

    _enemySpawnTimer?.cancel();
    // Spawn enemies faster as waves increase - progressive difficulty
    final baseInterval = 2000;
    final waveMultiplier = state.wave.clamp(1, 20);
    
    // Apply difficulty setting
    GameSettings.getDifficulty().then((difficulty) {
      final diffMultiplier = GameSettings.getDifficultyMultiplier(difficulty);
      final spawnInterval = Duration(
        milliseconds: ((baseInterval - (waveMultiplier * 80)) / diffMultiplier).clamp(300, 2000).round(),
      );
      
      // Spawn multiple enemies per wave (more enemies at higher waves)
      final enemiesPerSpawn = ((waveMultiplier / 3) * diffMultiplier).ceil().clamp(1, 6);
      
      _enemySpawnTimer = Timer.periodic(spawnInterval, (_) {
        if (!state.isPaused && !state.isGameOver) {
          for (int i = 0; i < enemiesPerSpawn; i++) {
            Future.delayed(Duration(milliseconds: i * 50), () {
              _repository.generateEnemy(state.screenWidth).then((enemy) {
                if (!isClosed) {
                  // Make enemies faster and stronger based on wave and difficulty
                  final boostedEnemy = enemy.copyWith(
                    speed: enemy.speed * (1 + (state.wave * 0.1)) * diffMultiplier,
                    health: enemy.health + (state.wave ~/ 3),
                  );
                  add(SpawnEnemyInternalEvent(boostedEnemy));
                }
              });
            });
          }
        }
      });
    });

    _powerUpSpawnTimer?.cancel();
    _powerUpSpawnTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!state.isPaused && !state.isGameOver && _random.nextDouble() < 0.5) {
        final powerUpType = _random.nextBool() 
            ? PowerUpType.health 
            : PowerUpType.boost;
        final powerUp = PowerUp(
          id: 'powerup_${_powerUpIdCounter++}',
          x: _random.nextDouble() * (state.screenWidth - 40),
          y: -40,
          type: powerUpType,
        );
        add(SpawnPowerUpInternalEvent(powerUp));
      }
    });
  }

  void _stopGameLoop() {
    _gameTimer?.cancel();
    _enemySpawnTimer?.cancel();
    _powerUpSpawnTimer?.cancel();
  }


  bool _checkCollision(Bullet bullet, Enemy enemy) {
    return bullet.x < enemy.x + enemy.width &&
        bullet.x + bullet.width > enemy.x &&
        bullet.y < enemy.y + enemy.height &&
        bullet.y + bullet.height > enemy.y;
  }

  bool _checkPlayerCollision(Player player, Enemy enemy) {
    return player.x < enemy.x + enemy.width &&
        player.x + player.width > enemy.x &&
        player.y < enemy.y + enemy.height &&
        player.y + player.height > enemy.y;
  }

  bool _checkPowerUpCollision(Player player, PowerUp powerUp) {
    return player.x < powerUp.x + powerUp.width &&
        player.x + player.width > powerUp.x &&
        player.y < powerUp.y + powerUp.height &&
        player.y + player.height > powerUp.y;
  }

  void _onSpawnPowerUp(
    SpawnPowerUpInternalEvent event,
    Emitter<ShooterState> emit,
  ) {
    emit(state.copyWith(powerUps: [...state.powerUps, event.powerUp]));
  }

  void _onSpawnCoin(
    SpawnCoinInternalEvent event,
    Emitter<ShooterState> emit,
  ) {
    emit(state.copyWith(coinsOnScreen: [...state.coinsOnScreen, event.coin]));
  }

  void _onSpawnBoss(
    SpawnBossInternalEvent event,
    Emitter<ShooterState> emit,
  ) {
    emit(state.copyWith(currentBoss: event.boss));
  }

  void _onLevelComplete(
    LevelComplete event,
    Emitter<ShooterState> emit,
  ) {
    emit(state.copyWith(isLevelComplete: true, isPaused: true));
  }

  Future<void> _onNextLevel(
    NextLevel event,
    Emitter<ShooterState> emit,
  ) async {
    emit(state.copyWith(
      isLevelComplete: false,
      isPaused: false,
      wave: 1,
      bullets: [],
      enemies: [],
      powerUps: [],
      coinsOnScreen: [],
      explosions: {},
      currentBoss: null,
    ));
    _enemiesKilledThisWave = 0;
    _currentWave = 1;
    _startGameLoop();
  }


  void _onRemoveBoost(
    RemoveBoostEvent event,
    Emitter<ShooterState> emit,
  ) {
    emit(
      state.copyWith(
        player: state.player.copyWith(hasBoost: false),
      ),
    );
  }

  BossType _getBossType(int level) {
    if (level <= 4) return BossType.basic;
    if (level <= 8) return BossType.advanced;
    if (level <= 12) return BossType.elite;
    return BossType.ultimate;
  }

  bool _checkCoinCollision(Player player, Coin coin) {
    return player.x < coin.x + coin.width &&
        player.x + player.width > coin.x &&
        player.y < coin.y + coin.height &&
        player.y + player.height > coin.y;
  }

  bool _checkBossCollision(Bullet bullet, Boss boss) {
    return bullet.x < boss.x + boss.width &&
        bullet.x + bullet.width > boss.x &&
        bullet.y < boss.y + boss.height &&
        bullet.y + bullet.height > boss.y;
  }

  void _onScreenShake(
    ScreenShakeEvent event,
    Emitter<ShooterState> emit,
  ) {
    emit(state.copyWith(screenShake: event.intensity));
  }

  void _onRemoveExplosions(
    RemoveExplosionsEvent event,
    Emitter<ShooterState> emit,
  ) {
    final updatedExplosions = Map<String, ExplosionData>.from(state.explosions);
    for (final id in event.explosionIds) {
      updatedExplosions.remove(id);
    }
    emit(state.copyWith(explosions: updatedExplosions));
  }

  @override
  Future<void> close() {
    _stopGameLoop();
    return super.close();
  }
}

