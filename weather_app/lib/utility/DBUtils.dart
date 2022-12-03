import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils{
  static Future init() async{
    //set up the database
    return openDatabase(
      path.join(await getDatabasesPath(), 'weather.db'),
      onCreate: (db, version) {
        db.execute('CREATE TABLE Account(username TEXT PRIMARY KEY, settings TEXT)');
        db.execute('CREATE TABLE Weather(date TEXT PRIMARY KEY, weather TEXT)');
      },
      version: 1,
    );
  }
}