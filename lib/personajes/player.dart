import 'dart:async';

import 'package:catcat/catcat.dart';
import 'package:flame/components.dart';

enum PlayerState { idle, run, dead }

enum PlayerDirection { derecha, izquierda, quieto }

class Player extends SpriteAnimationGroupComponent with HasGameRef<Catcat> {
  //para cambiar de personaje
  String personaje;
  Player({super.position, required this.personaje});

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  late final SpriteAnimation deadAnimation;

  PlayerDirection playerDirection = PlayerDirection.quieto;
  double moveSpeed = 100;
  Vector2 velocidad = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    _loadAllAnmations();

    return super.onLoad();
  }

  void _loadAllAnmations() {
//animaciones********************************
// animacion idle
    idleAnimation = _spriteAnimation('idle', 4);

// animacion run
    runAnimation = _spriteAnimation('run', 4);

// animacion dead
    deadAnimation = _spriteAnimation('dead', 4);

//lista de animaciones
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.run: runAnimation,
      PlayerState.dead: deadAnimation
    };

    current = PlayerState.run;
  }

  SpriteAnimation _spriteAnimation(String state, int frames) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('characters/$personaje/$state.png'),
      SpriteAnimationData.sequenced(
          amount: frames, stepTime: 0.1, textureSize: Vector2.all(32)),
    );
  }
}
