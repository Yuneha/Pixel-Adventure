import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/components/jump_button.dart';
import 'package:pixel_adventure/components/pause_button.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

enum PlayState { mainMenu, characterSelect, playing, pause, settings, won }

class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late CameraComponent cam;
  late JoystickComponent joystick;
  late Player player;
  late Timer _timer;

  List<String> levelNames = ['level-01', 'level-02'];

  // Sound Config
  bool showControls = false;
  bool playSounds = false;
  double soundVolume = 0.7;

  final ValueNotifier<int> elapsedSecs = ValueNotifier<int>(0);

  int currentLevelIndex = 0;
  int bestTime = 0;

  late PlayState _playState;
  PlayState? previousState;

  PlayState get playState => _playState;
  set playState(PlayState playState) {
    if (playState == PlayState.settings && _playState != PlayState.settings) {
      previousState = _playState;
    }
    _playState = playState;

    switch (playState) {
      case PlayState.mainMenu:
        overlays.remove(PlayState.settings.name);
        overlays.remove(PlayState.pause.name);
        overlays.remove(PlayState.characterSelect.name);
        overlays.add(PlayState.mainMenu.name);
        break;
      case PlayState.characterSelect:
        overlays.remove(PlayState.mainMenu.name);
        overlays.add(PlayState.characterSelect.name);
        break;
      case PlayState.playing:
        overlays.remove(PlayState.mainMenu.name);
        overlays.remove(PlayState.characterSelect.name);
        overlays.remove(PlayState.pause.name);
        Future.delayed(Duration(seconds: 1), () {
          overlays.add(PlayState.playing.name);
        });
        break;
      case PlayState.settings:
        overlays.remove(PlayState.mainMenu.name);
        overlays.add(PlayState.settings.name);
        break;
      case PlayState.pause:
        paused = true;
        overlays.remove(PlayState.settings.name);
        overlays.add(PlayState.pause.name);
        break;
      case PlayState.won:
        overlays.remove(PlayState.playing.name);
        overlays.add(PlayState.won.name);
        break;
    }
  }

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    playState = PlayState.mainMenu;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (playState == PlayState.playing) {
      _timer.update(dt);

      if (showControls) {
        udpateJoystick();
      }
    }

    super.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (playState == PlayState.playing) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.escape:
          playState = PlayState.pause;
          break;
        default:
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void startGame() {
    playState = PlayState.playing;

    _loadLevel();
    startTimer();

    if (showControls) {
      addJoystick();
      add(JumpButton());
      add(PauseButton());
    }
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 1,
      knob: SpriteComponent(sprite: Sprite(images.fromCache('HUD/Knob.png'))),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png')),
      ),
      margin: EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }

  void udpateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadNextLevel() {
    removeWhere((componenent) => componenent is Level);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      _gameCleared();
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      cam =
          CameraComponent.withFixedResolution(
              world: world,
              width: 800,
              height: 448,
            )
            ..priority = 0
            ..viewfinder.anchor = Anchor.topLeft;

      addAll([cam, world]);
    });
  }

  void resetGame() {
    paused = false; // Unpause the game to make command works
    removeAll(children.toList()); // Remove all game components
    currentLevelIndex = 0; // Reset the level to 0
    elapsedSecs.value = 0; // Reset the timer
    overlays.clear(); // clear overlays if needed
  }

  void _gameCleared() {
    stopTimer();

    // Update the best time
    if (bestTime == 0) {
      bestTime = elapsedSecs.value;
    } else if (bestTime > elapsedSecs.value) {
      bestTime = elapsedSecs.value;
    }

    playState = PlayState.won;
  }

  void startTimer() {
    _timer = Timer(
      1,
      onTick: () {
        if (playState == PlayState.playing) {
          elapsedSecs.value += 1;
        }
      },
      repeat: true,
    );
  }

  void stopTimer() {
    _timer.stop();
  }
}
