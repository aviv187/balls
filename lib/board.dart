import 'package:flutter/material.dart';

import 'routeDraw.dart' as Route;
import './ballDraw.dart' as Ball;

class Board extends StatefulWidget {
  final int entries;
  final int exits;

  Board({this.entries, this.exits});

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    const List<Offset> enter1 = [Offset(50, 100), Offset(150, 200)];
    const List<Offset> enter2 = [Offset(200, 100), Offset(150, 200)];
    const List<Offset> enter3 = [Offset(200, 100), Offset(150, 200)];
    const List<List<Offset>> cross1 = [
      [Offset(150, 200), Offset(250, 300)],
      [Offset(150, 200), Offset(50, 400)],
      [Offset(150, 200), Offset(150, 400)],
      [Offset(150, 200), Offset(200, 400)]
    ];
    const List<List<Offset>> cross2 = [
      [Offset(250, 300), Offset(200, 400)],
      [Offset(250, 300), Offset(250, 400)],
      [Offset(250, 300), Offset(300, 400)],
      [Offset(250, 300), Offset(350, 400)]
    ];

    final List<List<Offset>> routesPaths = [
      enter1,
      enter2,
      enter3,
      ...cross1,
      ...cross2
    ];

    List<Offset> ballCurrentRoute = enter1;

    void changeBallRoute() {
      setState(() {
        ballCurrentRoute = cross1[0];
        print('animetion end');
      });
    }

    return Stack(
      children: <Widget>[
        Stack(
          children: routesPaths.map((path) {
            return Route.RouteDraw(
              path: path,
            );
          }).toList(),
        ),
        Ball.BallDraw(
          changeBallRoute: changeBallRoute,
          path: ballCurrentRoute,
        )
      ],
    );
  }
}
