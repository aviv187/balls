import 'package:flutter/material.dart';
import './route.dart' as BallRoute;

class Board extends StatelessWidget {
  final int entries;
  final int exits;

  Board({this.entries, this.exits});

  @override
  Widget build(BuildContext context) {
    const List routesPaths = [
      [Offset(100, 100), Offset(150, 200), Offset(50, 300)],
      [Offset(100, 100), Offset(150, 200), Offset(150, 300)],
      [Offset(100, 100), Offset(150, 200), Offset(250, 300)],
      [Offset(200, 100), Offset(150, 200), Offset(250, 300)],
    ];

    return Stack(
      children: routesPaths.map((path) {
        return BallRoute.Route(
          path: path,
        );
      }).toList(),
    );
    // final int crosses = (entries/2).ceil();

    // List<Widget> entriesWidgets = [];
    // for (var i = 0; i < entries; i++) {
    //   entriesWidgets.add(
    //     Container(
    //       height: 10,
    //       width: 10,
    //       color: Colors.black,
    //     )
    //   );
    // }

    // List<Widget> exitsWidgets = [];
    // for (var i = 0; i < exits; i++) {
    //   exitsWidgets.add(
    //     Container(
    //       height: 10,
    //       width: 10,
    //       color: Colors.black,
    //     )
    //   );
    // }

    // List<Widget> crossesWidgets1 = [];
    // for (var i = 0; i < crosses; i++) {
    //   if (i.isEven) {
    //     crossesWidgets1.add(
    //       Container(
    //         height: 10,
    //         width: 10,
    //         color: Colors.black,
    //       )
    //     );
    //   } else {
    //     crossesWidgets1.add(Container());
    //   }
    // }

    // List<Widget> crossesWidgets2 = [];
    // for (var i = 0; i < crosses; i++) {
    //   if (i.isOdd) {
    //     crossesWidgets2.add(
    //       Container(
    //         height: 10,
    //         width: 10,
    //         color: Colors.black,
    //       )
    //     );
    //   } else {
    //     crossesWidgets2.add(Container());
    //   }
    // }

    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: <Widget>[
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: entriesWidgets
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: crossesWidgets1
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: crossesWidgets2
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: exitsWidgets
    //     ),
    //   ],
    // );
  }
}
