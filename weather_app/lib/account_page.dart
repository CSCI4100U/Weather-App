import 'package:flutter/material.dart';

// TODO
// Register and Sign In
// Validating Sign In Information From Cloud Storage
// Return Settings Object of User Settings After Sign In

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? username;
  String? password;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                  "Account",
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 50,
                  )
              ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30,bottom: 20),
            child: TextField(
                onChanged: (value){
                  username = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30,bottom: 40),
            child: TextField(
              onChanged: (value){
                password = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Row(
           children: [
             Padding(
               padding: const EdgeInsets.only(left: 35, right: 40),
               child: ElevatedButton(
                 child: const Text("Sign Up",style: TextStyle(fontSize: 35),),
                 onPressed: () {
                   // TODO
                 },
               ),
             ),
             ElevatedButton(
               child: const Text("Log In", style: TextStyle(fontSize: 35),),
               onPressed: () {
                 // TODO
               },
             ),
           ],
          )
        ],
      ),
    );
  }
}
