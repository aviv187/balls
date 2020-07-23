import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../boardCreatePath.dart';
import './board.dart';
import '../widgets/routeDraw.dart' as Route;
import '../changePageBuilder.dart';

class ChooseBoard extends StatelessWidget {
  static const routeName = '/choose';

  @override
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
          children: makeBoardFunctions.map((createBoardFunction) {
            List<List<Offset>> enterPaths = [];
            List<List<List<Offset>>> crossesPaths = [];
            createBoardFunction(
              height: (screenWidth - 30) / 2.2,
              witdh: (screenWidth - 30) / 2.6,
              enters: enterPaths,
              crosses: crossesPaths,
            );
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  width: 1,
                  color: Colors.blueGrey.withOpacity(0.7),
                ),
              ),
              child: FlatButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Route.RouteDraw(
                  crossesPaths: crossesPaths,
                  enterPaths: enterPaths,
                ),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  Navigator.push(
                    context,
                    FadeRoute(
                      page: Board(
                        height: screenWidth * 1.6,
                        width: screenWidth,
                        makeBoard: createBoardFunction,
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList()),
    );
  }
}
