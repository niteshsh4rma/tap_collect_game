part of 'game_bloc.dart';

sealed class GameEvent {}

class StartGame extends GameEvent {}

class PauseGame extends GameEvent {}

class ResumeGame extends GameEvent {}

class EndGame extends GameEvent {}

class RestartGame extends GameEvent {}

class SpawnCollectableObject extends GameEvent {}

class CollectableObjectTapped extends GameEvent {
  final int score;

  CollectableObjectTapped({
    required this.score,
  });
}
