import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpFunction/changePageBuilder.dart';
import './board.dart';

class EnterCodePage extends StatelessWidget {
  final Size screenSize;

  EnterCodePage(this.screenSize);

  @override
  Widget build(BuildContext context) {
    TextEditingController _textEditingController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: Text('Balls'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Builder(
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                'Enter Code',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              )),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 180,
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    labelText: 'Friend\'s Code',
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
              SizedBox(
                height: 20,
              ),
              FlatButton(
                  child: Text('Look for Friend'),
                  onPressed: () {
                    if (_textEditingController.text != '') {
                      HapticFeedback.heavyImpact();
                      Navigator.push(
                        context,
                        FadeRoute(
                          page: Board(
                            screenSize: screenSize,
                            online: true,
                            playWithFriends: true,
                            codeFromPlayer: _textEditingController.text,
                          ),
                        ),
                      );
                      _textEditingController.text = '';
                    } else {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You need to enter a code'),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ));
  }
}
