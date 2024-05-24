import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:catcat/catcat.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Catcat game = Catcat();

    return Scaffold(
      body: GameWidget(
        game: game,
      ),
    );
  }
}
