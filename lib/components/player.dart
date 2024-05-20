import 'dart:async';
import 'package:catcat/catcat.dart';
import 'package:catcat/components/servicios.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:catcat/components/colision_block.dart';

enum PlayerState { idle, run, dead }

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
  double movimientoHorizontal = 0;
  double moveSpeed = 50;
  Vector2 velocidad = Vector2.zero();
  List<ColisionBlock> colisionBlocks = [];

  //para que se de la vuelta

//carga las animaciones de los personajes
  @override
  FutureOr<void> onLoad() {
    _loadAllAnmations();
    debugMode = true;
    return super.onLoad();
  }

//updatea la posicion
  @override
  void update(double dt) {
    _updatePlayerState();
    _updetePlayerMovimiento(dt);
    _checkHorizontalCollision();
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    movimientoHorizontal = 0;

    final isIzquierdaKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA);
    final isDerechaKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD);

    movimientoHorizontal += isIzquierdaKeyPressed ? -1 : 0;
    movimientoHorizontal += isDerechaKeyPressed ? 1 : 0;

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

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocidad.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocidad.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocidad.x > 0 || velocidad.x < 0) {
      playerState = PlayerState.run;
    }

    current = playerState;
  }

  void _updetePlayerMovimiento(double dt) {
    velocidad.x = movimientoHorizontal * moveSpeed;
    position.x += velocidad.x * dt;
  }

  void _checkHorizontalCollision() {
    for (final block in colisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocidad.x > 0) {
            velocidad.x = 0;
            position.x = block.x - width;
          }
        }
      }
    }
  }
}
