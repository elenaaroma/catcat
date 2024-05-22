import 'package:flame/components.dart';

class ColisionBlock extends PositionComponent {
  bool isPlatform;

  ColisionBlock({
    required Vector2 position,
    required Vector2 size,
    this.isPlatform = false,
  }) : super(
          position: position,
          size: size,
        ) {
    debugMode = true;
  }
}
