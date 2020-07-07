import 'package:flutter/material.dart';

class BallClass {
  final Color color;
  final Key key;
  final int speed;
  List<Offset> path;

  BallClass({this.color, this.path, this.key, this.speed});
}

class NextBall {
  Color color;
  int speed;

  NextBall({this.color, this.speed});
}
