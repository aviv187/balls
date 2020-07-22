import 'package:ballGame/screens/optionsPage.dart';
import 'package:flutter/material.dart';

import 'screens/HomePage.dart';
import 'screens/scorePage.dart';
import 'screens/chooseBoard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ball Game',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(),
      routes: {
        ChooseBoard.routeName: (ctx) => ChooseBoard(),
        ScorePage.routeName: (ctx) => ScorePage(),
        OptionsPage.routeName: (ctx) => OptionsPage(),
      },
    );
  }
}
