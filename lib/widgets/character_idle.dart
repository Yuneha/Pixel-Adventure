import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class CharacterIdleGame extends FlameGame
    with HasGameReference<PixelAdventure> {
  final String characterName;

  CharacterIdleGame({required this.characterName});

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    final image = await images.load(
      'Main Characters/$characterName/Idle (32x32).png',
    );
    final spriteSheet = SpriteSheet(image: image, srcSize: Vector2(32, 32));
    final animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.05,
      to: 11,
    );

    add(
      SpriteAnimationComponent(
        animation: animation,
        size: Vector2.all(64),
        position: Vector2.zero(),
      ),
    );
  }
}
