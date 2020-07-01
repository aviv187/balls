import 'dart:ui' as UI;

import 'package:flutter/material.dart';

import './models.dart';

class BallDraw extends StatefulWidget {
  BallDraw({this.ball, this.changeBallpath});

  final Function changeBallpath;
  final BallClass ball;

  @override
  _RouteState createState() => _RouteState();
}

class _RouteState extends State<BallDraw> with TickerProviderStateMixin {
  Animation _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          widget.changeBallpath(widget.ball);
        }
      });

    _controller.forward();
  }

  @override
  void didUpdateWidget(BallDraw oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.reset();
    _controller.forward();
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
                widget.ball.ballCurrentPath[0],
                widget.ball.ballCurrentPath[1],
                widget.ball.color),
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
    // path.cubicTo(p2.dx, p1.dy, p1.dx, p2.dy, p2.dx, p2.dy);
    path.cubicTo(p1.dx, p2.dy, p2.dx, p1.dy, p2.dx, p2.dy);

    drawAxis(value, canvas, paint, path);
  }

  drawAxis(double value, Canvas canvas, Paint paintBall, Path path1) {
    UI.PathMetrics pathMetrics = path1.computeMetrics();
    for (UI.PathMetric pathMetric in pathMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * value,
      );
      try {
        var metric = extractPath.computeMetrics().first;
        final offset = metric.getTangentForOffset(metric.length).position;
        canvas.drawCircle(offset, 8.0, paintBall);
      } catch (e) {}
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
