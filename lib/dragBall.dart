import 'package:flutter/material.dart';

import './models.dart';

class DragBall extends StatelessWidget {
  final BallClass ball;
  final Function disposeOfTheBall;
  final int ballDropTime;

  DragBall(this.ball, this.disposeOfTheBall, this.ballDropTime);
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
        child: (ballDropTime == null)
            ? Container()
            : Center(child: Text('$ballDropTime')),
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
