import 'package:flutter/material.dart';

import './models.dart';

class DragBall extends StatelessWidget {
  final BallClass ball;
  final Function disposeOfTheBall;
  final int ballDropTime;
  final double positionFromTop;
  final double positionFromLeft;
  final bool gameOver;

  DragBall({
    this.ball,
    this.disposeOfTheBall,
    this.ballDropTime,
    this.positionFromTop,
    this.positionFromLeft,
    this.gameOver,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: positionFromTop,
        left: positionFromLeft,
        child: Draggable<BallClass>(
          maxSimultaneousDrags: gameOver ? 0 : 2,
          data: ball,
          child: SimpleBall(
            ball: ball,
            ballDropTime: ballDropTime,
          ),
          feedback: SimpleBall(
            ball: ball,
            ballDropTime: null,
          ),
          childWhenDragging: (ballDropTime != null)
              ? Container(
                  height: 40,
                  width: 40,
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
    @required this.ball,
    @required this.ballDropTime,
  }) : super(key: key);

  final BallClass ball;
  final int ballDropTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: ball.color,
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
    );
  }
}
