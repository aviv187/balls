import 'package:flutter/material.dart';

import '../database.dart';

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

    void _insert(String name, String time) async {
      Map<String, dynamic> row = {
        DatabaseHelper.columnName: name,
        DatabaseHelper.columnScore: time,
      };

      await DatabaseHelper.instance.insert(row);
    }

    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: opacity,
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 80),
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
                widget.restartGame();

                canSave = false;
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
                  ? () async {
                      if (_textEditingController.text == '') {
                        _insert('player', widget.gameEndTime);
                      } else {
                        _insert(
                            _textEditingController.text, widget.gameEndTime);
                      }

                      setState(() {
                        canSave = false;
                      });
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
