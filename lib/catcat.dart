import 'dart:async';

import 'package:catcat/levels/level.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class catcat extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF3f3851);

  late final CameraComponent cam;
  final world = Level();

  @override
  FutureOr<void> onLoad() {
    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 380);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    return super.onLoad();
  }
}