import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/enemy.dart';
import '../../domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final SharedPreferences _prefs;
  final Random _random = Random();

  GameRepositoryImpl(this._prefs);

  @override
  Future<Player> initializePlayer(double screenWidth, double screenHeight) async {
    return Player(
      x: screenWidth / 2 - 30,
      y: screenHeight - 100,
      width: 60,
      height: 60,
      health: 100,
      score: 0,
      lives: 3,
      hasBoost: false,
    );
  }

  @override
  Future<Enemy> generateEnemy(double screenWidth) async {
    // Progressive difficulty - enemies get stronger as game progresses
    // This will be called with wave info from the bloc
    final enemyTypes = [
      {'speed': 2.0, 'health': 2, 'type': 0}, // Basic
      {'speed': 3.5, 'health': 3, 'type': 1}, // Fast
      {'speed': 1.0, 'health': 5, 'type': 2}, // Tank
      {'speed': 4.0, 'health': 1, 'type': 3}, // Ultra Fast
      {'speed': 2.5, 'health': 4, 'type': 4}, // Heavy
      {'speed': 1.5, 'health': 6, 'type': 5}, // Super Tank
    ];

    // Higher chance of harder enemies as game progresses
    int type = _random.nextInt(enemyTypes.length);
    if (_random.nextDouble() < 0.3) {
      // 30% chance to spawn harder enemies (types 3-5)
      type = 3 + _random.nextInt(3);
    }

    final enemyData = enemyTypes[type];
    
    return Enemy(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      x: _random.nextDouble() * (screenWidth - 50),
      y: -50,
      speed: enemyData['speed'] as double,
      health: enemyData['health'] as int,
      width: 50,
      height: 50,
      type: enemyData['type'] as int,
    );
  }

  @override
  Future<void> saveScore(int score) async {
    final scores = await getHighScores();
    scores.add(score);
    scores.sort((a, b) => b.compareTo(a));
    
    final topScores = scores.take(10).toList();
    await _prefs.setStringList('high_scores', topScores.map((s) => s.toString()).toList());
  }

  @override
  Future<List<int>> getHighScores() async {
    final scoresJson = _prefs.getStringList('high_scores');
    if (scoresJson == null) return [];
    
    return scoresJson.map((s) => int.tryParse(s) ?? 0).toList();
  }

  @override
  Future<void> saveGameState({
    required Player player,
    required int score,
  }) async {
    await _prefs.setDouble('saved_player_x', player.x);
    await _prefs.setDouble('saved_player_y', player.y);
    await _prefs.setInt('saved_player_health', player.health);
    await _prefs.setInt('saved_score', score);
  }

  @override
  Future<Map<String, dynamic>?> loadGameState() async {
    final x = _prefs.getDouble('saved_player_x');
    final y = _prefs.getDouble('saved_player_y');
    final health = _prefs.getInt('saved_player_health');
    final score = _prefs.getInt('saved_score');
    
    if (x == null || y == null || health == null || score == null) {
      return null;
    }
    
    return {
      'player_x': x,
      'player_y': y,
      'player_health': health,
      'score': score,
    };
  }
}
