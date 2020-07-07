import 'package:flutter/material.dart';

class RouteDraw extends StatelessWidget {
  RouteDraw({this.path});

  final List<Offset> path;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(),
      painter: RoutePainter(path[0], path[1]),
    );
  }
}

class RoutePainter extends CustomPainter {
  final Offset p1;
  final Offset p2;

  RoutePainter(this.p1, this.p2);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

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
