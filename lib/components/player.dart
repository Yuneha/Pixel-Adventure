import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/components/checkpoint.dart';
import 'package:pixel_adventure/components/chicken.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/custom_hitbox.dart';
import 'package:pixel_adventure/components/fruit.dart';
import 'package:pixel_adventure/components/saw.dart';
import 'package:pixel_adventure/components/spikes.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState {
  idle,
  running,
  jumping,
  falling,
  hit,
  appearing,
  disappearing,
}

class Player extends SpriteAnimationGroupComponent
    with HasGameReference<PixelAdventure>, KeyboardHandler, CollisionCallbacks {
  String character;
  Player({super.key, super.position, this.character = 'Ninja Frog'});

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;

  final double _gravity = 9.8;
  final double _jumpForce = 250;
  final double _terminalVelocity = 300;
  final double stepTime = 0.05;
  late double jumpLeft;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;
  double maxJump = 1;
  double wallJumpSide = 0;
  double wallJumpLockout = 0.0;

  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();

  bool isOnGround = false;
  bool isOnLeftWall = false;
  bool isOnRightWall = false;
  bool hasJump = false;
  bool hasDoubleJump = true;
  bool gotHit = false;
  bool reachedCheckpoint = false;
  bool wasJumpKeyPressed = false;
  bool isDoubleJumpactive = false;
  bool isWallJumpActive = false;

  List<CollisionBlock> collisionBlocks = [];

  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    // debugMode = true;

    jumpLeft = 1;
    startingPosition = Vector2(position.x, position.y);

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      if (!gotHit && !reachedCheckpoint) {
        _updatePlayerState();
        _updatePlayerMovement(fixedDeltaTime);
        _checkHorizontalCollisions();
        _applyGravity(fixedDeltaTime);
        _checkVerticalCollisions();
      }
      accumulatedTime -= fixedDeltaTime;
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;

    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJump =
        keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW);

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (!reachedCheckpoint) {
      if (other is Fruit) other.collidedWithPlayer(this);
      if (other is Saw || other is Spikes) _respawn();
      if (other is Chicken) other.collideddWithPlayer();
      if (other is Checkpoint) _reachedCheckpoint();
    }

    super.onCollisionStart(intersectionPoints, other);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);
    hitAnimation = _spriteAnimation('Hit', 7)..loop = false;
    appearingAnimation = _specialSpriteAnimation('Appearing', 7);
    disappearingAnimation = _specialSpriteAnimation('Desappearing', 7);

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.appearing: appearingAnimation,
      PlayerState.disappearing: disappearingAnimation,
    };

    // Set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$state (96x96).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(96),
        loop: false,
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (isDoubleJumpactive) maxJump = 2;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // Check if moving, set to running
    if (velocity.x < 0 || velocity.x > 0) playerState = PlayerState.running;

    // Check if falling, set to falling
    if (velocity.y > 0) playerState = PlayerState.falling;

    // Check if jumping, set to jumping
    if (velocity.y < 0) playerState = PlayerState.jumping;

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    bool isJumpKeyCurrentlyPressed = hasJump;
    bool jumpKeyJustPressed = isJumpKeyCurrentlyPressed && !wasJumpKeyPressed;
    wasJumpKeyPressed = isJumpKeyCurrentlyPressed;

    if (velocity.y > 0) isOnGround = false;

    if (jumpKeyJustPressed) {
      // First jump
      if (isOnGround && jumpLeft >= 1) {
        _playerJump(dt);
      } else {
        // Double Jump
        if (isDoubleJumpactive && jumpLeft > 0 && velocity.y >= 0) {
          jumpLeft--;
          _playerDoubleJump(dt);
        }
      }

      // Wall Jump
      if ((isOnLeftWall || isOnRightWall) &&
          !isOnGround &&
          jumpLeft == 1 &&
          isWallJumpActive) {
        _playerWallJump(dt);
      }
    }

    // Reset number of jump left when touching the ground
    if (isOnGround) jumpLeft = maxJump;

    if (wallJumpLockout > 0) {
      wallJumpLockout -= dt;
    }

    // Lock the velocity.x change when walljump
    if (wallJumpLockout <= 0) {
      velocity.x = horizontalMovement * moveSpeed;
    }

    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    if (game.playSounds) FlameAudio.play('jump.wav', volume: game.soundVolume);
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJump = false;
    jumpLeft--;
  }

  void _playerDoubleJump(double dt) {
    _playerJump(dt);
  }

  void _playerWallJump(double dt) {
    velocity.y = -_jumpForce;

    if (isOnLeftWall) {
      wallJumpSide = -1;
      velocity.x = _jumpForce / 2;
    } else if (isOnRightWall) {
      wallJumpSide = 1;
      velocity.x = -_jumpForce / 2;
    }

    wallJumpLockout = 0.2;

    // Update position
    position.y += velocity.y * dt;
    position.x += velocity.x * dt;

    if (wallJumpSide != 1 && !isOnGround) {
      isOnRightWall = true;
    } else {
      isOnRightWall = false;
    }
    jumpLeft--;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            if (wallJumpSide != 1 && !isOnGround && isWallJumpActive) {
              isOnRightWall = true;
              jumpLeft = 1;
            }
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            if (wallJumpSide != -1 && !isOnGround && isWallJumpActive) {
              isOnLeftWall = true;
              jumpLeft = 1;
            }
            break;
          }
        }
        isOnLeftWall = false;
        isOnRightWall = false;
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        // handle platorm
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            wallJumpSide = 0;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            wallJumpSide = 0;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
            break;
          }
        }
      }
    }
  }

  void _respawn() async {
    if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
    const canMoveDuration = Duration(milliseconds: 400);
    gotHit = true;
    current = PlayerState.hit;

    await animationTicker?.completed;
    animationTicker?.reset();

    scale.x = 1;
    position = startingPosition - Vector2.all(32);
    current = PlayerState.appearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    position = startingPosition;
    velocity.y = 0;
    current = PlayerState.idle;
    Future.delayed(canMoveDuration, () => gotHit = false);
  }

  void _reachedCheckpoint() async {
    reachedCheckpoint = true;

    isDoubleJumpactive = false;
    isWallJumpActive = false;

    if (game.playSounds) {
      FlameAudio.play('disappear.wav', volume: game.soundVolume);
    }

    if (scale.x > 0) {
      position = position - Vector2.all(32);
    } else if (scale.x < 0) {
      position = position + Vector2(32, -32);
    }

    current = PlayerState.disappearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    reachedCheckpoint = false;
    position = Vector2.all(-640);

    const waitToChangeLevelDuration = Duration(seconds: 3);
    Future.delayed(waitToChangeLevelDuration, () => game.loadNextLevel());
  }

  void collidedWithEnemy() {
    _respawn();
  }
}
