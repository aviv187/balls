import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './chooseBoard.dart';
import './board.dart';
import '../helpFunction/changePageBuilder.dart';
import './enterCodePage.dart';

class GoinCreatePage extends StatelessWidget {
  final Size screenSize;

  GoinCreatePage({
    @required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
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
          children: <Widget>[
            TileWidget(
                'Create Game',
                ChooseBoard(
                  screenSize: screenSize,
                  online: true,
                  playWithFriends: true,
                )),
            TileWidget(
              'Goin Game',
              EnterCodePage(screenSize),
            ),
            TileWidget(
              'Random Game',
              Board(
                screenSize: screenSize,
                online: true,
              ),
            ),
          ],
        ));
  }
}

class TileWidget extends StatelessWidget {
  final String text;
  final Widget screen;

  TileWidget(this.text, this.screen);

  @override
  Widget build(BuildContext context) {
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
          child: Text(text),
          onPressed: () {
            HapticFeedback.heavyImpact();
            Navigator.push(
              context,
              FadeRoute(
                page: screen,
              ),
            );
          },
        ));
  }
}
