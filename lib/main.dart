import 'package:catcat/screens/play_screen.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

void main() async {
  // Para que se vea en pantalla completa y en horizontal
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catcat Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlayScreen(),
      debugShowCheckedModeBanner: false, // Quitar el banner de depuración
    );
  }
}
