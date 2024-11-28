import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_lottie/flame_lottie.dart';
import 'package:tap_collect_game/game/presentation/bloc/game_bloc.dart';
import 'package:tap_collect_game/game/presentation/components/collectable_object.dart';
import 'package:tap_collect_game/game/presentation/tap_collect_game.dart';

class CollectableManager extends ShapeComponent
    with HasGameRef<TapCollectGame>, FlameBlocListenable<GameBloc, GameState> {
  Timer? _spawnTimer;
  late LottieComposition animation;

  double get _randomLimit => 0.5 + Random().nextDouble();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Decreased size of component so that objects do not spawn behind controls.
    size = Vector2(gameRef.size.x, gameRef.size.y - 100);
    position = Vector2(x, 100);

    children.register<CollectableObject>();

    animation = await loadLottie(
      LottieBuilder.asset('assets/lottie/object_tap_animation.json'),
    );

    await FlameAudio.audioCache.loadAll([
      'object_appear.mp3',
      'object_disappear.mp3',
    ]);

    _spawnTimer = Timer(
      _randomLimit,
      onTick: () {
        gameRef.bloc.add(SpawnCollectableObject());
        _spawnTimer?.limit = _randomLimit;
      },
      repeat: true,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _spawnTimer?.update(dt);
  }

  @override
  bool listenWhen(GameState previousState, GameState newState) =>
      newState.status == GameStatus.objectSpawned;

  @override
  void onRemove() {
    _spawnTimer?.stop();
    _spawnTimer = null;
    super.onRemove();
  }

  @override
  void onNewState(GameState state) {
    super.onNewState(state);
    if (state.status == GameStatus.objectSpawned) {
      final key = ComponentKey.unique();
      add(
        CollectableObject(
          key: key,
          radius: 20,
          score: Random().nextInt(10) + 1,
          position: Vector2(
            Random().nextDouble() * gameRef.size.x,
            Random().nextDouble() * gameRef.size.y,
          ),
        ),
      );
    }
  }

  void removeAllObjects() {
    final collectables = children.query<CollectableObject>();
    removeAll(collectables);
  }
}
