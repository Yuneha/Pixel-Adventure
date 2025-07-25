import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:pixel_adventure/components/custom_hitbox.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameReference<PixelAdventure>, CollisionCallbacks {
  final String fruit;
  Fruit({super.key, this.fruit = 'Apple', super.position, super.size});

  final double stepTime = 0.05;
  final hitbox = CustomHitbox(offsetX: 10, offsetY: 10, width: 12, height: 12);
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    // debugMode = true;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$fruit.png'),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );

    return super.onLoad();
  }

  void collidedWithPlayer(Player player) async {
    if (!collected) {
      collected = true;

      // Apple: Double Jump
      // Orange: Wall Jump
      if (fruit == 'Apple') {
        player.isDoubleJumpactive = true;
        player.isWallJumpActive = false;
      }
      if (fruit == 'Orange') {
        player.isWallJumpActive = true;
        player.isDoubleJumpactive = false;
      }

      if (game.playSounds) {
        FlameAudio.play('collect_fruit.wav', volume: game.soundVolume);
      }

      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Collected.png'),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );

      await animationTicker?.completed;
      removeFromParent();
    }
  }
}
