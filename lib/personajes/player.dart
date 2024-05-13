import 'dart:async';

import 'package:catcat/catcat.dart';
import 'package:flame/components.dart';

enum PlayerState { idle, run, jump, dead }

class Player extends SpriteAnimationGroupComponent with HasGameRef<Catcat> {
  late final SpriteAnimation idleAnimation;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnmations();

    return super.onLoad();
  }

  void _loadAllAnmations() {
    idleAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('characters/red-knight/idle.png'),
      SpriteAnimationData.sequenced(
          amount: 5, stepTime: 0.5, textureSize: Vector2.all(64)),
    );

    animations = {
      PlayerState.idle: idleAnimation,
    };

    current = PlayerState.idle;
  }
}
