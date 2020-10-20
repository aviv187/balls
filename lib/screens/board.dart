import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/routeDraw.dart' as Route;
import '../widgets/ball.dart';
import '../models/ballModel.dart';
import '../widgets/dragBall.dart';
import '../widgets/gameOverButton.dart';
import '../widgets/online.dart';
import '../helpFunction/feedbackController.dart';
import '../helpFunction/boardCreatePath.dart';

class Board extends StatefulWidget {
  final int boardNum;
  final int heroTag;
  final Size screenSize;
  final bool online;

  Board({
    this.boardNum,
    this.heroTag = 1,
    this.screenSize,
    this.online = false,
  });

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<List<Offset>> enterPaths = [];
  List<List<List<Offset>>> crossesPaths = [];

  bool gameOver = false;
  bool isLoser;

  List<BallClass> balls = [];
  List<BallClass> dropBalls = [];

  // first draganle ball
  BallClass nextNewBall = BallClass(
    color: Colors.red,
    speed: 10000,
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
    dropBallTimer();

    _currentNewBallTime = startTime;
    timer1 = new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (_currentNewBallTime < 2) {
            timer.cancel();
            _currentNewBallTime = null;

            if (_newBallTime < 60) {
              _newBallTime = (_newBallTime * 1.6).floor();
              if (_newBallTime > 60) {
                _newBallTime = 60;
              }
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
              setState(() {
                gameOver = true;
              });
              timer1.cancel();
              timer2.cancel();
              timer3.cancel();
            }
          } else if (_timeToDropBall != null) {
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
    timer1?.cancel();
    timer2?.cancel();
    timer3?.cancel();

    super.dispose();
  }

  // draw a new ball to drop
  void changeNewBall(int speed) {
    droped = true;

    switch (speed) {
      case 10000:
        nextNewBall.color = Colors.orangeAccent.shade700;
        nextNewBall.speed = 9500;
        nextNewBall.key = UniqueKey();
        break;
      case 9500:
        nextNewBall.color = Colors.yellow;
        nextNewBall.speed = 9000;
        nextNewBall.key = UniqueKey();
        break;
      case 9000:
        nextNewBall.color = Colors.greenAccent.shade700;
        nextNewBall.speed = 8500;
        nextNewBall.key = UniqueKey();
        break;
      case 8500:
        nextNewBall.color = Colors.blue.shade400;
        nextNewBall.speed = 8000;
        nextNewBall.key = UniqueKey();
        Color(0xff00c853);
        break;
      case 8000:
        nextNewBall.color = Colors.deepPurple.shade400;
        nextNewBall.speed = 7500;
        nextNewBall.key = UniqueKey();
        break;
      case 7500:
        nextNewBall.color = Colors.pink.shade300;
        nextNewBall.speed = 7000;
        nextNewBall.key = UniqueKey();
        break;
      case 7000:
        nextNewBall.color = Colors.red;
        nextNewBall.speed = 15000;
        nextNewBall.key = UniqueKey();
        break;
      default:
        nextNewBall.color = Colors.red;
        nextNewBall.speed = 15000;
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
        setState(() {
          gameOver = true;
        });
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
        speed: 10000,
        key: UniqueKey(),
      );

      gameStopwatch = '00:00:00';
      _newBallTime = 5;
      _timeToDropBall = null;
      _currentNewBallTime = null;
      droped = false;

      gameOver = false;

      startGameTimer();
      newBallTimer(_newBallTime);
    });
  }

  void updateTime() {}

  void makeBoard(int boardNum) {
    Function createBoardFunction = makeBoardFunctions[boardNum];

    createBoardFunction(
      height: widget.screenSize.height * 0.9,
      witdh: widget.screenSize.width,
      enters: enterPaths,
      crosses: crossesPaths,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (enterPaths.isEmpty && widget.boardNum != null) {
      makeBoard(widget.boardNum);
      startGameTimer();
      newBallTimer(_newBallTime);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text('Balls'),
          centerTitle: true,
          elevation: 0,
          actions: [
            widget.online == true
                ? Online(
                    onReady: (int number) {
                      setState(() {
                        makeBoard(number);
                      });

                      if (gameStopwatch == '00:00:00') {
                        startGameTimer();
                        newBallTimer(_newBallTime);
                      }
                    },
                    gameOver: gameOver,
                    isLoser: (bool didlose) {
                      setState(() {
                        isLoser = didlose;
                      });
                    },
                    playerTime: gameStopwatch,
                  )
                : Container(),
          ]),
      body: enterPaths.isEmpty
          ? Center(
              child: Container(
                  height: widget.screenSize.width - 100,
                  width: widget.screenSize.width - 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                  )),
            )
          : Stack(
              children: <Widget>[
                // draw all paths
                Hero(
                  tag: widget.heroTag,
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
                          screenSize: widget.screenSize,
                        ),
                      )
                      .toList(),
                ),
                // drop places widget
                Stack(
                  children: enterPaths.map((enter) {
                    return Positioned(
                      left: enter[0].dx - 40,
                      top: enter[0].dy - 50,
                      child: DragTarget<BallClass>(
                        builder: (BuildContext context,
                            List<BallClass> candidateData,
                            List<dynamic> rejectedData) {
                          return Container(
                            height: 100,
                            width: 80,
                            child: candidateData.isEmpty
                                ? SimpleBall(color: Colors.transparent)
                                : SimpleBall(
                                    color:
                                        candidateData[candidateData.length - 1]
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
                        disposeOfTheBall: () =>
                            changeNewBall(nextNewBall.speed),
                        ballDropTime: _timeToDropBall,
                        positionFromTop: 0,
                        positionFromLeft: 0,
                        gameOver: gameOver,
                        controller: draggableController,
                      ),
                // End game button
                (gameOver)
                    ? GameOverButton(
                        gameOver: gameOver,
                        restartGame: restartGame,
                        gameEndTime: gameStopwatch,
                        online: widget.online,
                        loser: isLoser,
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
