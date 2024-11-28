import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_collect_game/game/presentation/bloc/game_bloc.dart';
import 'package:tap_collect_game/game/presentation/tap_collect_game.dart';

const kControlsOverlay = 'CONTROLS_OVERLAY';

class ControlsOverlay extends StatelessWidget {
  final TapCollectGame game;

  const ControlsOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final gameBloc = BlocProvider.of<GameBloc>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton.filled(
            onPressed: () => gameBloc.add(PauseGame()),
            icon: const Icon(Icons.pause),
            iconSize: 32,
          ),
          const SizedBox(width: 16),
          IconButton.outlined(
            onPressed: () => gameBloc.add(RestartGame()),
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 16),
          IconButton.outlined(
            onPressed: () => gameBloc.add(EndGame()),
            icon: const Icon(Icons.stop),
            color: Colors.red,
          ),
          const Spacer(),
          BlocBuilder<GameBloc, GameState>(
            buildWhen: (_, state) => [
              GameStatus.initial,
              GameStatus.started,
              GameStatus.scoreUpdated,
            ].contains(state.status),
            builder: (context, state) => Text(
              state.score.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          )
        ],
      ),
    );
  }
}
