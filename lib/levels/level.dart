import 'dart:async';

import 'package:catcat/personajes/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('level-01.tmx', Vector2.all(32));

    add(level);
    add(Player());

    return super.onLoad();
  }
}
