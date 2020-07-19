import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './main.dart';

class HomePage extends StatelessWidget {
  final double screenWidth;
  final Function changeScreen;

  HomePage({
    this.screenWidth,
    this.changeScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              height: screenWidth / 5,
              width: screenWidth / 1.5,
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
              changeScreen(Screen.game);
            },
          ),
          SizedBox(height: 30),
          FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              height: screenWidth / 5,
              width: screenWidth / 1.5,
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
              changeScreen(Screen.scoreBoard);
            },
          ),
          SizedBox(height: 30),
          FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              height: screenWidth / 5,
              width: screenWidth / 1.5,
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
              changeScreen(Screen.options);
            },
          ),
          SizedBox(height: 170),
        ],
      ),
    );
  }
}
