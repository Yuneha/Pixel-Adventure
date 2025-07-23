import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class TimerOverlay extends StatelessWidget {
  final PixelAdventure game;
  const TimerOverlay({super.key, required this.game});

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: game.elapsedSecs,
      builder: (context, value, child) {
        return Positioned(
          top: 32,
          left: 32,
          child: Text(
            formatTime(value),
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        );
      },
    );
  }
}
