import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/routeDraw.dart' as Route;
import '../widgets/ball.dart';
import '../models/ballModel.dart';
import '../widgets/dragBall.dart';
import '../widgets/gameOverButton.dart';
import '../helpFunction/feedbackController.dart';

class Board extends StatefulWidget {
  final double height;
  final double width;
  final Function makeBoard;

  Board({this.height, this.width, this.makeBoard});
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
  bool droped = false;

  // game timer
  Timer timer3;
  String gameStopwatch = '00:00:00';

  MyDraggableController<BallClass> draggableController;

  @override
  void initState() {
    this.draggableController = new MyDraggableController<BallClass>();
    super.initState();
  }

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
            if (_newBallTime < 60) {
              _newBallTime += 5;
            }
            newBallTimer(_newBallTime);
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
    if (gameStopwatch == '00:00:00') {
      startGameTimer();
      newBallTimer(_newBallTime);
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
        Color(0xff00c853);
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
  void _addBall(BallClass ball) {
    setState(() {
      balls.add(BallClass(
        color: ball.color,
        path: ball.path,
        speed: ball.speed,
        key: ball.key,
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
      droped = false;

      gameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //make the board only fot the first time
    if (enterPaths.length == 0) {
      widget.makeBoard(
        height: widget.height,
        witdh: widget.width,
        enters: enterPaths,
        crosses: crossesPaths,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Balls'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          // draw all paths
          Hero(
            tag: widget.makeBoard.hashCode,
            child: Route.RouteDraw(
              enterPaths: enterPaths,
              crossesPaths: crossesPaths,
            ),
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
                    controller: draggableController,
                  ),
                )
                .toList(),
          ),
          // draw new drgable ball
          (droped)
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
                  controller: draggableController,
                ),
          // drop places widget
          Stack(
            children: enterPaths.map((enter) {
              return Positioned(
                left: enter[0].dx - 40,
                top: enter[0].dy - 50,
                child: DragTarget<BallClass>(
                  builder: (BuildContext context, List<BallClass> candidateData,
                      List<dynamic> rejectedData) {
                    return Container(
                      height: 100,
                      width: 80,
                      child: candidateData.isEmpty
                          ? SimpleBall(color: Colors.transparent)
                          : SimpleBall(
                              color: candidateData[candidateData.length - 1]
                                  .color),
                    );
                  },
                  onLeave: (ball) {
                    draggableController.onTarget(false, ball);
                  },
                  onWillAccept: (BallClass ball) {
                    draggableController.onTarget(true, ball);

                    HapticFeedback.heavyImpact();
                    return true;
                  },
                  onAccept: (BallClass ball) {
                    ball.path = enter;
                    _addBall(ball);

                    return true;
                  },
                ),
              );
            }).toList(),
          ),
          // End game button
          (gameOver)
              ? GameOverButton(
                  gameOver: gameOver,
                  restartGame: restartGame,
                  gameEndTime: gameStopwatch,
                )
              : Container(),
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
      ),
    );
  }
}
