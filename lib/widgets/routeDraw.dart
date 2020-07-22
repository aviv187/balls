import 'package:flutter/material.dart';

class RouteDraw extends StatelessWidget {
  final int index;
  final List<Offset> path;

  RouteDraw({this.path, this.index});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(),
      painter: RoutePainter(path[0], path[1], 0.6 - 0.2 * index),
    );
  }
}

class RoutePainter extends CustomPainter {
  final Offset p1;
  final Offset p2;
  double opacity;

  RoutePainter(this.p1, this.p2, this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity < 0.1) {
      opacity = 0.1;
    }

    Paint paint = Paint()
      ..color = Colors.blueGrey.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    Path path = Path();
    path.moveTo(p1.dx, p1.dy);
    path.cubicTo(p1.dx, p2.dy, p2.dx, p1.dy, p2.dx, p2.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
