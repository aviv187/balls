import 'package:flutter/material.dart';

class GameOverButton extends StatelessWidget {
  final bool gameOver;
  final Function restartGame;
  final String gameEndTime;

  GameOverButton({
    this.gameOver,
    this.restartGame,
    this.gameEndTime,
  });

  @override
  Widget build(BuildContext context) {
    double opacity = 1;
    if (!gameOver) {
      opacity = 0;
    }

    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: opacity,
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              'Game Over',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade600,
              ),
            ),
            SizedBox(height: 20),
            FlatButton(
              padding: EdgeInsets.all(0),
              highlightColor: Colors.blueGrey,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.blueGrey.withOpacity(0.75),
                ),
                child: Text(
                  'Play Again',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () async {
                if (gameOver) {
                  restartGame();
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              gameEndTime,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
