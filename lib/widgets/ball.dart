import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Ball extends StatefulWidget {
  Ball({
    Key key,
    this.onRouteCompleted,
    this.color,
    this.path,
    this.speed,
    this.gameOver,
    this.screenSize,
  }) : super(key: key);

  final Function onRouteCompleted;
  final Color color;
  final List<Offset> path;
  final int speed;
  final bool gameOver;
  final Size screenSize;

  @override
  _RouteState createState() => _RouteState();
}

class _RouteState extends State<Ball> with TickerProviderStateMixin {
  Animation _animation;
  AnimationController _controller;

  int _duration;

  @override
  void initState() {
    super.initState();

    getBallDuration();

    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: _duration));
    _animation = Tween<double>(begin: 0.0001, end: 0.9999).animate(_controller)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          widget.onRouteCompleted(widget.key, widget.path);
        }
      });

    _controller.forward();

    if (widget.gameOver == true) {
      _controller.stop();
    }
  }

  @override
  void didUpdateWidget(Ball oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      getBallDuration();
      _controller.duration = Duration(milliseconds: _duration);

      _controller.reset();
      _controller.forward();
    }

    if (widget.gameOver == true) {
      _controller.stop();
    }
  }

  void getBallDuration() {
    double xLength =
        (widget.path[0].dx - widget.path[1].dx).abs() / widget.screenSize.width;
    double yLength = (widget.path[0].dy - widget.path[1].dy).abs() /
        widget.screenSize.height;

    double lineLength = sqrt(xLength * xLength + yLength * yLength);

    _duration = (lineLength * widget.speed).ceil();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, snapshot) {
          return CustomPaint(
            child: Container(),
            painter: BallPainter(
              _animation.value,
              widget.path[0],
              widget.path[1],
              widget.color,
            ),
          );
        });
  }
}

class BallPainter extends CustomPainter {
  final double value;
  final Offset p1;
  final Offset p2;
  final Color color;

  BallPainter(this.value, this.p1, this.p2, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;

    Path path = Path();
    path.moveTo(p1.dx, p1.dy);
    path.cubicTo(p1.dx, p2.dy, p2.dx, p1.dy, p2.dx, p2.dy);

    drawAxis(canvas, paint, path);
  }

  drawAxis(Canvas canvas, Paint paintBall, Path path1) {
    PathMetrics pathMetrics = path1.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * value,
      );

      final PathMetric metric = extractPath.computeMetrics().first;
      Offset offset = metric.getTangentForOffset(metric.length).position;

      canvas.drawCircle(offset, 15, paintBall);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
