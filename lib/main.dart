import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_collect_game/game/presentation/bloc/game_bloc.dart';
import 'package:tap_collect_game/game/presentation/overlays/controls_overlay.dart';
import 'package:tap_collect_game/game/presentation/overlays/menu_overlay.dart';
import 'package:tap_collect_game/game/presentation/tap_collect_game.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        body: BlocProvider(
          create: (context) => GameBloc(),
          child: Builder(
            builder: (context) {
              final bloc = BlocProvider.of<GameBloc>(context);
              final game = TapCollectGame(bloc: bloc)..pauseEngine();
              return BlocListener<GameBloc, GameState>(
                listener: (context, state) => handleGameStatus(
                  state.status,
                  game,
                ),
                child: GameWidget<TapCollectGame>(
                  game: game,
                  overlayBuilderMap: {
                    kMenuOverlay: (context, game) {
                      return MenuOverlay(game: game);
                    },
                    kControlsOverlay: (context, game) {
                      return ControlsOverlay(
                        game: game,
                      );
                    }
                  },
                  initialActiveOverlays: const [
                    kMenuOverlay,
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void pauseGame(TapCollectGame game) {
    game.pauseEngine();
    game.overlays.add(kMenuOverlay);
    game.overlays.remove(kControlsOverlay);
  }

  void resumeGame(TapCollectGame game) {
    game.resumeEngine();
    game.overlays.remove(kMenuOverlay);
    game.overlays.add(kControlsOverlay);
  }

  void handleGameStatus(GameStatus status, TapCollectGame game) {
    if (status == GameStatus.initial || status == GameStatus.started) {
      game.collectableManager.removeAllObjects();
    }

    if (status == GameStatus.initial || status == GameStatus.paused) {
      // pauseGame after all {CollectableObject} instances are removed and updated frame is rendered.
      WidgetsBinding.instance.addPostFrameCallback((_) => pauseGame(game));
    } else if (status == GameStatus.resumed || status == GameStatus.started) {
      resumeGame(game);
    }
  }
}
