import 'dart:async';

import 'package:catcat/levels/level.dart';
import 'package:flame/game.dart';

class catcat extends FlameGame {
  @override
  FutureOr<void> onLoad() {
    add(Level());

    return super.onLoad();
  }
}
