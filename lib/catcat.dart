import 'dart:async';

import 'package:catcat/components/level.dart';
import 'package:catcat/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Catcat extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF3f3851);

  late CameraComponent cam;
  Player player = Player(personaje: 'red-knight');

  late JoystickComponent joystick;
  late SpriteButtonComponent jumpButton;
  bool showJoystick = false;
  List<String> levelNames = ['level-01', 'level-02'];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    priority = 0;
    await images.loadAllImages();

    _loadLevel();

    // Detectar si la aplicación se está ejecutando en la web
    if (kIsWeb) {
      showJoystick = false;
    } else {
      showJoystick = true;
    }

    if (showJoystick) {
      addJoystick();
      addJumpButton();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority:
          2, // Establece una prioridad alta para asegurar que aparezca encima de la cámara y el nivel
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Mando.png')),
      ),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png')),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.movimientoHorizontal = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.movimientoHorizontal = 1;
        break;
      default:
        player.movimientoHorizontal = 0;
    }
  }

  void addJumpButton() {
    jumpButton = SpriteButtonComponent(
      button: Sprite(images.fromCache('HUD/JumpFlecha.png')),
      buttonDown: Sprite(images.fromCache(
          'HUD/JumpFlecha.png')), // Usa la misma imagen para ambos estados
      onPressed: () {
        player.jump();
      },
      position: Vector2(size.x - 100,
          size.y - 100), // Posición en la esquina inferior derecha
      priority:
          2, // Establece una prioridad alta para asegurar que aparezca encima de la cámara y el nivel
    );
    add(jumpButton);
  }

  void loadNextLevel() {
    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {}
  }

  void _loadLevel() {
    player = Player();

    Future.delayed(const Duration(seconds: 1), () {
      Level world =
          Level(levelName: levelNames[currentLevelIndex], player: player);
      world.priority = 0;

      cam = CameraComponent.withFixedResolution(
          world: world, width: 640, height: 380)
        ..priority = 1; // La cámara tiene una prioridad mayor que el nivel
      cam.viewfinder.anchor = Anchor.topLeft;

      add(world);
      add(cam);
    });
  }
}
