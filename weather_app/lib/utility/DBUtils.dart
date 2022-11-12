import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils{
  static Future init() async{
    //set up the database
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'grades.db'),
      onCreate: (db, version){
        db.execute(
            'CREATE TABLE Account(username TEXT PRIMARY KEY, settings TEXT)'
        );
      },
      version: 1,
    );

    return database;
  }
}