import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpFunction/boardCreatePath.dart';
import './board.dart';
import '../widgets/routeDraw.dart' as Route;
import '../helpFunction/changePageBuilder.dart';

class ChooseBoard extends StatelessWidget {
  final Size screenSize;
  final bool playWithFriends;
  final bool online;

  ChooseBoard({
    this.screenSize,
    this.playWithFriends = false,
    this.online = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Boards'),
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
                  child: LayoutBuilder(builder: (ctx, constraints) {
                    List<List<Offset>> enterPaths2 = [];
                    List<List<List<Offset>>> crossesPaths2 = [];
                    createBoardFunction(
                      height: constraints.maxHeight,
                      witdh: constraints.maxWidth,
                      enters: enterPaths2,
                      crosses: crossesPaths2,
                    );
                    return Hero(
                      tag: createBoardFunction.hashCode,
                      child: Route.RouteDraw(
                        crossesPaths: crossesPaths2,
                        enterPaths: enterPaths2,
                      ),
                    );
                  }),
                  onPressed: () {
                    HapticFeedback.heavyImpact();

                    Navigator.push(
                      context,
                      FadeRoute(
                        page: Board(
                          boardNum:
                              makeBoardFunctions.indexOf(createBoardFunction),
                          heroTag: createBoardFunction.hashCode,
                          screenSize: screenSize,
                          online: online,
                          playWithFriends: playWithFriends,
                        ),
                      ),
                    );
                  },
                ));
          }).toList()),
    );
  }
}
