import 'dart:async';

import 'package:catcat/catcat.dart';
import 'package:flame/components.dart';

class Enemy extends SpriteAnimationComponent with HasGameRef<Catcat> {
  final bool isVertical;
  final double offNeg;
  final double offPos;
  Enemy(
      {this.isVertical = false,
      this.offNeg = 0,
      this.offPos = 0,
      position,
      size})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('enemies/Orc/Orc-Walk.png'),
        SpriteAnimationData.sequenced(
            amount: 7, stepTime: 0.1, textureSize: Vector2.all(100)));
    return super.onLoad();
  }
}
