import 'package:flutter/material.dart';

import '../models.dart';

class DragBall extends StatefulWidget {
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
  _DragBallState createState() => _DragBallState();
}

class _DragBallState extends State<DragBall> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: widget.positionFromTop,
        left: widget.positionFromLeft,
        child: Draggable<BallClass>(
          maxSimultaneousDrags: widget.gameOver ? 0 : 2,
          data: BallClass(
            key: widget.ball.key,
            color: widget.ball.color,
            speed: widget.ball.speed,
          ),
          child: SimpleBall(
            color: widget.ball.color,
            ballDropTime: widget.ballDropTime,
          ),
          feedback: SimpleBall(
            color: widget.ball.color,
            ballDropTime: null,
          ),
          childWhenDragging: (widget.ballDropTime != null)
              ? Container(
                  height: 80,
                  width: 80,
                  child: Center(
                      child: Text(
                    '${widget.ballDropTime}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )))
              : Container(),
          onDragCompleted: () {
            widget.disposeOfTheBall();
          },
        ));
  }
}

class SimpleBall extends StatelessWidget {
  final Color color;
  final int ballDropTime;

  const SimpleBall({
    Key key,
    this.color,
    this.ballDropTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(seconds: 1),
        padding: EdgeInsets.all(25),
        color: Colors.white.withOpacity(0.01),
        child: Container(
          width: 30,
          height: 30,
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
