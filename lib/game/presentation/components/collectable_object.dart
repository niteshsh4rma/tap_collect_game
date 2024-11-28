import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_lottie/flame_lottie.dart';
import 'package:flutter/material.dart';
import 'package:tap_collect_game/game/presentation/bloc/game_bloc.dart';
import 'package:tap_collect_game/game/presentation/components/collectable_manager.dart';
import 'package:tap_collect_game/game/presentation/tap_collect_game.dart';

class CollectableObject extends CircleComponent
    with
        TapCallbacks,
        HasGameRef<TapCollectGame>,
        HasAncestor<CollectableManager> {
  final int score;
  CollectableObject({
    required this.score,
    super.key,
    super.radius,
    super.position,
  }) : super(
          anchor: Anchor.center,
          paint: Paint()..color = Colors.red,
          scale: Vector2.zero(),
        );

  Timer? _disappearTimer;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    FlameAudio.play('object_appear.mp3');

    _disappearTimer = Timer(
      5,
      onTick: scaleDownAndRemove,
    );

    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: radius * 0.8,
      fontWeight: FontWeight.bold,
    );

    final textComponent = TextComponent(
      text: score.toString(),
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(
        style: textStyle,
      ),
    );

    textComponent.scale = Vector2.all(1.0);

    addAll([
      textComponent,
      ScaleEffect.to(
        Vector2.all(1),
        EffectController(
          duration: 0.5,
          curve: Curves.easeOut,
        ),
      ),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _disappearTimer?.update(dt);
  }

  @override
  void onRemove() {
    _disappearTimer?.stop();
    _disappearTimer = null;
    super.onRemove();
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    gameRef.bloc.add(CollectableObjectTapped(score: score));
    FlameAudio.play('object_disappear.mp3');
    showCelebrationAnimation();
    scaleDownAndRemove();
  }

  void scaleDownAndRemove() {
    add(
      ScaleEffect.to(
        Vector2.zero(),
        EffectController(duration: 0.5, curve: Curves.easeIn),
        onComplete: removeFromParent,
      ),
    );
  }

  void showCelebrationAnimation() {
    final lottieComponent = LottieComponent(
      ancestor.animation,
      duration: 1,
      position: absolutePosition,
      size: size * 1.5,
      anchor: Anchor.center,
      key: ComponentKey.unique(),
    );

    gameRef.add(lottieComponent);

    Future.delayed(
      const Duration(seconds: 1),
      lottieComponent.removeFromParent,
    );
  }
}
