import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './board.dart';
import './HomePage.dart';
import './scorePage.dart';

enum Screen {
  homePage,
  game,
  scoreBoard,
  options,
}

void main() => runApp(MyApp());

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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Screen currentScreen = Screen.homePage;

  void changeScreen(Screen screen) {
    setState(() {
      currentScreen = screen;
    });
  }

  Widget screen(Screen screen, double screenWidth) {
    switch (screen) {
      case Screen.homePage:
        return HomePage(
          screenWidth: screenWidth,
          changeScreen: changeScreen,
        );
        break;
      case Screen.game:
        return Board(
          height: screenWidth * 1.7,
          witdh: screenWidth,
        );
        break;
      case Screen.scoreBoard:
        return ScorePage();
        break;
      case Screen.options:
        return Container();
        break;
      default:
        return HomePage(
          screenWidth: screenWidth,
          changeScreen: changeScreen,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text('Balls'),
          centerTitle: true,
          elevation: 0,
          leading: (currentScreen != Screen.homePage)
              ? SafeArea(
                  child: Center(
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        currentScreen = Screen.homePage;
                      });
                    },
                  ),
                ))
              : Container(),
        ),
        body: screen(currentScreen, screenWidth));
  }
}
