import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../helpFunction/database.dart';

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  List<Map> yourScoreList = [];
  List<dynamic> globalScoreList = [];

  DatabaseReference scoreRef;

  void _getYourScoreboard() async {
    List<Map> list = await DatabaseHelper.instance.queryAll();
    // print(list);
    setState(() => yourScoreList = list);
  }

  void _getGlobalScoreboard() async {
    try {
      scoreRef = FirebaseDatabase.instance.reference().child('scores');
      scoreRef.once().then((DataSnapshot snapshot) {
        setState(() => globalScoreList = snapshot.value);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getYourScoreboard();
    _getGlobalScoreboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scores'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 300,
            child: ScoreListWidget(
              listName: 'Your Score Board',
              scoreList: yourScoreList,
            ),
          ),
          SizedBox(
            height: 300,
            child: ScoreListWidget(
              listName: 'Global Score Board',
              scoreList: globalScoreList,
            ),
          ),
        ],
      )),
    );
  }
}

class ScoreListWidget extends StatelessWidget {
  const ScoreListWidget({
    @required this.scoreList,
    @required this.listName,
  });

  final String listName;
  final List scoreList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 70),
        Text(
          listName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        (scoreList.isEmpty)
            ? Text('empty :(')
            : Expanded(
                child: ListView.builder(
                  itemCount: scoreList.length,
                  padding: EdgeInsets.symmetric(
                    horizontal: 80,
                    vertical: 10,
                  ),
                  itemBuilder: (BuildContext context, int i) {
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('${i + 1}. ${scoreList[i]['name']}'),
                          Text(scoreList[i]['score']),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
