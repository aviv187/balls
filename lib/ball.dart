import 'dart:ui';

import 'package:flutter/material.dart';

class Ball extends StatefulWidget {
  Ball({
    Key key,
    this.onRouteCompleted,
    this.color,
    this.path,
    this.speed,
  }) : super(key: key);

  final Function onRouteCompleted;
  final Color color;
  final List<Offset> path;
  final int speed;

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

    _duration = (getBallLength(getBallPath(widget.path[0], widget.path[1])) *
            widget.speed)
        .ceil();

    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: _duration));
    _animation = Tween<double>(begin: 0.0001, end: 0.9999).animate(_controller)
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
      _duration = (getBallLength(getBallPath(widget.path[0], widget.path[1])) *
              widget.speed)
          .ceil();
      _controller.duration = Duration(milliseconds: _duration);

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

    drawAxis(canvas, paint, getBallPath(p1, p2));
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

      canvas.drawCircle(offset, 8, paintBall);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
