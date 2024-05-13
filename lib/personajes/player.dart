import 'dart:async';

import 'package:catcat/catcat.dart';
import 'package:flame/components.dart';

enum PlayerState { idle, run, dead }

class Player extends SpriteAnimationGroupComponent with HasGameRef<Catcat> {
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  late final SpriteAnimation deadAnimation;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnmations();

    return super.onLoad();
  }

  void _loadAllAnmations() {
// animacion idle para rojo
    idleAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('characters/red-knight/idle.png'),
      SpriteAnimationData.sequenced(
          amount: 5, stepTime: 0.5, textureSize: Vector2.all(64)),
    );

// animacion run para rojo
    runAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('characters/red-knight/run.png'),
      SpriteAnimationData.sequenced(
          amount: 8, stepTime: 0.5, textureSize: Vector2.all(64)),
    );

// animacion dead para rojo
    deadAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('characters/red-knight/dead.png'),
      SpriteAnimationData.sequenced(
          amount: 7, stepTime: 0.5, textureSize: Vector2.all(64)),
    );

    animations = {
      PlayerState.idle: idleAnimation,
    };

    current = PlayerState.idle;
  }
}
