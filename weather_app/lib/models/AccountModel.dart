import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../models/DBUtils.dart';

class AccountModel{
  Future addAccount(String username, String password, List settings) async{
    await Firebase.initializeApp();
    final data = <String,Object?>{
      "username": username,
      "password": password,
      "settings": settings
    };
    await FirebaseFirestore.instance.collection('Account').doc().set(data);
    updateLocal(username, settings);
  }

  Future getAccounts() async{
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance.collection('Account').get();
  }

  Future getLocal() async{
    final db = await DBUtils.init();
    final List queryResult = await db.query('Account');
    if (queryResult.isEmpty){
      return [];
    }
    List settings = [];
    String set = queryResult[0]['settings'];
    for (int index = 0; index < set.length; index++){
      (set[index] == "1") ? settings.add(true) : settings.add(false);
    }
    return [settings, queryResult[0]['username']];
  }

  Future updateAccount(DocumentReference id, String username, String password, List settings) async{
    await Firebase.initializeApp();
    final data = <String,Object?>{
      "username": username,
      "password": password,
      "settings": settings
    };
    updateLocal(username, settings);
    return id.update(data);
  }

  Future updateLocal(String username, List settings) async{
    final db = await DBUtils.init();
    db.delete(
      'Account',
    );
    return db.insert(
      'Account',
      createMap(username, settings),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Map<String,Object?> createMap(String username, List settings){
    String stringSettings = "";
    for (int index = 0; index < 13; index ++){
      settings[index] ? stringSettings += "1" : stringSettings += "0";
    }
    return {
      'username': username,
      'settings': stringSettings,
    };
  }
}