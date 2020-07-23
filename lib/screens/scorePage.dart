import 'package:flutter/material.dart';

class ScorePage extends StatefulWidget {
  static const routeName = '/score';

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Balls'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 70),
            Text(
              'score Board',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // (scoreList.isEmpty)
            //     ? Text('empty :(')
            //     : Expanded(
            //         child: ListView.builder(
            //           itemCount: scoreList.length,
            //           padding: EdgeInsets.symmetric(
            //             horizontal: 80,
            //             vertical: 10,
            //           ),
            //           itemBuilder: (BuildContext context, int i) {
            //             scoreList.sort((a, b) => b.score.compareTo(a.score));
            //             return Center(
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: <Widget>[
            //                   Text('${i + 1}. ${scoreList[i].name}'),
            //                   Text(scoreList[i].score),
            //                 ],
            //               ),
            //             );
            //           },
            //         ),
            //       ),
          ],
        ),
      ),
    );
  }
}
