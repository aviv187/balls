import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Route extends StatelessWidget {
  Route({Key key, this.path});

  final List path;

  @override
  Widget build(BuildContext context) {
    var entry = path[0];
    var exit = path[path.length - 1];

    var entryWidget = Positioned(
      top: entry.dy,
      left: entry.dx,
      child: Container(width: 10, height: 10, color: Colors.red),
    );

    var exitWidget = Positioned(
      top: exit.dy,
      left: exit.dx,
      child: Container(width: 10, height: 10, color: Colors.blue),
    );

    return Positioned(
        top: 0,
        left: 0,
        bottom: 0,
        right: 0,
        child: Stack(children: [entryWidget, exitWidget]));
  }
}
