import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Online extends StatefulWidget {
  @override
  _OnlineState createState() => _OnlineState();
}

class _OnlineState extends State<Online> {
  bool online = false;
  bool looking = true;
  int gameId;

  DatabaseReference dbRef;

  String uid;

  @override
  void initState() {
    super.initState();
    _signIn();
  }

  Future<void> _signIn() async {
    try {
      var response = await FirebaseAuth.instance.signInAnonymously();
      uid = response.user.uid;
      setState(() {
        online = true;
      });
      dbRef = FirebaseDatabase.instance.reference();
      _makeAvailable();
    } catch (e) {
      print(e);
    }
  }

  void _lookForPlayers(callback) {
    dbRef
        .child('users')
        .child('public')
        .orderByChild('entered')
        .once()
        .then((DataSnapshot snapshot) {
      callback(snapshot.value);
    });
  }

  void _makeAvailable() {
    _lookForPlayers((Map players) {
      if (players == null) {
        var obj = dbRef.child('users').child('public').child(uid);
        obj.update({'entered': DateTime.now().millisecondsSinceEpoch});
        obj.onChildAdded.listen((Event event) {
          print('child added: ${event.snapshot.key}');
          if (event.snapshot.key == 'gameId') {
            setState(() => gameId = event.snapshot.value);
            print(
                'I was changed. ${event.snapshot.key} = ${event.snapshot.value}');
          }
        });
      } else {
        setState(() => looking = false);
        dbRef
            .child('users')
            .child('public')
            .child(players.entries.first.key)
            .update({'gameId': 1});
        print('player: ${players.entries.first.key}');
      }
    });
  }

  void _makeUnavailable() {
    dbRef.child('users').child('public').child(uid).remove();
  }

  @override
  void dispose() {
    _makeUnavailable();
    super.dispose();
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
        ],
      ),
    );
  }
}
//checking
