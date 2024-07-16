import 'package:raycasting/position.dart';

class Player {
  Position _position;
  double angle;

  Player({Position? position, this.angle = 0})
      : _position = position ?? Position(x: 1.5, y: 1.5);
}
