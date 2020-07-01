import 'dart:math';

import 'package:flutter/material.dart';

import './routeDraw.dart' as Route;
import './ballDraw.dart' as Ball;
import './models.dart';

const List<Offset> enter1 = [Offset(50, 100), Offset(150, 200)];
const List<Offset> enter2 = [Offset(200, 100), Offset(150, 200)];
const List<Offset> enter3 = [Offset(300, 100), Offset(250, 300)];
List<List<Offset>> cross1 = [
  [Offset(150, 200), Offset(250, 300)],
  [Offset(150, 200), Offset(50, 400)],
  [Offset(150, 200), Offset(150, 400)],
  [Offset(150, 200), Offset(200, 400)]
];
List<List<Offset>> cross2 = [
  [Offset(250, 300), Offset(200, 400)],
  [Offset(250, 300), Offset(250, 400)],
  [Offset(250, 300), Offset(300, 400)],
  [Offset(250, 300), Offset(350, 400)]
];

List<BallClass> ballList = [
  // BallClass(color: Colors.amber, ballCurrentPath: enter1),
  // BallClass(color: Colors.pink, ballCurrentPath: enter2),
];

class Board extends StatefulWidget {
  final int entries;
  final int exits;

  Board({this.entries, this.exits});

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final List<List<Offset>> routesPaths = [
    enter1,
    enter2,
    enter3,
    ...cross1,
    ...cross2
  ];

  void changeBallRoute(BallClass ball) {
    int index = ballList.indexOf(ball);
    if (ball.ballCurrentPath[1] == Offset(150, 200)) {
      setState(() {
        ballList[index].ballCurrentPath = cross1[0];
        cross1.add(cross1[0]);
        cross1.removeAt(0);
      });
    } else if (ball.ballCurrentPath[1] == Offset(250, 300)) {
      setState(() {
        ballList[index].ballCurrentPath = cross2[0];
        cross2.add(cross2[0]);
        cross2.removeAt(0);
      });
    } else {
      setState(() {
        Random number = Random();
        switch (number.nextInt(3)) {
          case 0:
            ballList[index].ballCurrentPath = enter1;
            break;
          case 1:
            ballList[index].ballCurrentPath = enter2;
            break;
          case 2:
            ballList[index].ballCurrentPath = enter3;
            break;
          default:
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Stack(
          children: routesPaths.map((path) {
            return Route.RouteDraw(
              path: path,
            );
          }).toList(),
        ),
        Stack(
          children: ballList.map((ball) {
            return Ball.BallDraw(
              changeBallpath: changeBallRoute,
              ball: ball,
            );
          }).toList(),
        ),
        Positioned(
          bottom: 30,
          right: 20,
          child: FloatingActionButton.extended(
            elevation: 0,
            onPressed: () {
              Random number = Random();
              Color color;
              switch (number.nextInt(8)) {
                case 0:
                  color = Colors.orangeAccent;
                  break;
                case 1:
                  color = Colors.pink;
                  break;
                case 2:
                  color = Colors.yellow;
                  break;
                case 3:
                  color = Colors.green;
                  break;
                case 4:
                  color = Colors.indigo;
                  break;
                case 5:
                  color = Colors.purple;
                  break;
                case 6:
                  color = Colors.red;
                  break;
                case 7:
                  color = Colors.cyan;
                  break;
                default:
                  color = Colors.indigo;
              }

              setState(() {
                ballList.add(BallClass(ballCurrentPath: enter1, color: color));
              });
            },
            label: Text('New Ball'),
            backgroundColor: Colors.pink,
          ),
        ),
      ],
    );
  }
}
