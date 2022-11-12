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
  bool selectedLogIn = false;
  List settings =
    [true,true,true,true,true,true,true,true,true,true,true,true,true];
  @override
  Widget build(BuildContext context) {
    SettingsBLoC settingsBLoC = context.watch<SettingsBLoC>();
    AccountPageBLoC accountBLoC = context.watch<AccountPageBLoC>();
    if (accountBLoC.username != ""){
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
                if (selectedLogIn && usernameIndex! < 0){
                  return "Username does not exist";
                }
                else if (selectedLogIn == false && usernameIndex! >= 0){
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
                if ((selectedLogIn && usernameIndex! >= 0) && settingsBLoC.passwordIsIn(value, usernameIndex!) == false){
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
                        AccountModel().addAccount(accountBLoC.username, accountBLoC.password!, settings);
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
              ElevatedButton(
                onPressed: (){
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
                    settingsBLoC.userSettings = settingsBLoC.settings[usernameIndex];
                    AccountModel().updateLocal(accountBLoC.username, settings);
                    setState(() {
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
  String _username = "";
  String _password = "";

  AccountPageBLoC(){
    initializeList();
  }

  initializeList() async{
    List local = await AccountModel().getLocal();
    if (local.isNotEmpty){
      _username = local[1];
    }
    //notifyListeners();
  }

  get username => _username;
  get password => _password;

  set username(value) {
    _username = value;
    notifyListeners();
  }

  set password(value) {
    _password = value;
    notifyListeners();
  }
}
