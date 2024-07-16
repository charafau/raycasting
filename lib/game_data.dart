class GameData {
  final ScreenData screenData;
  final PlayerData playerData;
  final RaycastingData raycastingData;
  final RenderData renderData;

  GameData({
    required this.screenData,
    required this.playerData,
    required this.renderData,
    RaycastingData? raycastingData,
  }) : raycastingData = raycastingData ??
            RaycastingData(
              incrementAngle:
                  playerData.fov.toDouble() / screenData.width.toDouble(),
            );
}

class RenderData {
  final int delay;

  RenderData({this.delay = 30});
}

class ScreenData {
  final int width;
  final int height;
  final int halfWidth;
  final int halfHeight;

  ScreenData({
    this.width = 640,
    this.height = 480,
  })  : halfWidth = (width.toDouble() / 2).toInt(),
        halfHeight = (height.toDouble() / 2).toInt();
}

class RaycastingData {
  final double incrementAngle;
  final int precision;

  RaycastingData({this.precision = 64, required this.incrementAngle});
}

class PlayerData {
  final int fov;
  final int halfFov;
  double x;
  double y;
  double angle;

  double movementSpeed;
  double rotationSpeed;

  PlayerData({
    this.fov = 60,
    this.x = 2,
    this.y = 2,
    this.angle = 90,
    this.movementSpeed = 0.5,
    this.rotationSpeed = 5.0,
  }) : halfFov = (fov.toDouble() / 2).toInt();
}
