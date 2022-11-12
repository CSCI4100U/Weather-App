import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/Settings.dart';
import '../models/AccountModel.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final formKey = GlobalKey<FormState>();
  int? usernameIndex;
  bool selectedLogIn = false; // if the user taps on the Log In button,
                              // this will be true

  // by default, a new user will have every setting enabled
  List settings =
    [true,true,true,true,true,true,true,true,true,true,true,true,true];
  @override
  Widget build(BuildContext context) {
    SettingsBLoC settingsBLoC = context.watch<SettingsBLoC>();
    AccountPageBLoC accountBLoC = context.watch<AccountPageBLoC>();
    if (accountBLoC.username != ""){ // if there is a username in local storage
      return Center( // show the Account page with the user and a log out button
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
            Text("User: ${accountBLoC.username}", style: const TextStyle(fontSize: 20),),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 40, top: 30, bottom: 110),
              child: ElevatedButton(
                onPressed: (){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("User Logged Out!",
                          style: TextStyle(fontSize: 20),
                        )
                    ),
                  );
                  // when the user logs out, the username is set to empty,
                  //  and settings the set back to the default of all on
                  // The local storage is also updated to remove the account
                  setState(() {
                    accountBLoC.username = "";
                    settingsBLoC.userSettings = [true,true,true,true,true,true,true,true,true,true,true,true,true];
                    AccountModel().updateLocal(accountBLoC.username, settings);
                  });
                },
                child: const Text("Sign Out",
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Form( // show the sign up/login screen
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
                // validation for proper usernames
                if (value!.isEmpty || value.length < 4){
                  return "User Name must be at least 4 characters";
                }
                usernameIndex = settingsBLoC.usernameIsIn(value);
                // if the entered username is not in the database, fail validation
                if (selectedLogIn && usernameIndex! < 0){
                  return "Username does not exist";
                }
                // if the username is taken, and the user selected sign up, fail validation
                else if (selectedLogIn == false && usernameIndex! >= 0){
                  return "Username has been taken";
                }
                return null;
              },
              onSaved: (value){
                // username is updated to what the user entered into the TextFormField
                accountBLoC.username = value;
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
                // validation for proper passwords
                if (value!.isEmpty || value.length < 8){
                  return "Password must be at least 8 characters";
                }
                // if the user selected Log In and the password does not match the username, fail validation
                if ((selectedLogIn && usernameIndex! >= 0) &&
                    settingsBLoC.passwordIsIn(value, usernameIndex!) == false){
                  return "Incorrect password";
                }
                return null;
              },
              onSaved: (value){
                // password is updated to what the user entered into the TextFormField
                accountBLoC.password = value;
              },
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 40),
                child: ElevatedButton( // on Sign Up
                  onPressed: (){
                    selectedLogIn = false;
                    if(formKey.currentState!.validate()){
                      formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("User Registered!",
                              style: TextStyle(fontSize: 20),
                            )
                        ),
                      );
                      setState(() {
                        // On sign up, the new account is added to both cloud
                        //  and local storage
                        AccountModel().addAccount(
                            accountBLoC.username,
                            accountBLoC.password!,
                            settingsBLoC.userSettings
                        );
                        // selected index is updated and the arrays for
                        //  username, password, settings, and references
                        //  are updated
                        settingsBLoC.selectedIndex = usernameIndex;
                        settingsBLoC.initializeList();
                      });
                    }
                  },
                  child: const Text("Sign Up",
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ),
              ElevatedButton( // on Log In
                onPressed: (){
                  // the user selected Log In, so selectedLogIn becomes true
                  selectedLogIn = true;
                  if(formKey.currentState!.validate()){
                    formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("User Logged In!",
                            style: TextStyle(fontSize: 20),
                          )
                      ),
                    );
                    // the current user settings is updated to what is stored
                    //  in the cloud databse for that account
                    settingsBLoC.userSettings =
                      settingsBLoC.settings[usernameIndex];
                    // the local database is updated with the cloud's account
                    AccountModel().updateLocal(accountBLoC.username, settings);
                    setState(() {
                      // selected index is updated
                      settingsBLoC.selectedIndex = usernameIndex;
                    });
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
/// BLoC to store the current username and password of the account,
///   using this prevents the effect of leaving the account page logging you out
class AccountPageBLoC with ChangeNotifier{
  // username and password of the user
  String _username = "";
  String _password = "";

  AccountPageBLoC(){
    initializeList();
  }

  /// sets username to be the username of what is stored in local storage
  ///   if nothign is stored in local storage then username remains empty
  initializeList() async{
    List local = await AccountModel().getLocal();
    if (local.isNotEmpty){
      _username = local[1];
    }
    //notifyListeners();
  }

  // getters for username and password
  get username => _username;
  get password => _password;

  // setters for _username and _password
  set username(value) {
    _username = value;
    notifyListeners();
  }
  set password(value) {
    _password = value;
    notifyListeners();
  }
}
