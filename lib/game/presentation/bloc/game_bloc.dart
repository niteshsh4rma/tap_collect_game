import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState()) {
    on<StartGame>((event, emit) {
      emit(
        state.copyWith(
          status: GameStatus.started,
          score: 0,
          hasStarted: true,
        ),
      );
    });

    on<PauseGame>((event, emit) {
      emit(state.copyWith(status: GameStatus.paused));
    });

    on<ResumeGame>((event, emit) {
      emit(state.copyWith(status: GameStatus.resumed));
    });

    on<EndGame>((event, emit) {
      emit(const GameState());
    });

    on<RestartGame>((event, emit) {
      add(StartGame());
    });

    on<SpawnCollectableObject>((event, emit) {
      emit(
        state.copyWith(
          status: GameStatus.objectSpawned,
          id: DateTime.now().microsecondsSinceEpoch,
        ),
      );
    });

    on<CollectableObjectTapped>((event, emit) {
      emit(
        state.copyWith(
          status: GameStatus.scoreUpdated,
          score: state.score + event.score,
        ),
      );
    });
  }
}
