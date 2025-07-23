import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class PauseButton extends SpriteComponent
    with HasGameReference<PixelAdventure>, TapCallbacks {
  PauseButton();

  final margin = 32;
  final buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    priority = 1;

    sprite = Sprite(game.images.fromCache('HUD/PauseButton.png'));
    position = Vector2(game.size.x - margin - buttonSize, 0.0 + margin);

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.playState = PlayState.pause;
    super.onTapDown(event);
  }
}
