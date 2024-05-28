import 'dart:async';

import 'package:catcat/catcat.dart';
import 'package:flame/components.dart';

class Gato extends SpriteAnimationComponent with HasGameRef<Catcat> {
  Gato({
    super.position,
    super.size,
  });

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('cat/idle.png'),
        SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.1, textureSize: Vector2.all(32)));

    return super.onLoad();
  }
}
