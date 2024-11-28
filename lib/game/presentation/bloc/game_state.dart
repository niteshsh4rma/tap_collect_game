part of 'game_bloc.dart';

enum GameStatus {
  initial,
  started,
  paused,
  resumed,
  objectSpawned,
  scoreUpdated,
}

class GameState extends Equatable {
  final int? id;
  final GameStatus status;
  final int score;
  final bool hasStarted;

  const GameState({
    this.id,
    this.status = GameStatus.initial,
    this.score = 0,
    this.hasStarted = false,
  });

  GameState copyWith({
    required GameStatus status,
    int? id,
    int? score,
    bool? hasStarted,
  }) =>
      GameState(
        status: status,
        score: score ?? this.score,
        hasStarted: hasStarted ?? this.hasStarted,
        id: id ?? this.id,
      );

  @override
  List<Object?> get props => [
        status,
        id,
        score,
        hasStarted,
      ];
}
