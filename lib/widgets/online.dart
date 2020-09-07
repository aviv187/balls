import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../helpFunction/boardCreatePath.dart';

class Online extends StatefulWidget {
  Online({Key key, this.onReady, this.screenSize, this.gameOver, this.isLoser});

  final Function onReady;
  final Function isLoser;
  final Size screenSize;
  final bool gameOver;

  @override
  _OnlineState createState() => _OnlineState();
}

class _OnlineState extends State<Online> {
  int gameId;
  int playerNumber;

  DatabaseReference userRef;
  DatabaseReference dbRef;
  DatabaseReference gameRef;
  var userListener;
  var gameListener;
  var gameStartListener;

  String uid;

  @override
  void initState() {
    super.initState();
    _signIn();
  }

  @override
  void didUpdateWidget(Online oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gameOver != true) {
      if (widget.gameOver == true) {
        _endGame();
      }
    }
  }

  @override
  void dispose() {
    userListener?.cancel();
    gameListener?.cancel();
    gameStartListener?.cancel();
    _makeUnavailable(uid);
    _endGame();
    super.dispose();
  }

  void _endGame() {
    if (gameRef != null) {
      gameRef.update({'player$playerNumber': null});
    }
  }

  void _updateGame(gameId, playerNumber) {
    gameRef = dbRef.child('games/$gameId');
    gameRef.update({'player$playerNumber': uid});
    gameListener = gameRef.onChildRemoved.listen((Event event) {
      if (event.snapshot.key == 'player$playerNumber') {
        widget.isLoser(true);
        // print('loser');
        gameListener?.cancel();
      } else {
        widget.isLoser(false);
        // print('winner');
        gameListener?.cancel();
      }
    });
    gameStartListener = gameRef.onChildAdded.listen((event) {
      int boardNum = gameId.toInt() % makeBoardFunctions.length;

      widget.onReady(boardNum);
    });
  }

  Future<void> _signIn() async {
    try {
      AuthResult response = await FirebaseAuth.instance.signInAnonymously();
      uid = response.user.uid;

      dbRef = FirebaseDatabase.instance.reference();
      _lookForPlayers(uid);
    } catch (e) {
      print(e);
    }
  }

  void _lookForPlayers(uid) {
    dbRef
        .child('users/public')
        .orderByChild('entered')
        .once()
        .then((DataSnapshot snapshot) {
      String player;

      if (snapshot.value != null) {
        snapshot.value.forEach((key, value) {
          int waitTimeMiliSec =
              DateTime.now().millisecondsSinceEpoch - value['entered'];
          if (key == uid || waitTimeMiliSec > 60000) {
            _makeUnavailable(key);
          } else {
            if (player == null) {
              player = key;
            }
          }
        });
      }

      if (player == null) {
        _addPlayerToWaitingList(uid);
      } else {
        playerNumber = 1;
        _createGame(player, playerNumber);
      }
    });
  }

  void _createGame(player, playerNumber) {
    gameId = _generateUniqueGameId(16);

    _updateGame(gameId, playerNumber);
    dbRef.child('users/public/$player').update({'gameId': gameId});
    print('player: $player');
  }

  int _generateUniqueGameId(int length) {
    Random rand = new Random();
    return rand.nextInt(1000000);
  }

  void _addPlayerToWaitingList(uid) {
    playerNumber = 2;

    userRef = dbRef.child('users/public/$uid');
    userRef.update({'entered': DateTime.now().millisecondsSinceEpoch});

    Timer pophandler;
    Timer makeUnavailablehandler = Timer(Duration(minutes: 1), () {
      _makeUnavailable(uid);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('sorry, we could not find another player'),
        ),
      );
      pophandler = Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    });

    userListener = userRef.onChildAdded.listen((Event event) {
      print('child added: ${event.snapshot.key}');
      if (event.snapshot.key == 'gameId') {
        gameId = event.snapshot.value;
        _updateGame(gameId, playerNumber);

        userListener.cancel();
        userRef.remove();
        print('I was changed. ${event.snapshot.key} = ${event.snapshot.value}');

        makeUnavailablehandler.cancel();
        if (pophandler != null) {
          pophandler.cancel();
        }
      }
    });
  }

  void _makeUnavailable(uid) {
    dbRef.child('users').child('public').child(uid).remove();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.wifi_tethering),
      onPressed: null,
      disabledColor: Colors.white,
    );
  }
}
