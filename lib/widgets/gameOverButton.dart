import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../helpFunction/database.dart';

class GameOverButton extends StatefulWidget {
  final bool gameOver;
  final Function restartGame;
  final String gameEndTime;
  final bool online;
  final bool loser;

  GameOverButton({
    this.gameOver,
    this.restartGame,
    this.gameEndTime,
    this.online,
    this.loser,
  });

  @override
  _GameOverButtonState createState() => _GameOverButtonState();
}

class _GameOverButtonState extends State<GameOverButton> {
  TextEditingController _textEditingController = TextEditingController();
  bool canSave = true;
  DatabaseReference scoreRef;

  void saveScoreOnline(String name, String time) {
    try {
      scoreRef = FirebaseDatabase.instance.reference().child('scores');
      scoreRef.once().then((DataSnapshot snapshot) {
        List<dynamic> scoresList = snapshot.value;

        String nameHolder = name;
        String timeHolder = time;

        for (int i = 0; i < 10; i++) {
          try {
            String oldPlayerTime = scoresList[i]['score'];
            int isTheNewTimeBetter = timeHolder.compareTo(oldPlayerTime);

            if (isTheNewTimeBetter == 1) {
              scoreRef.child(i.toString()).update({
                'score': timeHolder,
                'name': nameHolder,
              });
              timeHolder = oldPlayerTime;
              nameHolder = scoresList[i]['name'];
            }
          } catch (e) {
            scoreRef.child(i.toString()).update({
              'score': timeHolder,
              'name': nameHolder,
            });
            return;
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _insert(String name, String time) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnScore: time,
    };

    await DatabaseHelper.instance.insert(row);
  }

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
            SizedBox(height: 80),
            Text(
              !widget.online
                  ? 'Game Over'
                  : (widget.loser == null)
                      ? 'some animation'
                      : (widget.loser ? 'Loser' : 'Winner'),
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
                widget.online ? Navigator.pop(context) : widget.restartGame();

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
                        saveScoreOnline('player', widget.gameEndTime);
                      } else {
                        _insert(
                            _textEditingController.text, widget.gameEndTime);
                        saveScoreOnline(
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
