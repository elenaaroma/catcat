import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';

class Cronometro extends PositionComponent {
  int milisegundos = 0;
  double acumulado = 0.0;

  late TextComponent texto;
  late RectangleComponent fondo;

  Cronometro() {
    fondo = RectangleComponent(
      size: Vector2(60, 20), // Ajusta el tamaño según tus necesidades
      paint: Paint()..color = const Color(0xFF3f3851),
      anchor: Anchor.topRight,
    );

    texto = TextComponent(
      text: '00:00',
      textRenderer: TextPaint(
        style: TextStyle(
          color: BasicPalette.white.color,
          fontSize: 20,
        ),
      ),
      anchor: Anchor.topRight,
    );

    add(fondo);
    add(texto);

    anchor = Anchor.topRight;
    position =
        Vector2(100, 20); // Ajusta esto según la resolución de tu pantalla
    priority =
        10; // Establecer una prioridad alta para que se vea por encima del mapa
  }

  @override
  void update(double dt) {
    super.update(dt);
    acumulado += dt;
    if (acumulado >= 0.001) {
      milisegundos += (acumulado * 1000).toInt();
      acumulado = 0.0; // Resetear acumulado
      final segs = (milisegundos ~/ 1000).toString().padLeft(2, '0');
      final milis = (milisegundos % 1000).toString().padLeft(3, '0');
      texto.text = '$segs:$milis';
    }
  }

  void reiniciar() {
    milisegundos = 0;
    acumulado = 0.0;
    texto.text = '00:00';
  }
}
