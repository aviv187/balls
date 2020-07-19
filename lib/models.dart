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

class Score {
  String name;
  String score;

  Score({this.name, this.score});
}
