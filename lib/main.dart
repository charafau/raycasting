import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raycasting/game_data.dart';
import 'package:raycasting/map.dart';
import 'package:raycasting/raycaster.dart';
import 'package:raycasting/raycaster_flame.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // body: Focus(
      //   focusNode: globalFocus,
      //   child: Raycaster(
      //     playerData: playerData,
      //   ),
      // ),
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
      body: GameWidget(
        game: RaycasterFlame(
          gameData: GameData(
            screenData: ScreenData(),
            renderData: RenderData(),
            playerData: PlayerData(),
          ),
        ),
      ),
    );
  }
}

class MyCustomWidget extends StatelessWidget {
  const MyCustomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('not sure if zed is not faster than this'));
  }
}
