import 'dart:async';

import 'package:catcat/catcat.dart';
import 'package:flame/components.dart';

class Player extends SpriteAnimationGroupComponent with HasGameRef<catcat> {
  late final SpriteAnimation idleAnimation;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnmations();

    return super.onLoad();
  }

  void _loadAllAnmations() {
    idleAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('characters/red-knight/idle'),
      SpriteAnimationData.sequenced(
          amount: 5, stepTime: 0.5, textureSize: Vector2.all(64)),
    );
  }
}
