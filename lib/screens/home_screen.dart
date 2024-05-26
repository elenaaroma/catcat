import 'package:flutter/material.dart';
import 'package:catcat/screens/register_dialog.dart';
import 'package:catcat/screens/login_dialog.dart';
import 'package:catcat/screens/play_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AudioPlayer _audioPlayer;
  bool _isMusicPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  Future<void> _playMusic() async {
    try {
      await _audioPlayer.setReleaseMode(
          ReleaseMode.loop); // Configurar el modo de reproducción en bucle
      if (kIsWeb) {
        await _audioPlayer.play(UrlSource('assets/audio/musica_menu.mp3'));
      } else {
        await _audioPlayer
            .play(DeviceFileSource('assets/audio/musica_menu.mp3'));
      }
      setState(() {
        _isMusicPlaying = true;
      });
      print('Música reproduciéndose');
    } catch (e) {
      print('Error al reproducir música: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo/fondo3.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    if (!_isMusicPlaying) {
                      _playMusic();
                    }
                  },
                  child: Text('Iniciar Música'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => RegisterDialog(),
                    );
                  },
                  child: Text('Registrarse'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => LoginDialog(),
                    );
                  },
                  child: Text('Iniciar Sesión'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
