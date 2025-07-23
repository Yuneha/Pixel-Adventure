import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/custom_button.dart';

class MainMenu extends StatelessWidget {
  final PixelAdventure game;
  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Game Title',
              style: TextStyle(
                fontSize: 72,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // Start Game Button
            CustomButton(
              text: 'Play',
              onPressed: () => game.playState = PlayState.characterSelect,
            ),

            const SizedBox(height: 20),

            // Settings Button
            CustomButton(
              text: 'Settings',
              onPressed: () => game.playState = PlayState.settings,
            ),

            const SizedBox(height: 20),

            // Exit Button
            CustomButton(text: 'Exit', onPressed: () => SystemNavigator.pop()),
          ],
        ),
      ),
    );
  }
}
