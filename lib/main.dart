import 'package:catcat/catcat.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  catcat game = catcat();

  runApp(GameWidget(game: game));
}
