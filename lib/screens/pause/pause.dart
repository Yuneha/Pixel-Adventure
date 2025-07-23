import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/custom_button.dart';

class Pause extends StatelessWidget {
  final PixelAdventure game;
  const Pause({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Semi-transparent background
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withValues(alpha: 0.3),
        ),

        _buildPausedMenuContent(),
      ],
    );
  }

  Widget _buildPausedMenuContent() {
    return Center(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: Color(0xFF211F30)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pause',
              style: TextStyle(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // Resume Button
            CustomButton(
              text: 'Continue',
              onPressed: () {
                game.playState = PlayState.playing;
                game.paused = false;
              },
            ),

            const SizedBox(height: 20),

            // Settings Button
            CustomButton(
              text: 'Settings',
              onPressed: () => game.playState = PlayState.settings,
            ),

            const SizedBox(height: 20),

            // Back to Menu Button
            CustomButton(
              text: 'Quit',
              onPressed: () {
                game.resetGame();
                game.playState = PlayState.mainMenu;
              },
            ),
          ],
        ),
      ),
    );
  }
}
