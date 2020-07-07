import 'package:flutter/material.dart';

import './routeDraw.dart' as Route;
import './ball.dart';
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

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final List<List<Offset>> allPaths = [
    enter1,
    enter2,
    enter3,
    ...cross1,
    ...cross2
  ];

  final List<List<Offset>> enterPaths = [
    enter1,
    enter2,
    enter3,
  ];

  List<BallClass> ballsList = [];

  void changeBallRoute(Key key, List<Offset> path) {
    int index = ballsList.indexWhere((b) => b.key == key);
    if (path[1] == cross1[0][0]) {
      setState(() {
        ballsList[index].path = cross1[0];
        cross1.add(cross1[0]);
        cross1.removeAt(0);
      });
    } else if (path[1] == cross2[0][0]) {
      setState(() {
        ballsList[index].path = cross2[0];
        cross2.add(cross2[0]);
        cross2.removeAt(0);
      });
    } else {
      // handle ball droping
    }
  }

  void _addBall(List<Offset> enter, Color color, int speed) {
    setState(() {
      ballsList.add(BallClass(
        path: enter,
        color: color,
        speed: speed,
        key: UniqueKey(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Stack(
          children: allPaths
              .map(
                (path) => Route.RouteDraw(
                  path: path,
                ),
              )
              .toList(),
        ),
        Stack(
          children: ballsList
              .map(
                (ball) => Ball(
                  key: ball.key,
                  onRouteCompleted: changeBallRoute,
                  color: ball.color,
                  speed: ball.speed,
                  path: ball.path,
                ),
              )
              .toList(),
        ),
        Stack(
          children: enterPaths
              .map(
                (enter) => Positioned(
                  left: enter[0].dx - 10,
                  top: enter[0].dy - 10,
                  child: DragTarget(
                    builder:
                        (context, List<String> candidateData, rejectedData) {
                      return Container(
                        height: 20,
                        width: 20,
                      );
                    },
                    onWillAccept: (d) {
                      return true;
                    },
                    onAccept: (d) {
                      _addBall(
                        enter,
                        nextBall.color,
                        nextBall.speed,
                      );
                    },
                  ),
                ),
              )
              .toList(),
        ),
        Positioned(
            top: 20,
            left: 20,
            child: Row(children: <Widget>[
              Container(
                child: Text(
                  'New Ball',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Draggable(
                child: DragBall(),
                feedback: DragBall(),
                childWhenDragging: Container(),
                onDragCompleted: () {
                  changeNewBall(nextBall.speed);
                },
                data: 'Ball',
              ),
            ])),
      ],
    );
  }
}

NextBall nextBall = NextBall(
  color: Colors.red,
  speed: 20,
);

void changeNewBall(int speed) {
  switch (speed) {
    case 20:
      nextBall.color = Colors.orangeAccent.shade700;
      nextBall.speed = 18;
      break;
    case 18:
      nextBall.color = Colors.yellow;
      nextBall.speed = 16;
      break;
    case 16:
      nextBall.color = Colors.greenAccent.shade700;
      nextBall.speed = 14;
      break;
    case 14:
      nextBall.color = Colors.blue.shade400;
      nextBall.speed = 12;
      break;
    case 12:
      nextBall.color = Colors.deepPurple.shade400;
      nextBall.speed = 10;
      break;
    case 10:
      nextBall.color = Colors.pink.shade300;
      nextBall.speed = 8;
      break;
    case 8:
      nextBall.color = Colors.red;
      nextBall.speed = 20;
      break;
    default:
      nextBall.color = Colors.red;
      nextBall.speed = 20;
  }
}

class DragBall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: nextBall.color,
        shape: BoxShape.circle,
      ),
    );
  }
}
