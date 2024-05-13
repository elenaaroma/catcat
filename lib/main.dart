import 'package:catcat/catcat.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  //para que se vea en pantalla completa
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  Catcat game = Catcat();

  runApp(
    GameWidget(game: kDebugMode ? Catcat() : game),
  );
}
