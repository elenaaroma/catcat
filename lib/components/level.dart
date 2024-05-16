import 'dart:async';

import 'package:catcat/components/colision_block.dart';
import 'package:catcat/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  final String levelName;

  final Player player;

  Level({required this.levelName, required this.player});

  late TiledComponent level;

  List<ColisionBlock> colisionBlock = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(32));

    add(level);

    final personajes = level.tileMap.getLayer<ObjectGroup>('personajes');

    if (personajes != null) {
      for (final personajes in personajes.objects) {
        switch (personajes.class_) {
          case 'Player':
            player.position = Vector2(personajes.x - 25, personajes.y - 35);
            add(player);
            break;
          default:
        }
      }
    }

    final colision = level.tileMap.getLayer<ObjectGroup>('Colisiones');

    if (colision != null) {
      for (final colision in colision.objects) {
        switch (colision.class_) {
          case 'Platafora':
            final plataforma = ColisionBlock(
                position: Vector2(colision.x, colision.y),
                size: Vector2(colision.width, colision.height),
                isPlataform: true);
            break;
          default:
            final block = ColisionBlock(
                position: Vector2(colision.x, colision.y),
                size: Vector2(colision.width, colision.height));

            colisionBlock.add(block);
            add(block);
        }
      }
    }

    // add(Player(personaje: 'red-knight'));

    return super.onLoad();
  }
}
