import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

class AccountModel{
  Future addAccount(String username, String password, List settings) async{
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

  Future<bool> usernameIsIn(String username) async{
    var accounts = await getAccounts();
    List usernames = accounts.docs.map((doc) => doc.data()).toList();
    for (int index = 0; index < usernames.length; index++){
      if(usernames[index]['username'] == username){
        return true;
      }
    }
    return false;
  }

  Future<bool> passwordIsIn(String password) async{
    var accounts = await getAccounts();
    List passwords = accounts.docs.map((doc) => doc.data()).toList();
    for (int index = 0; index < passwords.length; index++){
      if(passwords[index]['password'] == password){
        return true;
      }
    }
    return false;
  }
}