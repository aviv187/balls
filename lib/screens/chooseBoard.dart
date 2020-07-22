import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../boardCreatePath.dart';
import 'board.dart';

class ChooseBoard extends StatelessWidget {
  static const routeName = '/choose';

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Balls'),
        centerTitle: true,
        elevation: 0,
      ),
      body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: makeBoardFunctions
              .map(
                (createBoardFunction) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      width: 1,
                      color: Colors.blueGrey,
                    ),
                  ),
                  child: FlatButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Text('board'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Board(
                            height: screenWidth * 1.6,
                            width: screenWidth,
                            makeBoard: createBoardFunction,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
              .toList()),
    );
  }
}
