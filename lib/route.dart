import 'package:flutter/material.dart';

class Route extends StatelessWidget {
  Route({Key key, this.path});

  final List path;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(),
      painter: LinePainter(path[0], path[1]),
    );
  }
}

class LinePainter extends CustomPainter {
  final Offset p1;
  final Offset p2;

  LinePainter(this.p1, this.p2);

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
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
