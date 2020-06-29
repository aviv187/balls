import 'package:flutter/material.dart';
import './route.dart' as BallRoute;

class Board extends StatelessWidget {
  final int entries;
  final int exits;

  Board({this.entries, this.exits});

  @override
  Widget build(BuildContext context) {
    const List<List<Offset>> routesPaths = [
      [Offset(100, 100), Offset(150, 200)],
      [Offset(200, 100), Offset(150, 200)],
      [Offset(300, 100), Offset(250, 300)],
      [Offset(150, 200), Offset(250, 300)],
      [Offset(150, 200), Offset(100, 400)],
      [Offset(150, 200), Offset(150, 400)],
      [Offset(150, 200), Offset(200, 400)],
      [Offset(250, 300), Offset(200, 400)],
      [Offset(250, 300), Offset(250, 400)],
      [Offset(250, 300), Offset(300, 400)],
      [Offset(250, 300), Offset(350, 400)],
    ];

    return Stack(
      children: routesPaths.map((path) {
        return BallRoute.Route(
          path: path,
        );
      }).toList(),
    );
  }
}
