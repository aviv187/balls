// import 'package:sqflite/sqflite.dart';
// import 'package:sqflite/sqlite_api.dart';
// import 'package:path/path.dart';

// import './models/scoreModel.dart';

// class DBProvider {
//   DBProvider._();
//   static final DBProvider db = DBProvider._();
//   static Database _database;

//   Future<Database> get database async {
//     if (_database != null) return _database;

//     _database = await initDB();
//     return _database;
//   }

//   initDB() async {
//     return await openDatabase(join(await getDatabasesPath(), 'ballGame.db'),
//         onCreate: (db, version) async {
//       await db.execute('''
//           CREATE TABLE scores (
//             name TEXT PRIMARY KEY, score TEXT
//           )
//         ''');
//     }, version: 1);
//   }

//   newScore(Score newScore) async {
//     final db = await database;

//     var res = await db.rawInsert('''
//       INSERT INTO scores (
//         name, score
//       ) VALUES (?, ?)
//     ''', [newScore.name, newScore.score]);

//     return res;
//   }

//   Future<dynamic> getScores() async {
//     final db = await database;
//     var res = await db.query('name');

//     if (res.length == 0) {
//       return null;
//     } else {
//       var resMap = res;
//       return resMap.isNotEmpty ? resMap : Null;
//     }
//   }
// }
