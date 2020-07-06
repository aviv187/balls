import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import './board.dart';

void main() {
  timeDilation = 2;

  return runApp(MyApp());
}

//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ball Game',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
        elevation: 0,
      ),
      body: Board(),
    );
  }
}
