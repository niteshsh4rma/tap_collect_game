import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:tap_collect_game/game/presentation/bloc/game_bloc.dart';
import 'package:tap_collect_game/game/presentation/components/collectable_manager.dart';

class TapCollectGame extends FlameGame {
  final GameBloc bloc;
  final CollectableManager collectableManager = CollectableManager();

  TapCollectGame({required this.bloc});

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    add(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: bloc,
        children: [
          collectableManager,
        ],
      ),
    );
  }
}
