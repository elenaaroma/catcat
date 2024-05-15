import 'dart:async';

import 'package:catcat/catcat.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

enum PlayerState { idle, run, dead }

enum PlayerDirection { derecha, izquierda, quieto }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<Catcat>, KeyboardHandler {
  //para cambiar de personaje
  String personaje;
  Player(
      {super.position,
      this.personaje = 'red-knight'}); // por defecto se pone el rojo

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  late final SpriteAnimation deadAnimation;

//movilidad del personaje, en que estado esta y las velocidades a las que se mueve
  PlayerDirection playerDirection = PlayerDirection.quieto;
  double moveSpeed = 50;
  Vector2 velocidad = Vector2.zero();

  //para que se de la vuelta
  bool cambioSentido = true;

//carga las animaciones de los personajes
  @override
  FutureOr<void> onLoad() {
    _loadAllAnmations();
    return super.onLoad();
  }

//updatea la posicion
  @override
  void update(double dt) {
    _updetePlayerMovimiento(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isIzquierdaKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA);
    final isDerechaKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD);

    if (isIzquierdaKeyPressed && isDerechaKeyPressed) {
      playerDirection = PlayerDirection.quieto;
    } else if (isDerechaKeyPressed) {
      playerDirection = PlayerDirection.derecha;
    } else if (isIzquierdaKeyPressed) {
      playerDirection = PlayerDirection.izquierda;
    } else {
      playerDirection = PlayerDirection.quieto;
    }

    return super.onKeyEvent(event, keysPressed);
  }

//carga las animaciones de los personajes
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

    current = PlayerState.run;
  }

//carga las animaciones y es universal
  SpriteAnimation _spriteAnimation(String state, int frames) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('characters/$personaje/$state.png'),
      SpriteAnimationData.sequenced(
          amount: frames, stepTime: 0.1, textureSize: Vector2.all(64)),
    );
  }

  void _updetePlayerMovimiento(double dt) {
    double dx = 0.0; //eje x (lados)
    double dy = 0.0; // eje y (saltos)

    switch (playerDirection) {
      case PlayerDirection.izquierda:
        if (cambioSentido) {
          flipHorizontallyAroundCenter();
          cambioSentido = false;
        }
        current = PlayerState.run;
        dx -= moveSpeed;
        break;
      case PlayerDirection.derecha:
        if (!cambioSentido) {
          flipHorizontallyAroundCenter();
          cambioSentido = true;
        }
        current = PlayerState.run;
        dx += moveSpeed;
        break;
      case PlayerDirection.quieto:
        current = PlayerState.idle;
        break;
      default:
    }

    velocidad = Vector2(dx, 0.0);
    position += velocidad * dt;
  }
}
