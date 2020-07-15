import 'package:flutter/material.dart';

import './models.dart';

class DragBall extends StatelessWidget {
  final BallClass ball;
  final Function disposeOfTheBall;
  final int ballDropTime;
  final double positionFromTop;
  final double positionFromLeft;
  final bool gameOver;
  final List<BallClass> ballsToRemove;

  DragBall({
    this.ball,
    this.disposeOfTheBall,
    this.ballDropTime,
    this.positionFromTop,
    this.positionFromLeft,
    this.gameOver,
    this.ballsToRemove,
  });

  @override
  Widget build(BuildContext context) {
    bool hit = ballsToRemove.contains(ball);
    print(hit);

    return Positioned(
        top: positionFromTop,
        left: positionFromLeft,
        child: Draggable<BallClass>(
          maxSimultaneousDrags: gameOver ? 0 : 2,
          data: ball,
          child: SimpleBall(
            color: ball.color,
            ballDropTime: ballDropTime,
          ),
          feedback: SimpleBall(
            color: (hit) ? Colors.transparent : ball.color,
            ballDropTime: null,
          ),
          childWhenDragging: (ballDropTime != null)
              ? Container(
                  height: 80,
                  width: 80,
                  child: Center(
                      child: Text(
                    '$ballDropTime',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )))
              : Container(),
          onDragCompleted: () {
            disposeOfTheBall();
          },
        ));
  }
}

class SimpleBall extends StatelessWidget {
  const SimpleBall({
    Key key,
    @required this.color,
    @required this.ballDropTime,
  }) : super(key: key);

  final Color color;
  final int ballDropTime;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        color: Colors.white.withOpacity(0.01),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: (ballDropTime == null)
              ? Container()
              : Center(
                  child: Text(
                  '$ballDropTime',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )),
        ));
  }
}
