import 'dart:async';

import 'package:catcat/catcat.dart';
import 'package:catcat/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Gato extends SpriteAnimationComponent
    with HasGameRef<Catcat>, CollisionCallbacks {
  Gato({
    super.position,
    super.size,
  });

  bool reachedCheckpoint = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;

    add(RectangleHitbox(
        position: Vector2(5, 5),
        size: Vector2(20, 20),
        collisionType: CollisionType.passive));

    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('cat/idle.png'),
        SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.1, textureSize: Vector2.all(32)));

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !reachedCheckpoint) {
      print('colaiding');
      _reachedCheckpoint();
    }
    super.onCollision(intersectionPoints, other);
  }

  void _reachedCheckpoint() {
    reachedCheckpoint = true;
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('cat/fin.png'),
        SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: 0.1,
            textureSize: Vector2.all(32),
            loop: false));

    const catDuration = Duration(milliseconds: 1300);
    Future.delayed(catDuration, () {
      animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('cat/idle.png'),
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2.all(32),
          ));
    });
  }
}
