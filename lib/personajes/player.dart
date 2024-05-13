import 'dart:async';

import 'package:catcat/catcat.dart';
import 'package:flame/components.dart';

enum PlayerState { idle, run, dead }

class Player extends SpriteAnimationGroupComponent with HasGameRef<Catcat> {
  //para cambiar de personaje
  String personaje;
  Player({position, required this.personaje}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  late final SpriteAnimation deadAnimation;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnmations();

    return super.onLoad();
  }

  void _loadAllAnmations() {
//animaciones********************************
// animacion idle
    idleAnimation = _spriteAnimation('idle', 5);

// animacion run
    runAnimation = _spriteAnimation('run', 8);

// animacion dead
    deadAnimation = _spriteAnimation('dead', 7);

//lista de animaciones
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.run: runAnimation,
      PlayerState.dead: deadAnimation
    };

    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int frames) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('characters/$personaje/$state.png'),
      SpriteAnimationData.sequenced(
          amount: frames, stepTime: 0.1, textureSize: Vector2.all(64)),
    );
  }
}
