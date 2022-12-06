import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../utility/DBUtils.dart';

class AccountModel{
  /// Adds an account to the cloud and local databases
  /// @param username username of the account
  /// @param username password of the account
  /// @param settings settings of the account
  Future addAccount(String username, String password, List settings) async{
    await Firebase.initializeApp();
    final data = <String,Object?>{
      "username": username,
      "password": password,
      "settings": settings
    };
    await FirebaseFirestore.instance.collection('Account').doc().set(data);
    // add the Account to local storage
    updateLocal(username, settings);
  }
  /// gets accounts from cloud storage (used to update settingsBLoC)
  /// @return returns all of the documents in the cloud database
  Future getAccounts() async{
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance.collection('Account').get();
  }

  /// gets the account in local storage
  /// @return returns a list of settings, and a username
  Future getLocal() async{
    final db = await DBUtils.init();
    final List queryResult = await db.query('Account');
    // if the user does not have an account/ logged out of their account
    if (queryResult.isEmpty){
      return [];
    }
    List settings = [];
    String set = queryResult[0]['settings'];
    // converts the '1' and '0' from the local database to true and false
    for (int index = 0; index < set.length; index++){
      (set[index] == "1") ? settings.add(true) : settings.add(false);
    }
    return [settings, queryResult[0]['username']];
  }

  /// updates the selected account in cloud storage, and replaces the account
  /// in local storage
  /// @return returns the id once the data is updated
  Future updateAccount(DocumentReference id, String username, String password, List settings) async{
    await Firebase.initializeApp();
    final data = <String,Object?>{
      "username": username,
      "password": password,
      "settings": settings
    };
    // replace the Account to local storage
    updateLocal(username, settings);
    return id.update(data);
  }

  /// updates the local storage by replacing it
  /// @param username the username to insert
  /// @param settings the settings to insert
  /// @return returns the inserted value
  Future updateLocal(String username, List settings) async{
    // delete the value in local storage
    final db = await DBUtils.init();
    db.delete(
      'Account',
    );
    // insert the new value into local storage
    return db.insert(
      'Account',
      createMap(username, settings),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future deleteAccount(DocumentReference id) async {
    await Firebase.initializeApp();
    return id.delete();
  }

  /// helper function that creates a map from the username and settings,
  ///   also converts the List of settings into a string
  /// @param username username to put into the map
  /// @param settings settings to put into the map
  /// @return returns the map of the two inputs
  Map<String,Object?> createMap(String username, List settings){
    String stringSettings = "";
    for (int index = 0; index < 13; index ++){
      // takes the values of 'true' and 'false' from the settings array
      //  and converts them to '1' and '0' to store in local storage
      settings[index] ? stringSettings += "1" : stringSettings += "0";
    }
    return {
      'username': username,
      'settings': stringSettings,
    };
  }
}