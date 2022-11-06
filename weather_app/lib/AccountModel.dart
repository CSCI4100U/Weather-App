import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

class AccountModel{
  Future addAccount(String username, String password, String settings) async{
    await Firebase.initializeApp();
    final data = <String,Object?>{
      "username": username,
      "password": password,
      "settings": settings
    };
    await FirebaseFirestore.instance.collection('Account').doc().set(data);
  }

  Future getAccounts() async{
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance.collection('Account').get();
  }
}