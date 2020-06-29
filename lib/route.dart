import 'dart:ui' as UI;

import 'package:flutter/material.dart';

class Route extends StatefulWidget {
  Route({Key key, this.path});

  final List path;

  @override
  _RouteState createState() => _RouteState();
}

class _RouteState extends State<Route> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, snapshot) {
          return CustomPaint(
            child: Container(),
            painter:
                LinePainter(_controller.value, widget.path[0], widget.path[1]),
          );
        });
  }
}

class LinePainter extends CustomPainter {
  final double value;
  final Offset p1;
  final Offset p2;

  LinePainter(this.value, this.p1, this.p2);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    Path path = Path();
    path.moveTo(p1.dx, p1.dy);
    // path.cubicTo(p2.dx, p1.dy, p1.dx, p2.dy, p2.dx, p2.dy);
    path.cubicTo(p1.dx, p2.dy, p2.dx, p1.dy, p2.dx, p2.dy);

    canvas.drawPath(path, paint);
    print(value);
    drawAxis(value, canvas, Paint()..color = Colors.amber, path);
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
