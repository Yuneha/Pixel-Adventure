import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/custom_button.dart';
import 'package:pixel_adventure/widgets/sound_slider.dart';

class Settings extends StatelessWidget {
  final PixelAdventure game;
  const Settings({super.key, required this.game});

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
              'Settings',
              style: TextStyle(
                fontSize: 72,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(width: 300, child: SoundSlider(game: game)),

            const SizedBox(height: 20),

            // Back Button
            CustomButton(
              text: 'Back',
              onPressed:
                  () => {
                    game.playState = game.previousState ?? PlayState.mainMenu,
                  },
            ),
          ],
        ),
      ),
    );
  }
}
