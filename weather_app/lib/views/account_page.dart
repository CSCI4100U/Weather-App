import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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
  @override
  Widget build(BuildContext context) {
    SettingsBLoC settingsBLoC = context.watch<SettingsBLoC>();
    AccountPageBLoC accountBLoC = context.watch<AccountPageBLoC>();
    if (accountBLoC.username != ""){ // if there is a username in local storage
      return
        Scaffold(
          body: Center( // show the Account page with the user and a log out button
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text(
                      FlutterI18n.translate(context, "account.account"),
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 50,
                      )
                  ),
                ),
                Text("${FlutterI18n.translate(context, "account.username")}:"
                    " ${accountBLoC.username}", style: const TextStyle(fontSize: 20),),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 40, top: 30),
                  child: ElevatedButton(
                    onPressed: (){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                              FlutterI18n.translate(context, "account.logoutprompt"),
                              style: const TextStyle(fontSize: 20),
                            )
                        ),
                      );
                      // when the user logs out, the username is set to empty,
                      //  and settings the set back to the default of all on
                      // The local storage is also updated to remove the account
                      setState(() {
                        accountBLoC.username = "";
                        settingsBLoC.userSettings = [true,true,true,true,true,true,true,true,true,true,true,true,true];
                        AccountModel().updateLocal(accountBLoC.username, settingsBLoC.userSettings);
                      });
                    },
                    child: Text(
                      FlutterI18n.translate(context, "account.signout"),
                      style: const TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 40, top: 30, bottom: 40),
                  child: ElevatedButton(
                    onPressed: (){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                              FlutterI18n.translate(context, "account.deleteaccountprompt"),
                              style: const TextStyle(fontSize: 20),
                            )
                        ),
                      );
                      // when the user logs out, the username is set to empty,
                      //  and settings the set back to the default of all on
                      // The local storage is also updated to remove the account
                      setState(() {
                        usernameIndex = settingsBLoC.usernameIsIn(accountBLoC.username);
                        settingsBLoC.selectedIndex = usernameIndex;
                        AccountModel().deleteAccount(settingsBLoC.references[settingsBLoC.selectedIndex]);
                        accountBLoC.username = "";
                        settingsBLoC.userSettings = [true,true,true,true,true,true,true,true,true,true,true,true,true];
                        AccountModel().updateLocal(accountBLoC.username, settingsBLoC.userSettings);
                      });
                    },
                    child: Text(
                      FlutterI18n.translate(context, "account.deleteaccount"),
                      style: const TextStyle(fontSize: 35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    }
    return Form( // show the sign up/login screen
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
                FlutterI18n.translate(context, "account.account"),
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 50,
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30,bottom: 20),
            child: TextFormField(
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: FlutterI18n.translate(context, "account.username"),
              ),
              validator: (value){
                // validation for proper usernames
                if (value!.isEmpty || value.length < 4){
                  return FlutterI18n.translate(context, "account.usernamelengthprompt");
                }
                usernameIndex = settingsBLoC.usernameIsIn(value);
                // if the entered username is not in the database, fail validation
                if (selectedLogIn && usernameIndex! < 0){
                  return FlutterI18n.translate(context, "account.nousernameprompt");
                }
                // if the username is taken, and the user selected sign up, fail validation
                else if (selectedLogIn == false && usernameIndex! >= 0){
                  return FlutterI18n.translate(context, "account.usernametakenprompt");
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
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: FlutterI18n.translate(context, "account.password"),
              ),
              validator: (value){
                // validation for proper passwords
                if (value!.isEmpty || value.length < 8){
                  return FlutterI18n.translate(context, "account.passwordlengthprompt");
                }
                // if the user selected Log In and the password does not match the username, fail validation
                if ((selectedLogIn && usernameIndex! >= 0) &&
                    settingsBLoC.passwordIsIn(value, usernameIndex!) == false){
                  return FlutterI18n.translate(context, "account.passwordwrongprompt");
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
                        SnackBar(
                            content: Text(
                              FlutterI18n.translate(context, "account.registerprompt"),
                              style: const TextStyle(fontSize: 20),
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
                        // settingsBLoC.selectedIndex = usernameIndex;
                        settingsBLoC.initializeList();
                      });
                    }
                  },
                  child: Text(
                    FlutterI18n.translate(context, "account.register"),
                    style: const TextStyle(fontSize: 35),
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
                      SnackBar(
                          content: Text(
                            FlutterI18n.translate(context, "account.loginprompt"),
                            style: const TextStyle(fontSize: 20),
                          )
                      ),
                    );
                    // the current user settings is updated to what is stored
                    //  in the cloud databse for that account
                    settingsBLoC.userSettings =
                      settingsBLoC.settings[usernameIndex];
                    // the local database is updated with the cloud's account
                    AccountModel().updateLocal(accountBLoC.username, settingsBLoC.userSettings);
                    setState(() {
                      // selected index is updated
                      settingsBLoC.selectedIndex = usernameIndex;
                    });
                  }
                },
                child: Text(
                  FlutterI18n.translate(context, "account.login"),
                  style: const TextStyle(fontSize: 35),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              FlutterI18n.translate(context, "account.description"),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey
              ),
            ),
          ),
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
