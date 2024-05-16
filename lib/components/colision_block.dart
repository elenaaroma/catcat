import 'package:flame/components.dart';

class ColisionBlock extends PositionComponent {
  //ColisionBlock({super.position, super.size});

  bool isPlataform;

  ColisionBlock({position, size, this.isPlataform = false})
      : super(position: position, size: size) {
    debugMode = true;
  }
}
