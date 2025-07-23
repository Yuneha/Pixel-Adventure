import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Spikes extends SpriteComponent
    with HasGameReference<PixelAdventure>, CollisionCallbacks {
  Spikes({super.key, super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    priority = 1;
    // debugMode = true;

    add(RectangleHitbox(position: Vector2(0, 8), size: Vector2(16, 8)));

    sprite = Sprite(game.images.fromCache('Traps/Spikes/Idle.png'));

    return super.onLoad();
  }
}
