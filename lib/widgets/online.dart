import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../helpFunction/boardCreatePath.dart';

class Online extends StatefulWidget {
  Online({
    Key key,
    this.onReady,
    this.screenSize,
    this.gameOver,
    this.isLoser,
    this.playerTime,
    this.playWithFriends = false,
    this.boardNumber,
    this.gameCode,
  });

  final Function onReady;
  final Function isLoser;
  final Size screenSize;
  final bool gameOver;
  final bool playWithFriends;
  final String playerTime;
  final String gameCode;
  final int boardNumber;

  @override
  _OnlineState createState() => _OnlineState();
}

class _OnlineState extends State<Online> {
  int gameId;
  int playerNumber;
  int otherPlayerNumber;
  int boardNum;

  DatabaseReference userRef;
  DatabaseReference dbRef;
  DatabaseReference gameRef;
  var userListener;
  var gameListener;

  String uid;

  Timer makeUnavailablehandler;
  Timer checkWinTimer;
  Timer waitForResponTimer;

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
    _makeUnavailable(uid);
    _endGame();
    _checkOtherGameOver();
    makeUnavailablehandler?.cancel();
    checkWinTimer?.cancel();
    waitForResponTimer?.cancel();
    super.dispose();
  }

  Future<void> _signIn() async {
    try {
      AuthResult response = await FirebaseAuth.instance.signInAnonymously();
      uid = response.user.uid;

      dbRef = FirebaseDatabase.instance.reference();
      if (widget.playWithFriends) {
        if (widget.boardNumber == null) {
          _lookForFriend(uid);
        } else {
          boardNum = widget.boardNumber;
          _addPlayerToWaitingList(uid);
        }
      } else {
        _lookForPlayers(uid);
      }
    } catch (e) {
      print(e);
    }
  }

  void _lookForFriend(uid) {
    dbRef
        .child('users/custom')
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
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('sorry, we could not find your friend'),
          ),
        );
        Timer(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        playerNumber = 1;
        otherPlayerNumber = 2;
        _createGame(player, playerNumber);
      }
    });
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
        otherPlayerNumber = 2;
        _createGame(player, playerNumber);
      }
    });
  }

  void checkBestTime(String otherPlayerTime) {
    if (otherPlayerTime.compareTo(widget.playerTime) == -1) {
      widget.isLoser(false);
      gameListener?.cancel();
    } else {
      widget.isLoser(true);
      gameListener?.cancel();
    }
  }

  void _endGame() {
    if (gameRef != null) {
      //check other player has allready finished, and if you won
      gameRef
          .child('player${otherPlayerNumber}Time')
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          checkBestTime(snapshot.value);
        }
      });

      // update my status on firebase
      gameRef.update({'player${playerNumber}Time': widget.playerTime});
      gameRef.update({'player$playerNumber': null});

      //if player doesnt respond you are the winner
      waitForResponTimer = Timer(Duration(seconds: 10), () {
        widget.isLoser(false);
        gameListener?.cancel();
      });

      // delete game from firebase
      gameRef
          .child('player$otherPlayerNumber')
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value == null) {
          gameRef?.remove();
        }
      });
    }
  }

  //dalete games from firebase that might stay there by mistake
  void _checkOtherGameOver() {
    dbRef.child('games').once().then((DataSnapshot snapshot) {
      int timeNow = DateTime.now().millisecondsSinceEpoch;

      if (snapshot.value != null) {
        snapshot.value.forEach((key, value) {
          if (value['entered'] < timeNow - 1800000) {
            dbRef.child('games/$key').remove();
          }
        });
      }
    });
  }

  void _updateGame(gameId, playerNumber) {
    gameRef = dbRef.child('games/$gameId');
    gameRef.update({'player$playerNumber': uid});
    gameRef.update({'entered': DateTime.now().millisecondsSinceEpoch});

    gameListener = gameRef.onChildAdded.listen((event) {
      //start the game
      if (event.snapshot.key == 'player$playerNumber') {
        if (boardNum == null) {
          boardNum = gameId.toInt() % makeBoardFunctions.length;
        }

        widget.onReady(boardNum);
      }

      //give your time to the other player if he lost
      if (event.snapshot.key == 'player${otherPlayerNumber}Time' &&
          !widget.gameOver) {
        checkWinTimer = Timer(Duration(seconds: 5), () {
          gameRef.update({'player${playerNumber}Time': widget.playerTime});
        });
      } else if (event.snapshot.key == 'player${otherPlayerNumber}Time' &&
          widget.gameOver) {
        waitForResponTimer?.cancel();
        checkBestTime(event.snapshot.value);
      }
    });
  }

  void _createGame(player, playerNumber) {
    Random rand = new Random();
    gameId = rand.nextInt(1000000);

    _updateGame(gameId, playerNumber);
    dbRef
        .child(widget.playWithFriends
            ? 'users/custom/$player'
            : 'users/public/$player')
        .update({'gameId': gameId});
  }

  void _addPlayerToWaitingList(uid) {
    playerNumber = 2;
    otherPlayerNumber = 1;

    userRef = dbRef.child(
        widget.playWithFriends ? 'users/custom/$uid' : 'users/public/$uid');
    userRef.update({'entered': DateTime.now().millisecondsSinceEpoch});
    if (widget.playWithFriends) {
      userRef.update({'BoardNum': widget.boardNumber});
    }

    Timer pophandler;
    makeUnavailablehandler = Timer(Duration(minutes: 1), () {
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
      if (event.snapshot.key == 'gameId') {
        gameId = event.snapshot.value;
        _updateGame(gameId, playerNumber);

        userListener.cancel();
        userRef.remove();

        makeUnavailablehandler.cancel();
        if (pophandler != null) {
          pophandler.cancel();
        }
      }
    });
  }

  void _makeUnavailable(uid) {
    dbRef
        .child('users')
        .child(widget.playWithFriends ? 'custom' : 'public')
        .child(uid)
        .remove();
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
