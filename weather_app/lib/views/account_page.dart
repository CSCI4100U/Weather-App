import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/Settings.dart';
import '../models/AccountModel.dart';

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
  int? usernameIndex;
  bool login = false;
  List settings =
    [true,true,true,true,true,true,true,true,true,true,true,true,true];
  @override
  Widget build(BuildContext context) {
    SettingsBLoC settingsBLoC = context.watch<SettingsBLoC>();
    AccountPageBLoC accountBLoC = context.watch<AccountPageBLoC>();
    if (accountBLoC.userLoggedIn!){
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
                  setState(() {
                    accountBLoC.userLoggedIn = false;
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
                usernameIndex = settingsBLoC.usernameIsIn(value);
                if (login && usernameIndex! < 0){
                  return "Username does not exist";
                }
                else if (login == false && usernameIndex! >= 0){
                  return "Username has been taken";
                }
                return null;
              },
              onSaved: (value){
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
                if (value!.isEmpty || value.length < 8){
                  return "Password must be at least 8 characters";
                }
                if ((login && usernameIndex! >= 0) && settingsBLoC.passwordIsIn(value, usernameIndex!) == false){
                  return "Incorrect password";
                }
                return null;
              },
              onSaved: (value){
                accountBLoC.password = value;
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
                      AccountModel().addAccount(accountBLoC.username!, accountBLoC.password!, settings);
                      settingsBLoC.initializeList();
                      setState(() {
                        accountBLoC.userLoggedIn = true;
                        settingsBLoC.selectedIndex = usernameIndex;
                      });
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
                    settingsBLoC.userSettings = settingsBLoC.settings[usernameIndex];
                    setState(() {
                      accountBLoC.userLoggedIn = true;
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
class AccountPageBLoC with ChangeNotifier{
  bool _userLoggedIn = false;
  String? _username;
  String? _password;

  get userLoggedIn => _userLoggedIn;
  get username => _username;
  get password => _password;

  set userLoggedIn(value) {
    _userLoggedIn = value;
    notifyListeners();
  }

  set username(value) {
    _username = value;
    notifyListeners();
  }

  set password(value) {
    _password = value;
    notifyListeners();
  }
}
