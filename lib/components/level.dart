import 'dart:async';

import 'package:catcat/components/colision_block.dart';
import 'package:catcat/components/gato.dart';
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

    playMusicLoop();
    _spawningObjects();
    _addCollision();

    return super.onLoad();
  }

  Future<void> playMusicLoop() async {
    while (true) {
      await audioPlayer.play(AssetSource('audio/musica_juego.mp3'));
      audioPlayer.setVolume(0.1);
      await Future.delayed(const Duration(minutes: 1));
    }
  }

  @override
  void onRemove() {
    // Detener la música y el temporizador cuando el nivel se elimine
    audioPlayer.stop();
    super.onRemove();
  }

  void _spawningObjects() {
    final personajes = level.tileMap.getLayer<ObjectGroup>('personajes');

    if (personajes != null) {
      for (final personaje in personajes.objects) {
        switch (personaje.class_) {
          case 'Player':
            player.position = Vector2(personaje.x - 25, personaje.y - 35);
            add(player);
            break;
          case 'Gato':
            final gato =
                Gato(position: Vector2(personaje.x - 25, personaje.y - 17));
            add(gato);
            break;
          default:
        }
      }
    }
  }

  void _addCollision() {
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
  }
}
