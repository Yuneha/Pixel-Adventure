import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/screens/characterSelection/character_selection_menu.dart';
import 'package:pixel_adventure/screens/mainMenu/main_menu.dart';
import 'package:pixel_adventure/screens/pause/pause.dart';
import 'package:pixel_adventure/screens/settings/settings.dart';
import 'package:pixel_adventure/screens/won/won.dart';
import 'package:pixel_adventure/widgets/timer_overlay.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final PixelAdventure game;

  @override
  void initState() {
    super.initState();
    game = PixelAdventure();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pixel Adv',
      theme: ThemeData(
        fontFamily: 'Retro',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF211F30),
      ),
      home: Scaffold(
        body: GameWidget<PixelAdventure>(
          game: game,
          overlayBuilderMap: {
            PlayState.mainMenu.name: (context, game) => MainMenu(game: game),
            PlayState.characterSelect.name:
                (context, game) => CharacterSelectionMenu(
                  game: game,
                  onCharacterSelected: (selectedCharacter) {
                    // Save the selection and send it to the game
                    game.player = Player(character: selectedCharacter);
                  },
                ),
            PlayState.playing.name: (context, game) => TimerOverlay(game: game),
            PlayState.settings.name: (context, game) => Settings(game: game),
            PlayState.pause.name: (context, game) => Pause(game: game),
            PlayState.won.name: (context, game) => Won(game: game),
          },
        ),
      ),
    );
  }
}
