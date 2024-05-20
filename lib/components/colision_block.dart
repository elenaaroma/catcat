import 'package:flame/components.dart';

class ColisionBlock extends PositionComponent {
  bool isPlatform;
  ColisionBlock({position, size, this.isPlatform = false})
      : super(position: position, size: size) {
    debugMode = true;
  }
}
