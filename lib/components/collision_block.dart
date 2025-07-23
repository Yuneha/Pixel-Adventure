import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlatform;
  CollisionBlock({
    super.key,
    super.position,
    super.size,
    this.isPlatform = false,
  }) {
    // debugMode = true;
  }
}
