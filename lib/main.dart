import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raycasting/game_data.dart';
import 'package:raycasting/map.dart';
import 'package:raycasting/raycaster.dart';
import 'package:raycasting/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Raycasting',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Raycasting'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  late PlayerData playerData;
  late FocusNode globalFocus;

  @override
  void initState() {
    super.initState();
    playerData = PlayerData();
    globalFocus = FocusNode(
      onKeyEvent: (node, event) {
        _onKeyPress(event);
        return KeyEventResult.handled;
      },
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Focus(
        focusNode: globalFocus,
        child: Raycaster(
          playerData: playerData,
        ),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       const Text('Hope it works'),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headlineMedium,
      //       ),
      //       const MyCustomWidget(),
      //     ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onKeyPress(event) {
    // print('${event}');

    // if (event.character != null && event.character == 'w') {
    if (event.physicalKey == PhysicalKeyboardKey.arrowUp) {
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
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown) {
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
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowLeft) {
      playerData.angle -= playerData.rotationSpeed;
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowRight) {
      playerData.angle += playerData.rotationSpeed;
    }
    setState(() {});
  }
}

class MyCustomWidget extends StatelessWidget {
  const MyCustomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('not sure if zed is not faster than this'));
  }
}
