import 'dart:ui';

import 'package:flutter/material.dart';

class Ball extends StatefulWidget {
  Ball({Key key, this.onRouteCompleted, this.color, this.path})
      : super(key: key);

  final Function onRouteCompleted;
  final Color color;
  final List<Offset> path;

  @override
  _RouteState createState() => _RouteState();
}

class _RouteState extends State<Ball> with TickerProviderStateMixin {
  Animation _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    int duration =
        getBallLength(getBallPath(widget.path[0], widget.path[1])).ceil() * 10;

    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: duration));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          widget.onRouteCompleted(widget.key, widget.path);
        }
      });

    _controller.forward();
  }

  @override
  void didUpdateWidget(Ball oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _controller.reset();
      _controller.forward();
    }
  }

  double getBallLength(Path path) {
    PathMetrics pathMetrics = path.computeMetrics();
    double length;
    for (PathMetric pathMetric in pathMetrics) {
      length = pathMetric.length;
    }
    return length;
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

Path getBallPath(Offset p1, Offset p2) {
  Path path = Path();
  path.moveTo(p1.dx, p1.dy);
  path.cubicTo(p1.dx, p2.dy, p2.dx, p1.dy, p2.dx, p2.dy);

  return path;
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

    drawAxis(value, canvas, paint, getBallPath(p1, p2));
  }

  drawAxis(double value, Canvas canvas, Paint paintBall, Path path1) {
    PathMetrics pathMetrics = path1.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
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