import 'dart:async';

import 'package:catcat/personajes/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  final String levelName;

  final Player player;

  Level({required this.levelName, required this.player});

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(32));

    add(level);

    final personajes = level.tileMap.getLayer<ObjectGroup>('personajes');

    for (final personajes in personajes!.objects) {
      switch (personajes.class_) {
        case 'Player':
          player.position = Vector2(personajes.x - 25, personajes.y - 35);
          add(player);
          break;
        default:
      }
    }

    // add(Player(personaje: 'red-knight'));

    return super.onLoad();
  }
}
