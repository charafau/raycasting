import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raycasting/game_data.dart';
import 'package:raycasting/map.dart';
import 'package:raycasting/utils.dart';

class RaycasterFlame extends FlameGame with KeyboardEvents {
  final WorldMap worldMap = WorldMap();
  final double wallSize = 50;
  final GameData gameData;
  late PlayerData playerData;

  RaycasterFlame({required this.gameData}) {
    worldMap.getWalls();
    playerData = gameData.playerData;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    raycasting(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // TODO: implement update
  }

  void raycasting(Canvas canvas) {
    double rayAngle = playerData.angle.toDouble() - playerData.halfFov;

    for (int rayCount = 0; rayCount < gameData.screenData.width; rayCount++) {
      RayRay ray =
          RayRay(x: playerData.x.toDouble(), y: playerData.y.toDouble());

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
      var distance = math.sqrt(math.pow(playerData.x - ray.x, 2) +
          math.pow(playerData.y - ray.y, 2));

      // Fish eye fix
      distance =
          distance * math.cos(degreeToRadians(rayAngle - playerData.angle));

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

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is KeyDownEvent || event is KeyRepeatEvent;

    if (isKeyDown) {
      if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
        final playerCos = math.cos(degreeToRadians(playerData.angle)) *
            playerData.movementSpeed;
        final playerSin = math.sin(degreeToRadians(playerData.angle)) *
            playerData.movementSpeed;
        final newX = playerData.x + playerCos;
        final newY = playerData.y + playerSin;
        if (miniMap[newY.floor()][newX.floor()] == 0) {
          playerData.x = newX;
          playerData.y = newY;
        }
      } else if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
        final playerCos = math.cos(degreeToRadians(playerData.angle)) *
            playerData.movementSpeed;
        final playerSin = math.sin(degreeToRadians(playerData.angle)) *
            playerData.movementSpeed;
        final newX = playerData.x - playerCos;
        final newY = playerData.y - playerSin;
        if (miniMap[newY.floor()][newX.floor()] == 0) {
          playerData.x = newX;
          playerData.y = newY;
        }
      } else if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
        playerData.angle -= playerData.rotationSpeed;
      } else if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
        playerData.angle += playerData.rotationSpeed;
      }

      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}

class RayRay {
  double x;
  double y;

  RayRay({required this.x, required this.y});
}
