import 'package:flutter/material.dart';

class BallClass {
  Color color;
  Key key;
  int speed;
  List<Offset> path;

  BallClass({
    this.color,
    this.path,
    this.key,
    this.speed,
  });
}
