import 'dart:async';

import 'package:catcat/components/level.dart';
import 'package:catcat/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Catcat extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF3f3851);

  late final CameraComponent cam;
  Player player = Player(personaje: 'red-knight');

  late JoystickComponent joystick;
  bool showJoystick = false;

  @override
  FutureOr<void> onLoad() async {
    priority = 0;
    await images.loadAllImages();

    final world = Level(levelName: 'level-01', player: player);
    world.priority = 0;

    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 380)
      ..priority = 1; // La cámara tiene una prioridad mayor que el nivel
    cam.viewfinder.anchor = Anchor.topLeft;

    add(world);
    add(cam);

    if (showJoystick) {
      addJoystick();
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
}
