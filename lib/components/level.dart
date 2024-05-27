import 'dart:async';

import 'package:catcat/components/colision_block.dart';
import 'package:catcat/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  final String levelName;

  final Player player;

  Level({required this.levelName, required this.player});

  late TiledComponent level;

  List<ColisionBlock> colisionBlock = [];

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(32));

    add(level);

    await audioPlayer.play(AssetSource('audio/musica_juego.mp3'));
    //audioPlayer.setVolume(game.volumenSonido * .5);

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

    final colisionLayer = level.tileMap.getLayer<ObjectGroup>('Colisiones');

    if (colisionLayer != null) {
      for (final colision in colisionLayer.objects) {
        switch (colision.class_) {
          case 'Platform':
            final platform = ColisionBlock(
                position: Vector2(colision.x, colision.y),
                size: Vector2(colision.width, colision.height),
                isPlatform: true);

            colisionBlock.add(platform);
            add(platform);

            break;
          default:
            final block = ColisionBlock(
                position: Vector2(colision.x, colision.y),
                size: Vector2(colision.width, colision.height),
                isPlatform: false);
            colisionBlock.add(block);
            add(block);
        }
      }
    }

    player.colisionBlocks = colisionBlock;

    return super.onLoad();
  }
}
