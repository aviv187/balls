import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './chooseBoard.dart';
import './online.dart';
import '../helpFunction/changePageBuilder.dart';

class ChooseGame extends StatelessWidget {
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
            TileWidget('ChooseBoard', ChooseBoard()),
            TileWidget(
                'Online',
                Online(
                  onOnline: () => print('onOnline'),
                  onFoundPlayer: () => print('onFoundPlayer'),
                  onLooking: () => print('onLooking'),
                  onReady: () => print('onReady'),
                )),
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
