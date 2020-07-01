import 'package:flutter/material.dart';

class BallClass {
  final key = UniqueKey(); // לא בטוחה שבאמת צריך את זה
  final Color color;
  List<Offset> ballCurrentPath;

  BallClass({this.color, this.ballCurrentPath});
}
