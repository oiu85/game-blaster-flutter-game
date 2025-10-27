import 'package:equatable/equatable.dart';

/// Game score entity representing player's progress
class GameScore extends Equatable {
  final int score;
  final int level;
  final int moves;
  final int matches;

  const GameScore({
    this.score = 0,
    this.level = 1,
    this.moves = 0,
    this.matches = 0,
  });

  GameScore copyWith({
    int? score,
    int? level,
    int? moves,
    int? matches,
  }) {
    return GameScore(
      score: score ?? this.score,
      level: level ?? this.level,
      moves: moves ?? this.moves,
      matches: matches ?? this.matches,
    );
  }

  @override
  List<Object?> get props => [score, level, moves, matches];
}

