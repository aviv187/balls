import 'dart:async';

import 'package:flutter/material.dart';

import './routeDraw.dart' as Route;
import './ball.dart';
import './models.dart';
import './dragBall.dart';
import './gameOverButton.dart';

const List<Offset> enter1 = [Offset(50, 80), Offset(80, 200)];
const List<Offset> enter2 = [Offset(100, 80), Offset(80, 200)];
const List<Offset> enter3 = [Offset(150, 80), Offset(180, 150)];
const List<Offset> enter4 = [Offset(200, 80), Offset(180, 150)];
const List<Offset> enter5 = [Offset(250, 80), Offset(270, 280)];
const List<Offset> enter6 = [Offset(300, 80), Offset(270, 280)];
List<List<Offset>> cross1 = [
  [Offset(180, 150), Offset(80, 200)],
  [Offset(180, 150), Offset(270, 280)],
  [Offset(180, 150), Offset(140, 320)],
];
List<List<Offset>> cross2 = [
  [Offset(80, 200), Offset(140, 320)],
  [Offset(80, 200), Offset(40, 420)],
  [Offset(80, 200), Offset(100, 420)],
];
List<List<Offset>> cross3 = [
  [Offset(270, 280), Offset(140, 320)],
  [Offset(270, 280), Offset(250, 420)],
  [Offset(270, 280), Offset(300, 420)],
];
List<List<Offset>> cross4 = [
  [Offset(140, 320), Offset(100, 420)],
  [Offset(140, 320), Offset(170, 420)],
  [Offset(140, 320), Offset(250, 420)],
];

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  bool gameOver = false;

  final List<List<Offset>> allPaths = [
    enter1,
    enter2,
    enter3,
    enter4,
    enter5,
    enter6,
    ...cross1,
    ...cross2,
    ...cross3,
    ...cross4,
  ];

  final List<List<Offset>> enterPaths = [
    enter1,
    enter2,
    enter3,
    enter4,
    enter5,
    enter6,
  ];

  List<List<List<Offset>>> crossesPaths = [
    cross1,
    cross2,
    cross3,
    cross4,
  ];

  List<BallClass> balls = [];
  List<BallClass> dropBalls = [];

  BallClass nextNewBall = BallClass(
    color: Colors.red,
    speed: 26,
  );

  Timer timer;
  int _newBallTime = 5;
  int _currentNewBallTime;

  Timer timer2;
  int _timeToDropBall;
  bool droped;

  // timer for new ball dropping
  void newBallTimer(int startTime) {
    _currentNewBallTime = startTime;
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_currentNewBallTime == 1) {
            timer.cancel();
            _currentNewBallTime = null;
            dropBallTimer();
          } else {
            _currentNewBallTime = _currentNewBallTime - 1;
          }
        },
      ),
    );
  }

  // timer for the user to drop the ball
  void dropBallTimer() {
    _timeToDropBall = 5;
    droped = false;
    const oneSec = const Duration(seconds: 1);
    timer2 = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_timeToDropBall == 1) {
            timer.cancel();
            _timeToDropBall = null;

            if (!droped) {
              gameOver = true;
            }
          } else {
            _timeToDropBall = _timeToDropBall - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    timer2.cancel();
    super.dispose();
  }

  void changeNewBall(int speed) {
    newBallTimer(_newBallTime);

    if (_newBallTime < 60) {
      _newBallTime += 5;
    }

    droped = true;

    switch (speed) {
      case 26:
        nextNewBall.color = Colors.orangeAccent.shade700;
        nextNewBall.speed = 24;
        break;
      case 24:
        nextNewBall.color = Colors.yellow;
        nextNewBall.speed = 22;
        break;
      case 22:
        nextNewBall.color = Colors.greenAccent.shade700;
        nextNewBall.speed = 20;
        break;
      case 20:
        nextNewBall.color = Colors.blue.shade400;
        nextNewBall.speed = 18;
        break;
      case 18:
        nextNewBall.color = Colors.deepPurple.shade400;
        nextNewBall.speed = 16;
        break;
      case 16:
        nextNewBall.color = Colors.pink.shade300;
        nextNewBall.speed = 14;
        break;
      case 14:
        nextNewBall.color = Colors.red;
        nextNewBall.speed = 26;
        break;
      default:
        nextNewBall.color = Colors.red;
        nextNewBall.speed = 26;
    }
  }

  void changeBallRoute(Key key, List<Offset> path) {
    int index = balls.indexWhere((b) => b.key == key);

    for (int i = 0; i < crossesPaths.length; i++) {
      if (path[1] == crossesPaths[i][0][0]) {
        setState(() {
          balls[index].path = crossesPaths[i][0];
          crossesPaths[i].add(crossesPaths[i][0]);
          crossesPaths[i].removeAt(0);
        });
        return;
      }
    }

    setState(() {
      dropBalls.add(balls[index]);
      balls.removeAt(index);

      if (dropBalls.length == 3) {
        gameOver = true;
      }
    });
  }

  void _addBall(List<Offset> enter, Color color, int speed) {
    setState(() {
      balls.add(BallClass(
        path: enter,
        color: color,
        speed: speed,
        key: UniqueKey(),
      ));
    });
  }

  void restartGame() {
    setState(() {
      balls = [];
      dropBalls = [];

      nextNewBall = BallClass(
        color: Colors.red,
        speed: 26,
      );

      _newBallTime = 5;
      _currentNewBallTime = null;

      gameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // draw all paths
        Stack(
          children: allPaths
              .map(
                (path) => Route.RouteDraw(
                  path: path,
                ),
              )
              .toList(),
        ),
        // draw all the movig balls
        Stack(
          children: balls
              .map(
                (ball) => Ball(
                  key: ball.key,
                  onRouteCompleted: changeBallRoute,
                  color: ball.color,
                  speed: ball.speed,
                  path: ball.path,
                  gameOver: gameOver,
                ),
              )
              .toList(),
        ),
        //draw all the movable droped balls
        Stack(
          children: dropBalls
              .map(
                (ball) => Positioned(
                  top: ball.path[1].dy - 10,
                  left: ball.path[1].dx - 10,
                  child: DragBall(
                    ball,
                    () => dropBalls.remove(ball),
                    null,
                  ),
                ),
              )
              .toList(),
        ),
        // draw new drgable ball
        Positioned(
          top: 20,
          left: 20,
          child: (_currentNewBallTime != null)
              ? Text(
                  'new ball in $_currentNewBallTime',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: DragBall(
                    nextNewBall,
                    () => changeNewBall(nextNewBall.speed),
                    _timeToDropBall,
                  ),
                ),
        ),
        // drop places widget
        Stack(
          children: enterPaths
              .map(
                (enter) => Positioned(
                  left: enter[0].dx - 25,
                  top: enter[0].dy - 25,
                  child: DragTarget<BallClass>(
                    builder: (BuildContext context,
                        List<BallClass> candidateData,
                        List<dynamic> rejectedData) {
                      return Container(
                        height: 50,
                        width: 50,
                      );
                    },
                    onWillAccept: (BallClass ball) {
                      return true;
                    },
                    onAccept: (BallClass ball) {
                      _addBall(
                        enter,
                        ball.color,
                        ball.speed,
                      );
                      return true;
                    },
                  ),
                ),
              )
              .toList(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200),
          child: GameOverButton(gameOver, restartGame),
        ),
      ],
    );
  }
}
