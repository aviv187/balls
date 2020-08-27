import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Online extends StatefulWidget {
  Online(
      {Key key,
      this.onOnline,
      this.onFoundPlayer,
      this.onLooking,
      this.onReady});

  final Function onOnline;
  final Function onLooking;
  final Function onFoundPlayer;
  final Function onReady;

  @override
  _OnlineState createState() => _OnlineState();
}

class _OnlineState extends State<Online> {
  bool online = false;
  bool looking = false;
  String gameId;
  int playerNumber;

  DatabaseReference userRef;
  DatabaseReference dbRef;
  DatabaseReference gameRef;
  var userListener;
  var gameListener;
  var gameStartListener;

  String uid;

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
      print('child was removed: ${event.snapshot.key}');
    });
    gameStartListener = gameRef.onChildAdded.listen((event) {
      widget.onReady();
    });
  }

  Future<void> _signIn() async {
    try {
      AuthResult response = await FirebaseAuth.instance.signInAnonymously();
      uid = response.user.uid;

      setState(() {
        online = true;
      });
      widget.onOnline();

      dbRef = FirebaseDatabase.instance.reference();
      _lookForPlayers(uid);
    } catch (e) {
      print(e);
    }
  }

  void _lookForPlayers(uid) {
    widget.onLooking();

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
            widget.onFoundPlayer();

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
    setState(() {
      gameId = _generateUniqueGameId(16);
    });

    _updateGame(gameId, playerNumber);
    dbRef.child('users/public/$player').update({'gameId': gameId});
    // TODO: if player wait more than X seconds in game node, delete and start over
    print('player: $player');
  }

  String _generateUniqueGameId(int length) {
    Random rand = new Random();
    return rand.nextInt(1000000).toString();
  }

  void _addPlayerToWaitingList(uid) {
    Timer handler = Timer(Duration(minutes: 1), () {
      setState(() {
        looking = false;
        online = false;
      });
      _makeUnavailable(uid);
    });

    playerNumber = 2;

    userRef = dbRef.child('users/public/$uid');
    userRef.update({'entered': DateTime.now().millisecondsSinceEpoch});
    userListener = userRef.onChildAdded.listen((Event event) {
      print('child added: ${event.snapshot.key}');
      if (event.snapshot.key == 'gameId') {
        setState(() => gameId = event.snapshot.value);
        _updateGame(gameId, playerNumber);

        widget.onReady();

        userListener.cancel();
        userRef.remove();
        print('I was changed. ${event.snapshot.key} = ${event.snapshot.value}');

        handler.cancel();
      }
    });
  }

  void _makeUnavailable(uid) {
    dbRef.child('users').child('public').child(uid).remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Balls'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Text('Game: $gameId'),
          Text(online ? 'Online' : 'Offline'),
          looking
              ? CircularProgressIndicator()
              : FlatButton(
                  onPressed: () {
                    _signIn();
                    setState(() {
                      looking = true;
                    });
                  },
                  child: Text('look for a game')),
        ],
      ),
    );
  }
}
