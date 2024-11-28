import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_collect_game/game/presentation/bloc/game_bloc.dart';
import 'package:tap_collect_game/game/presentation/tap_collect_game.dart';

const kMenuOverlay = 'MENU_OVERLAY';

class MenuOverlay extends StatelessWidget {
  final TapCollectGame game;

  const MenuOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GameBloc>(context);

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5,
        sigmaY: 5,
      ),
      child: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FlutterLogo(size: 150),
                const SizedBox(height: 16),
                IconButton.filled(
                  iconSize: 50,
                  onPressed: () {
                    if (state.hasStarted) {
                      bloc.add(ResumeGame());
                    } else {
                      bloc.add(StartGame());
                    }
                  },
                  icon: const Icon(Icons.play_arrow_outlined),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showScoreBottomsheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Text(
                'Score',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    BlocProvider.of<GameBloc>(context).state.score.toString(),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
