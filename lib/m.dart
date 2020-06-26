import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ball Game',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          CustomPaint(
            child: Container(),
            painter: LinePainter(screenWidth),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Draggable(
              feedback: Ball(),
              child: Ball(),
              childWhenDragging: Container(),
              data: 1,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: screenWidth*0.2-10,
              top: screenWidth*0.2-10
            ),
            child: BallTarget()
          ),
          Container(
            margin: EdgeInsets.only(
              left: screenWidth*0.4-10,
              top: screenWidth*0.2-10
            ),
            child: BallTarget()
          ),
          Container(
            margin: EdgeInsets.only(
              left: screenWidth*0.6-10,
              top: screenWidth*0.2-10
            ),
            child: BallTarget()
          ),Container(
            margin: EdgeInsets.only(
              left: screenWidth*0.8-10,
              top: screenWidth*0.2-10
            ),
            child: BallTarget()
          ),
        ],
      ),
    );
  }
}

class Ball extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle
      ),
    );
  }
}

class BallTarget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (context, List<int> candidateData, rejectedData) {
        return Container(
          height: 20,
          width: 20,
        );
      },
      onWillAccept: (data) {
        print('hover');
        return true;
      },
      onAccept: (data) {
        print('drop');
        return true;
      },
    );
  }
}

class LinePainter extends CustomPainter {
  double screenWidth;

  LinePainter(this.screenWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final enter1 = Offset(screenWidth*0.2, screenWidth*0.2);
    final enter2 = Offset(screenWidth*0.4, screenWidth*0.2);
    final enter3 = Offset(screenWidth*0.6, screenWidth*0.2);
    final enter4 = Offset(screenWidth*0.8, screenWidth*0.2);
    final cross1 = Offset(screenWidth*0.3, screenWidth*0.7);
    final cross2 = Offset(screenWidth*0.5, screenWidth*0.5);
    final exit1 = Offset(screenWidth*0.25, screenWidth*1.2);
    final exit2 = Offset(screenWidth*0.5, screenWidth*1.2);
    final exit3 = Offset(screenWidth*0.75, screenWidth*1.2);

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(enter1, cross1, paint);
    canvas.drawLine(enter2, cross1, paint);
    canvas.drawLine(enter3, cross2, paint);
    canvas.drawLine(enter4, exit3, paint);
    canvas.drawLine(cross1, exit1, paint);
    canvas.drawLine(cross1, exit2, paint);
    canvas.drawLine(cross2, cross1, paint);
    canvas.drawLine(cross2, exit2, paint);
    canvas.drawLine(cross2, exit3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
