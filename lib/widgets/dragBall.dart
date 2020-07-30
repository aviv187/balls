import 'package:flutter/material.dart';

import '../models/ballModel.dart';
import '../feedbackController.dart';

class DragBall extends StatefulWidget {
  final BallClass ball;
  final Function disposeOfTheBall;
  final int ballDropTime;
  final double positionFromTop;
  final double positionFromLeft;
  final bool gameOver;
  final MyDraggableController<BallClass> controller;

  DragBall({
    this.ball,
    this.disposeOfTheBall,
    this.ballDropTime,
    this.positionFromTop,
    this.positionFromLeft,
    this.gameOver,
    this.controller,
  });

  @override
  _DragBallState createState() => _DragBallState();
}

class _DragBallState extends State<DragBall> {
  bool isOnTarget;
  FeedbackController feedbackController;
  @override
  void initState() {
    feedbackController = new FeedbackController();

    widget.controller.subscribeToOnTargetCallback(onTargetCallbackHandler);

    super.initState();
  }

  void onTargetCallbackHandler(bool t, BallClass ball) {
    isOnTarget = t && widget.ball == ball;
    feedbackController.updateFeedback(isOnTarget);
  }

  @override
  void dispose() {
    widget.controller.unSubscribeFromOnTargetCallback(onTargetCallbackHandler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: widget.positionFromTop,
        left: widget.positionFromLeft,
        child: Draggable<BallClass>(
          maxSimultaneousDrags: widget.gameOver ? 0 : 2,
          data: widget.ball,
          child: SimpleBall(
            color: widget.ball.color,
            ballDropTime: widget.ballDropTime,
          ),
          feedback: FeedbackBall(
            color: widget.ball.color,
            controller: feedbackController,
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
          onDraggableCanceled: (v, f) => setState(
            () {
              isOnTarget = false;
              feedbackController.updateFeedback(isOnTarget);
            },
          ),
        ));
  }
}

class FeedbackBall extends StatefulWidget {
  final Color color;
  final FeedbackController controller;

  const FeedbackBall({
    Key key,
    this.color,
    this.controller,
  }) : super(key: key);

  @override
  _FeedbackBallState createState() => _FeedbackBallState();
}

class _FeedbackBallState extends State<FeedbackBall> {
  bool isOnTarget;

  @override
  void initState() {
    isOnTarget = false;
    widget.controller.feedbackNeedsUpdateCallback =
        feedbackNeedsUpdateCallbackHandler;
    super.initState();
  }

  void feedbackNeedsUpdateCallbackHandler(bool t) {
    setState(() {
      isOnTarget = t;
    });
  }

  @override
  void dispose() {
    widget.controller.feedbackNeedsUpdateCallback = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(25),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isOnTarget ?? false ? Colors.transparent : widget.color,
            shape: BoxShape.circle,
          ),
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
    return Container(
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
