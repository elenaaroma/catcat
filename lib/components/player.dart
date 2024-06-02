import 'dart:async';
import 'package:catcat/catcat.dart';
import 'package:catcat/components/gato.dart';
import 'package:catcat/components/servicios.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:catcat/components/colision_block.dart';
import 'package:catcat/components/custom_hitbox.dart';

enum PlayerState { idle, run, dead }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<Catcat>, KeyboardHandler, CollisionCallbacks {
  //para cambiar de personaje
  String personaje;
  Player(
      {super.position,
      this.personaje = 'red-knight'}); // por defecto se pone el rojo

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  late final SpriteAnimation deadAnimation;

//movilidad del personaje, en que estado esta y las velocidades a las que se mueve
  final double _gravedad = 6.9;
  final double _salto = 390;
  final double _terminalVelocity = 300;
  double movimientoHorizontal = 0;
  double moveSpeed = 130;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocidad = Vector2.zero();
  bool isFloor = false;
  bool hasJumped = false;
  bool reachedCheckpoint = false;
  List<ColisionBlock> colisionBlocks = [];

  CustomHitbox hitbox = CustomHitbox(
    offsetX: 24, // Desplazamiento desde el borde izquierdo
    offsetY: 18, // Desplazamiento desde el borde superior
    width: 16, // Ancho del hitbox
    height: 28,
  );

  //para que se de la vuelta

//carga las animaciones de los personajes
  @override
  FutureOr<void> onLoad() {
    _loadAllAnmations();
    startingPosition = Vector2(position.x, position.y);
    debugMode = true;
    add(RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height)));

    return super.onLoad();
  }

//updatea la posicion
  @override
  void update(double dt) {
    _updatePlayerState();
    _updetePlayerMovimiento(dt);
    _checkHorizontalCollision();
    _applyGravity(dt);
    _checkVerticalCollision();
    _checkOutOfBounds();

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    movimientoHorizontal = 0;

    final isIzquierdaKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA);
    final isDerechaKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD);

    movimientoHorizontal += isIzquierdaKeyPressed ? -1 : 0;
    movimientoHorizontal += isDerechaKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!reachedCheckpoint) {
      if (other is Gato) _reachedCheckpoint();
    }

    super.onCollision(intersectionPoints, other);
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
    if (hasJumped && isFloor) _playerJump(dt);

    velocidad.x = movimientoHorizontal * moveSpeed;
    position.x += velocidad.x * dt;
  }

  void _playerJump(double dt) {
    velocidad.y = -_salto;
    position.y += velocidad.y * dt;
    isFloor = false;
    hasJumped = false;
  }

  void jump() {
    if (isFloor) {
      velocidad.y = -_salto - 300;
      isFloor = false;
    }
  }

  void _checkHorizontalCollision() {
    for (final block in colisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocidad.x > 0) {
            velocidad.x = 0;
            position.x = block.position.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocidad.x < 0) {
            velocidad.x = 0;
            //Faltaba una suma + hitbox.width + hitbox.offsetX
            //position.x = block.position.x + block.size.x - hitbox.offsetX;
            position.x =
                block.position.x + block.size.x + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _checkVerticalCollision() {
    for (final block in colisionBlocks) {
      if (checkCollision(this, block)) {
        if (block.isPlatform) {
          if (velocidad.y > 0) {
            velocidad.y = 0;
            position.y = block.position.y - hitbox.height - hitbox.offsetY;
            isFloor = true;
            break;
          }
        } else {
          if (velocidad.y > 0) {
            velocidad.y = 0;
            position.y = block.position.y - hitbox.height - hitbox.offsetY;
            isFloor = true;
            break;
          }
          if (velocidad.y < 0) {
            velocidad.y = 0;
            position.y = block.position.y + block.size.y - hitbox.offsetY;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocidad.y += _gravedad;
    velocidad.y = velocidad.y.clamp(-_salto, _terminalVelocity);
    position.y += velocidad.y * dt;
  }

  void _checkOutOfBounds() {
    final screenWidth = gameRef.size.x;
    final screenHeight = gameRef.size.y;

    if (position.x < 0 ||
        position.x > screenWidth ||
        position.y < 0 ||
        position.y > screenHeight) {
      position = Vector2(
          100, 100); // Puedes ajustar esta posición inicial según sea necesario
      velocidad = Vector2.zero(); // Resetear la velocidad
    }
  }

  void _reachedCheckpoint() {
    reachedCheckpoint = true;

    const reachedCheckpointDuration = Duration(milliseconds: 350);
    Future.delayed(reachedCheckpointDuration, () {
      reachedCheckpoint = false;
      const waitToChange = Duration(seconds: 1);
      Future.delayed(waitToChange, () {
        game.loadNextLevel();
      });
    });
  }
}
