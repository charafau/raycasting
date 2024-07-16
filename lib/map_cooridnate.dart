class MapCoordinate {
  final int x;
  final int y;

  MapCoordinate({required this.x, required this.y});

  @override
  String toString() {
    return 'Position (x: $x ; y: $y)';
  }
}
