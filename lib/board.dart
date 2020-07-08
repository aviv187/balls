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
  bool gameOver = false;

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

  List<List<List<Offset>>> crossesPaths = [
    cross1,
    cross2,
  ];

  List<BallClass> balls = [];
  List<BallClass> dropBalls = [];

  BallClass nextNewBall = BallClass(
    color: Colors.red,
    speed: 26,
  );

  void changeNewBall(int speed) {
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
                  child: DragBall(ball, () => dropBalls.remove(ball)),
                ),
              )
              .toList(),
        ),
        // draw new drgable ball
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
              DragBall(nextNewBall, () => changeNewBall(nextNewBall.speed)),
            ])),
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

class GameOverButton extends StatelessWidget {
  final bool gameOver;
  final Function restartGame;

  GameOverButton(this.gameOver, this.restartGame);

  @override
  Widget build(BuildContext context) {
    double opacity = 1;
    if (!gameOver) {
      opacity = 0;
    }

    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: opacity,
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              'Game Over',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade600,
              ),
            ),
            SizedBox(height: 20),
            FlatButton(
              padding: EdgeInsets.all(0),
              highlightColor: Colors.blueGrey,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.blueGrey.withOpacity(0.75),
                ),
                child: Text(
                  'Play Again',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                if (gameOver) {
                  restartGame();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DragBall extends StatelessWidget {
  final BallClass ball;
  final Function disposeOfTheBall;

  DragBall(this.ball, this.disposeOfTheBall);
  @override
  Widget build(BuildContext context) {
    return Draggable<BallClass>(
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: ball.color,
          shape: BoxShape.circle,
        ),
      ),
      feedback: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: ball.color,
          shape: BoxShape.circle,
        ),
      ),
      childWhenDragging: Container(),
      onDragCompleted: () {
        disposeOfTheBall();
      },
      data: ball,
    );
  }
}
