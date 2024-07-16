import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:raycasting/game_data.dart';

import 'package:raycasting/map.dart';
import 'package:raycasting/utils.dart';

class Raycaster extends StatelessWidget {
  final PlayerData playerData;

  const Raycaster({super.key, required this.playerData});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size.square(double.infinity),
      painter: RaycasterPainter(
        gameData: GameData(
          screenData: ScreenData(),
          playerData: playerData,
          renderData: RenderData(),
        ),
      ),
    );
  }
}

class RaycasterPainter extends CustomPainter {
  final WorldMap worldMap = WorldMap();
  final double wallSize = 50;
  final GameData gameData;

  RaycasterPainter({required this.gameData}) {
    worldMap.getWalls();
  }

  void drawWorld(Canvas canvas, Size size) {
    // final Rect rect =

    worldMap.walls.forEach((wall) {
      final rect = Rect.fromLTWH(
          wall.x * wallSize, wall.y * wallSize, wallSize, wallSize);
      final _paint = Paint()..style = PaintingStyle.stroke;

      canvas.drawRect(
        rect,
        _paint..color = Colors.white,
      );
    });
  }

  void draw(Canvas canvas, Size size) async {
    clearScreen(canvas, size);

    raycasting(canvas, size);
    // drawWorld(canvas, size);

    await Future.delayed(Duration(milliseconds: gameData.renderData.delay));
  }

  void update() {}

  void raycasting(Canvas canvas, Size size) {
    double rayAngle =
        gameData.playerData.angle.toDouble() - gameData.playerData.halfFov;

    for (int rayCount = 0; rayCount < gameData.screenData.width; rayCount++) {
      Ray ray = Ray(
          x: gameData.playerData.x.toDouble(),
          y: gameData.playerData.y.toDouble());

      final rayCos = math.cos(degreeToRadians(rayAngle)) /
          gameData.raycastingData.precision;
      final raySin = math.sin(degreeToRadians(rayAngle)) /
          gameData.raycastingData.precision;

      // Wall finder
      int wall = 0;
      while (wall == 0) {
        ray.x += rayCos;
        ray.y += raySin;
        wall = miniMap[ray.y.floor()][ray.x.floor()];
      }

      // Pythagoras theorem
      var distance = math.sqrt(math.pow(gameData.playerData.x - ray.x, 2) +
          math.pow(gameData.playerData.y - ray.y, 2));

      // Fish eye fix
      distance = distance *
          math.cos(degreeToRadians(rayAngle - gameData.playerData.angle));

      // Wall height
      final wallHeight = (gameData.screenData.halfHeight / distance).floor();

      canvas.drawLine(
        Offset(
          rayCount.toDouble(),
          0,
        ),
        Offset(
          rayCount.toDouble(),
          (gameData.screenData.halfHeight - wallHeight).toDouble(),
        ),
        Paint()..color = Colors.cyan,
      );

      canvas.drawLine(
        Offset(
          rayCount.toDouble(),
          (gameData.screenData.halfHeight - wallHeight).toDouble(),
        ),
        Offset(
          rayCount.toDouble(),
          (gameData.screenData.halfHeight + wallHeight).toDouble(),
        ),
        Paint()..color = Colors.red,
      );

      canvas.drawLine(
        Offset(
          rayCount.toDouble(),
          (gameData.screenData.halfHeight + wallHeight).toDouble(),
        ),
        Offset(
          rayCount.toDouble(),
          (gameData.screenData.height).toDouble(),
        ),
        Paint()..color = Colors.green,
      );

      // increment angle
      rayAngle += gameData.raycastingData.incrementAngle;
    }
  }

  void clearScreen(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      // Paint()..shader = gradient.createShader(rect),
      Paint()..color = Colors.black,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    draw(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Ray {
  double x;
  double y;

  Ray({required this.x, required this.y});
}
