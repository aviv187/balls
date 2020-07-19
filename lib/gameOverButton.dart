import 'package:flutter/material.dart';

import './scorePage.dart';
import './models.dart';

class GameOverButton extends StatefulWidget {
  final bool gameOver;
  final Function restartGame;
  final String gameEndTime;

  GameOverButton({
    this.gameOver,
    this.restartGame,
    this.gameEndTime,
  });

  @override
  _GameOverButtonState createState() => _GameOverButtonState();
}

class _GameOverButtonState extends State<GameOverButton> {
  TextEditingController _textEditingController = TextEditingController();
  bool canSave = true;

  @override
  Widget build(BuildContext context) {
    double opacity = 1;
    if (!widget.gameOver) {
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
                if (widget.gameOver) {
                  widget.restartGame();

                  canSave = false;
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              widget.gameEndTime,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 180,
              child: TextFormField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  labelText: 'Enter your Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      const Radius.circular(12.0),
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
            ),
            FlatButton(
              child: Text('Save Score'),
              onPressed: canSave
                  ? () {
                      setState(() {
                        canSave = false;
                      });

                      if (_textEditingController.text == '') {
                        addScore(Score(
                          name: 'Player',
                          score: widget.gameEndTime,
                        ));
                      } else {
                        addScore(Score(
                          name: _textEditingController.text,
                          score: widget.gameEndTime,
                        ));
                      }
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
