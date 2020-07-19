import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './routeDraw.dart' as Route;
import './ball.dart';
import './models.dart';
import './dragBall.dart';
import './gameOverButton.dart';
import './boardCreatePath.dart';

class Board extends StatefulWidget {
  final double height;
  final double witdh;

  Board({this.height, this.witdh});
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  bool gameOver = false;
  bool gamePause = false;

  List<List<Offset>> enterPaths = [];
  List<List<List<Offset>>> crossesPaths = [];

  List<BallClass> balls = [];
  List<BallClass> dropBalls = [];
  List<BallClass> whereWillBallDrop = [];

  // first draganle ball
  BallClass nextNewBall = BallClass(
    color: Colors.red,
    speed: 26,
    key: UniqueKey(),
  );

  //time till new ball
  Timer timer1;
  int _newBallTime = 5;
  int _currentNewBallTime;

  //bal time to drop
  Timer timer2;
  int _timeToDropBall;
  bool droped;

  // game timer
  Timer timer3;
  String gameStopwatch = '00:00:00';

  // timer for new ball dropping
  void newBallTimer(int startTime) {
    _currentNewBallTime = startTime;
    timer1 = new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (_currentNewBallTime < 2) {
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
    timer2 = new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (_timeToDropBall == 1) {
            timer.cancel();
            _timeToDropBall = null;

            if (!droped) {
              gameOver = true;
              timer1.cancel();
              timer2.cancel();
              timer3.cancel();
            }
          } else {
            _timeToDropBall = _timeToDropBall - 1;
          }
        },
      ),
    );
  }

  // timer for the game
  void startGameTimer() {
    Stopwatch swatch = Stopwatch();

    swatch.start();

    timer3 = new Timer.periodic(
      Duration(milliseconds: 1),
      (Timer timer) => setState(
        () {
          gameStopwatch = (swatch.elapsed.inMinutes % 100)
                  .toString()
                  .padLeft(2, '0') +
              ':' +
              (swatch.elapsed.inSeconds % 60).toString().padLeft(2, '0') +
              ':' +
              (swatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0');
        },
      ),
    );
  }

  @override
  void dispose() {
    if (timer1 != null) {
      timer1.cancel();
    }
    if (timer2 != null) {
      timer2.cancel();
    }
    if (timer3 != null) {
      timer3.cancel();
    }
    super.dispose();
  }

  // draw a new ball to drop
  void changeNewBall(int speed) {
    newBallTimer(_newBallTime);

    if (gameStopwatch == '00:00:00') {
      startGameTimer();
    }

    if (_newBallTime < 60) {
      _newBallTime += 5;
    }

    droped = true;

    switch (speed) {
      case 26:
        nextNewBall.color = Colors.orangeAccent.shade700;
        nextNewBall.speed = 25;
        nextNewBall.key = UniqueKey();
        break;
      case 25:
        nextNewBall.color = Colors.yellow;
        nextNewBall.speed = 23;
        nextNewBall.key = UniqueKey();
        break;
      case 23:
        nextNewBall.color = Colors.greenAccent.shade700;
        nextNewBall.speed = 22;
        nextNewBall.key = UniqueKey();
        break;
      case 22:
        nextNewBall.color = Colors.blue.shade400;
        nextNewBall.speed = 20;
        nextNewBall.key = UniqueKey();
        break;
      case 20:
        nextNewBall.color = Colors.deepPurple.shade400;
        nextNewBall.speed = 19;
        nextNewBall.key = UniqueKey();
        break;
      case 19:
        nextNewBall.color = Colors.pink.shade300;
        nextNewBall.speed = 17;
        nextNewBall.key = UniqueKey();
        break;
      case 17:
        nextNewBall.color = Colors.red;
        nextNewBall.speed = 26;
        nextNewBall.key = UniqueKey();
        break;
      default:
        nextNewBall.color = Colors.red;
        nextNewBall.speed = 26;
        nextNewBall.key = UniqueKey();
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
      HapticFeedback.lightImpact();
      dropBalls.add(balls[index]);
      balls.removeAt(index);

      if (dropBalls.length == 3) {
        gameOver = true;
        timer1.cancel();
        timer2.cancel();
        timer3.cancel();
      }
    });
  }

  // add new ball top the paths
  void _addBall({List<Offset> enter, Color color, int speed, Key key}) {
    setState(() {
      balls.add(BallClass(
        path: enter,
        color: color,
        speed: speed,
        key: key,
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
        key: UniqueKey(),
      );

      gameStopwatch = '00:00:00';
      _newBallTime = 5;
      _timeToDropBall = null;
      _currentNewBallTime = null;

      gameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (enterPaths.length == 0) {
      simpleBoard(
        height: widget.height,
        witdh: widget.witdh,
        enters: enterPaths,
        crosses: crossesPaths,
      );
    }

    return Stack(
      children: <Widget>[
        // draw all paths
        Stack(
          children: enterPaths
              .map((path) => Route.RouteDraw(
                    path: path,
                    index: 0,
                  ))
              .toList(),
        ),
        Stack(
            children: crossesPaths
                .map((list) => Stack(
                      children: list.map((path) {
                        int index = list.indexOf(path);
                        return Route.RouteDraw(
                          path: path,
                          index: index,
                        );
                      }).toList(),
                    ))
                .toList()),
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
        //draw all the drgable droped balls
        Stack(
          children: dropBalls
              .map(
                (ball) => DragBall(
                  ball: ball,
                  disposeOfTheBall: () => dropBalls.remove(ball),
                  ballDropTime: null,
                  positionFromTop: ball.path[1].dy - 40,
                  positionFromLeft: ball.path[1].dx - 40,
                  gameOver: gameOver,
                  ballsToRemove: whereWillBallDrop,
                ),
              )
              .toList(),
        ),
        // draw new drgable ball
        (_currentNewBallTime != null)
            ? Positioned(
                top: 20,
                left: 20,
                child: Text(
                  'new ball in $_currentNewBallTime',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              )
            : DragBall(
                ball: nextNewBall,
                disposeOfTheBall: () => changeNewBall(nextNewBall.speed),
                ballDropTime: _timeToDropBall,
                positionFromTop: 0,
                positionFromLeft: 0,
                gameOver: gameOver,
                ballsToRemove: whereWillBallDrop,
              ),
        // draw where will balls drop while dragged
        Stack(
            children: whereWillBallDrop.map((ball) {
          return Positioned(
              top: ball.path[0].dy - 40,
              left: ball.path[0].dx - 40,
              child: SimpleBall(
                color: ball.color,
                key: ball.key,
                ballDropTime: null,
              ));
        }).toList()),
        // drop places widget
        Stack(
          children: enterPaths
              .map(
                (enter) => Positioned(
                  left: enter[0].dx - 25,
                  top: enter[0].dy - 50,
                  child: DragTarget<BallClass>(
                    builder: (BuildContext context,
                        List<BallClass> candidateData,
                        List<dynamic> rejectedData) {
                      return Container(
                        height: 100,
                        width: 50,
                      );
                    },
                    onLeave: (ball) {
                      setState(() {
                        whereWillBallDrop.remove(ball);
                      });
                    },
                    onWillAccept: (BallClass ball) {
                      setState(() {
                        whereWillBallDrop.add(ball);
                        int index1 = whereWillBallDrop.indexOf(ball);
                        whereWillBallDrop[index1].path = enter;
                      });
                      HapticFeedback.heavyImpact();
                      return true;
                    },
                    onAccept: (BallClass ball) {
                      setState(() {
                        whereWillBallDrop.remove(ball);
                      });
                      _addBall(
                        enter: enter,
                        color: ball.color,
                        speed: ball.speed,
                        key: ball.key,
                      );
                      return true;
                    },
                  ),
                ),
              )
              .toList(),
        ),
        // End game button
        Padding(
          padding: const EdgeInsets.only(top: 200),
          child: GameOverButton(
            gameOver: gameOver,
            restartGame: restartGame,
            gameEndTime: gameStopwatch,
          ),
        ),
        //draw the game timer
        Positioned(
          top: 20,
          right: 20,
          child: Container(
            width: 70,
            child: Text('$gameStopwatch'),
          ),
        )
      ],
    );
  }
}
