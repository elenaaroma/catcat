import 'dart:async';
import 'package:catcat/components/colision_block.dart';
import 'package:catcat/components/enemy.dart';
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

    playMusicLoop(); // Iniciar la música en bucle
    _spawningObjects();
    _addCollision();

    return super.onLoad();
  }

  Future<void> playMusicLoop() async {
    while (true) {
      await audioPlayer
          .stop(); // Detener cualquier música que esté reproduciéndose
      await audioPlayer.play(AssetSource('audio/musica_juego.mp3'));
      audioPlayer.setVolume(0.1);
      await Future.delayed(const Duration(minutes: 1));
    }
  }

  void stopMusic() {
    audioPlayer.stop();
  }

  @override
  void onRemove() {
    // Detener la música cuando el nivel se elimine
    //audioPlayer.stop();
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
          case 'Enemy':
            final isVertical = personaje.properties.getValue('isVertical');
            final offNeg = personaje.properties.getValue('offNeg');
            final offPos = personaje.properties.getValue('offPos');
            final enemigo = Enemy(
                isVertical: isVertical,
                offNeg: offNeg,
                offPos: offPos,
                position: Vector2(personaje.x - 25, personaje.y - 25));
            add(enemigo);
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
