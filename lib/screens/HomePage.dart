import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './chooseBoard.dart';
import './scorePage.dart';
import '../helpFunction/changePageBuilder.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Balls'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 100),
            FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                height: 80,
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Center(
                    child: Text(
                  'Start Game',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                )),
              ),
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.push(
                  context,
                  FadeRoute(
                    page: ChooseBoard(),
                  ),
                );
              },
            ),
            SizedBox(height: 30),
            FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                height: 80,
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.amber[400],
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Center(
                    child: Text(
                  'Score Board',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                )),
              ),
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.push(
                  context,
                  FadeRoute(
                    page: ScorePage(),
                  ),
                );
              },
            ),
            SizedBox(height: 30),
            FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                height: 80,
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.deepOrange[400],
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Center(
                    child: Text(
                  'Options',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                )),
              ),
              onPressed: () {
                HapticFeedback.heavyImpact();
              },
            ),
          ],
        ),
      ),
    );
  }
}
