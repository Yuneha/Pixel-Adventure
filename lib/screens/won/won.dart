import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/custom_button.dart';

class Won extends StatelessWidget {
  final PixelAdventure game;
  const Won({super.key, required this.game});

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

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
              'Congratulation !',
              style: TextStyle(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            _buildTimeDisplay(),

            const SizedBox(height: 20),

            // Return to MainMenu Button
            CustomButton(
              text: 'Return to menu',
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

  Widget _buildTimeDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 50,
      children: [
        Column(
          children: [
            Text(
              'Your Time',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),

            Text(
              formatTime(game.elapsedSecs.value),
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ],
        ),

        Column(
          children: [
            Text(
              'Best Time',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),

            Text(
              formatTime(game.bestTime),
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
