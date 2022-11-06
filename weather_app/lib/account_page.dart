import 'package:flutter/material.dart';

import 'AccountModel.dart';

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
  final formKey = GlobalKey<FormState>();
  String? username;
  String? password;
  bool login = false;
  List settings = [true,true,true,true,true,true,true,true,true,true,true,true,true]; //TODO will go back to this once the settings class is made
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
            child: TextFormField(
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
              ),
              validator: (value){
                if (value!.isEmpty || value.length < 4){
                  return "User Name must be at least 4 characters";
                }
                //this will break everything do not uncomment it!
                //Future<bool> usernameIn = AccountModel().usernameIsIn(value);
                if (login){// && usernameIn){
                  // TODO if the username exists already, warn the user
                  return "Login does not work yet";
                }
                return null;
              },
              onSaved: (value){
                username = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30,bottom: 40),
            child: TextFormField(
              obscureText: true,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              validator: (value){
                if (value!.isEmpty || value.length < 8){
                  return "Password must be at least 8 characters";
                }
                return null;
                //TODO add validation for server (if password is correct)
              },
              onSaved: (value){
                password = value;
              },
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 40),
                child: ElevatedButton(
                  onPressed: (){
                    login = false;
                    if(formKey.currentState!.validate()){
                      formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("User Registered!",
                              style: TextStyle(fontSize: 20),
                            )
                        ),
                      );
                      AccountModel().addAccount(username!, password!, settings);
                      // TODO go to an account page which has username and a sign out button
                    }
                  },
                  child: const Text("Sign Up",
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  login = true;
                  if(formKey.currentState!.validate()){
                    formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("User Logged In!",
                            style: TextStyle(fontSize: 20),
                          )
                      ),
                    );
                    // TODO go to an account page which has username and a sign out button
                  }
                },
                child: const Text("Log In",
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
