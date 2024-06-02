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
      super.position,
      super.size});

  static const moveSpeed = 50;
  static const tileSize = 32;
  double moveDirection = 1;
  double rangePos = 0;
  double rangeNeg = 0;

  late SpriteAnimation walkForwardAnimation;
  late SpriteAnimation walkBackwardAnimation;

  @override
  FutureOr<void> onLoad() {
    if (isVertical) {
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offPos * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }

    // Cargar la animación para caminar hacia adelante
    walkForwardAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('enemies/Orc/Orc-Walk.png'),
      SpriteAnimationData.sequenced(
          amount: 7, stepTime: 0.1, textureSize: Vector2.all(100)),
    );

    // Cargar la animación para caminar hacia atrás
    walkBackwardAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'enemies/Orc/Orc-Walk-Back.png'), // Asegúrate de tener esta imagen
      SpriteAnimationData.sequenced(
          amount: 7, stepTime: 0.1, textureSize: Vector2.all(100)),
    );

    // Iniciar con la animación de caminar hacia adelante
    animation = walkForwardAnimation;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (position.x >= rangePos) {
      moveDirection = -1;
      animation = walkBackwardAnimation;
    } else if (position.x <= rangeNeg) {
      moveDirection = 1;
      animation = walkForwardAnimation;
    }

    position.x += moveDirection * moveSpeed * dt;
    super.update(dt);
  }
}
