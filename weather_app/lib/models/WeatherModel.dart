import 'dart:async';
import 'package:sqflite/sqflite.dart';

import '../utility/DBUtils.dart';

class WeatherModel{
  /// adds a new date-weather to the local storage
  /// @param date the date to insert
  /// @param weather the weather to insert
  /// @return returns the inserted value
  Future addWeather(String date, String weather) async{
    final db = await DBUtils.init();
    // insert the new value into local storage
    return db.insert(
      'Weather',
      createMap(date, weather),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// clears local storage of date-weather that has been downloaded
  /// @return returns the deleted value
  Future removeWeather() async{
    final db = await DBUtils.init();
    // deletes weather in local storage
    return db.delete(
      'Weather',
    );
  }

  /// gets the weathers in local storage
  /// @return returns a list of settings, and a username
  Future<List> getDownloads() async{
    final db = await DBUtils.init();
    final List queryResult = await db.query('Weather');
    // if the user does not have an account/ logged out of their account
    if (queryResult.isEmpty){
      return [];
    }
    List result = [];
    for (int i = 0; i < queryResult.length; i++){
      result.add(
          queryResult[i]
      );
    }
    return result;
  }

  /// helper function that creates a map from the date and weather
  /// @param date date to put into the map
  /// @param weather weather to put into the map
  /// @return returns the map of the two inputs
  Map<String,Object?> createMap(String date, String weather){
    return {
      'date': date,
      'weather': weather,
    };
  }
}