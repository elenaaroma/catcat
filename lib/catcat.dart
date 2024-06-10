import 'dart:async';
import 'package:catcat/components/cronometro.dart';
import 'package:catcat/components/level.dart';
import 'package:catcat/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Catcat extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF3f3851);

  late CameraComponent cam;
  Player player = Player(personaje: 'red-knight');

  late JoystickComponent joystick;
  late SpriteButtonComponent jumpButton;
  late Cronometro cronometro; // Agregar variable para el cronómetro
  int deathCount = 0; // Contador de muertes
  bool showJoystick = false;
  bool isLoadingLevel =
      false; // Nueva bandera para controlar la carga del nivel
  List<String> levelNames = [
    'level-01',
    'level-02',
    'level-03',
    'level-04',
  ];

  int currentLevelIndex = 0;

  Level? currentLevel; // Referencia al nivel actual

  @override
  Future<void> onLoad() async {
    priority = 0;
    await images.loadAllImages();

    cronometro = Cronometro();
    add(cronometro); // Agregar cronómetro al juego

    _loadLevel();

    // Detectar si la aplicación se está ejecutando en la web
    if (kIsWeb) {
      showJoystick = false;
    } else {
      showJoystick = true;
    }

    if (showJoystick) {
      addJoystick();
      addJumpButton();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority:
          2, // Establece una prioridad alta para asegurar que aparezca encima de la cámara y el nivel
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Mando.png')),
      ),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png')),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.movimientoHorizontal = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.movimientoHorizontal = 1;
        break;
      default:
        player.movimientoHorizontal = 0;
    }
  }

  void addJumpButton() {
    jumpButton = SpriteButtonComponent(
      button: Sprite(images.fromCache('HUD/JumpFlecha.png')),
      buttonDown: Sprite(images.fromCache(
          'HUD/JumpFlecha.png')), // Usa la misma imagen para ambos estados
      onPressed: () {
        player.jump();
      },
      position: Vector2(size.x - 100,
          size.y - 100), // Posición en la esquina inferior derecha
      priority:
          2, // Establece una prioridad alta para asegurar que aparezca encima de la cámara y el nivel
    );
    add(jumpButton);
  }

  void loadNextLevel() {
    if (currentLevelIndex < levelNames.length - 1 && !isLoadingLevel) {
      printDeathCount(); // Llama a printDeathCount antes de incrementar el índice del nivel
      currentLevelIndex++;
      print(
          'Loading next level with index: $currentLevelIndex'); // Mensaje de depuración
      _loadLevel();
      deathCount = 0;
    }
  }

  void _loadLevel() {
    if (currentLevel != null) {
      currentLevel!.stopMusic();
    }

    if (isLoadingLevel) return;
    isLoadingLevel = true;

    if (currentLevel != null) {
      print(
          'Removing current level: ${levelNames[currentLevelIndex]}'); // Mensaje de depuración
      remove(currentLevel!);
      currentLevel = null;
    }

    Future.delayed(const Duration(seconds: 2), () {
      player = Player(personaje: 'red-knight');

      final levelName = levelNames[currentLevelIndex];
      print(
          'Loading level: $levelName at index: $currentLevelIndex'); // Mensaje de depuración
      Level world =
          Level(levelName: levelName, player: player, cronometro: cronometro);
      currentLevel = world; // Actualizar la referencia al nivel actual
      world.priority = 0;

      cam = CameraComponent.withFixedResolution(
          world: world, width: 640, height: 380)
        ..priority = 1;
      cam.viewfinder.anchor = Anchor.topLeft;

      add(world);
      add(cam);
      cronometro.reiniciar(); // Reiniciar cronómetro al cargar un nuevo nivel
      // Imprimir número de muertes al cambiar de nivel
      print(
          'Level $levelName added to the game at index: $currentLevelIndex'); // Mensaje de depuración
      isLoadingLevel = false;
    });
  }

  void incrementDeathCount() {
    deathCount++;
  }

  Future<void> updateDeathCountInFirestore(int deathCount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;

      // Estructura del documento a guardar
      final puntuacion = {
        'muertes': deathCount,
        'tiempo': cronometro
            .getCurrentTime(), // Asegúrate de tener este método en tu cronómetro
      };

      // Crear o actualizar el documento en la colección puntuaciones
      await firestore
          .collection('puntuaciones')
          .doc(user.email) // Usar el email del usuario como ID del documento
          .collection('niveles')
          .doc(levelNames[
              currentLevelIndex]) // Usar el nombre del nivel como ID del documento
          .set(puntuacion, SetOptions(merge: true));
    }
  }

  void printDeathCount() {
    print('Total deaths: $deathCount');
    updateDeathCountInFirestore(deathCount);
  }
}
