import 'package:flutter/material.dart';

import './models.dart';

class DragBall extends StatefulWidget {
  final BallClass ball;
  final Function disposeOfTheBall;
  final int ballDropTime;
  final double positionFromTop;
  final double positionFromLeft;

  DragBall(
      {this.ball,
      this.disposeOfTheBall,
      this.ballDropTime,
      this.positionFromTop,
      this.positionFromLeft});

  @override
  _DragBallState createState() => _DragBallState();
}

class _DragBallState extends State<DragBall> {
  @override
  Widget build(BuildContext context) {
    double top = widget.positionFromTop;
    double left = widget.positionFromLeft;
    return AnimatedPositioned(
      duration: Duration(seconds: 1),
      top: top,
      left: left,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: widget.ball.color,
            shape: BoxShape.circle,
          ),
          child: (widget.ballDropTime == null)
              ? Container()
              : Center(child: Text('${widget.ballDropTime}')),
        ),
        onPanUpdate: (data) {
          setState(() {
            top = top + data.localPosition.dy;
            left = left + data.localPosition.dx;
          });
        },
        onTapUp: (data) {
          widget.disposeOfTheBall();
        },
      ),
    );
  }
}
