import 'package:flutter/material.dart';
import 'package:catcat/screens/register_dialog.dart';
import 'package:catcat/screens/login_dialog.dart';
import 'package:catcat/screens/play_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo/fondo1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
