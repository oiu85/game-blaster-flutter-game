import '../entities/player.dart';
import '../entities/enemy.dart';

/// Abstract repository interface for game operations
abstract class GameRepository {
  /// Initialize player
  Future<Player> initializePlayer(double screenWidth, double screenHeight);

  /// Generate enemy
  Future<Enemy> generateEnemy(double screenWidth);

  /// Save game score
  Future<void> saveScore(int score);

  /// Get high scores
  Future<List<int>> getHighScores();

  /// Save current game state
  Future<void> saveGameState({
    required Player player,
    required int score,
  });

  /// Load saved game state
  Future<Map<String, dynamic>?> loadGameState();
}

