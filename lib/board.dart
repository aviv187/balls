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

  List<List<Offset>> enterPaths = [];
  List<List<List<Offset>>> crossesPaths = [];

  List<BallClass> balls = [];
  List<BallClass> dropBalls = [];

  BallClass nextNewBall = BallClass(
    color: Colors.red,
    speed: 26,
  );

  //time till new ball
  Timer timer1;
  int _newBallTime = 5;
  int _currentNewBallTime;

  //bal time to drop
  Timer timer2;
  int _timeToDropBall;
  bool droped;

  // tgame timer
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
          gameStopwatch = (swatch.elapsed.inMinutes % 60)
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
    timer1.cancel();
    timer2.cancel();
    timer3.cancel();
    super.dispose();
  }

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
        break;
      case 25:
        nextNewBall.color = Colors.yellow;
        nextNewBall.speed = 23;
        break;
      case 23:
        nextNewBall.color = Colors.greenAccent.shade700;
        nextNewBall.speed = 22;
        break;
      case 22:
        nextNewBall.color = Colors.blue.shade400;
        nextNewBall.speed = 20;
        break;
      case 20:
        nextNewBall.color = Colors.deepPurple.shade400;
        nextNewBall.speed = 19;
        break;
      case 19:
        nextNewBall.color = Colors.pink.shade300;
        nextNewBall.speed = 17;
        break;
      case 17:
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
      HapticFeedback.vibrate();
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
        //draw the game timer
        Positioned(
          top: 20,
          right: 20,
          child: Center(
            child: Text('$gameStopwatch'),
          ),
        ),
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
        //draw all the movable droped balls
        Stack(
          children: dropBalls
              .map(
                (ball) => DragBall(
                  ball: ball,
                  disposeOfTheBall: () => dropBalls.remove(ball),
                  ballDropTime: null,
                  positionFromTop: ball.path[1].dy - 20,
                  positionFromLeft: ball.path[1].dx - 20,
                  gameOver: gameOver,
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
                positionFromTop: 20,
                positionFromLeft: 20,
                gameOver: gameOver,
              ),
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
                    onWillAccept: (BallClass ball) {
                      HapticFeedback.heavyImpact();
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
          child: GameOverButton(
            gameOver: gameOver,
            restartGame: restartGame,
            gameEndTime: gameStopwatch,
          ),
        ),
      ],
    );
  }
}
