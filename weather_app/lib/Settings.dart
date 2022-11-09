import 'package:flutter/cupertino.dart';
import 'AccountModel.dart';

class Settings{
  // Names of each setting
  List<String> settingNames = [
    "Temperature",
    "Humidity",
    "Dewpoint",
    "Apparent Temperature",
    "Precipitation",
    "Rain",
    "Snowfall",
    "Snow Depth",
    "Cloud Cover",
    "Wind Speed",
    "Wind Direction",
    "Soil Temperature",
    "Soil Moisture"
  ];

  // Descriptions for each setting
  List<String> descriptions = [
    "Show the hourly temperature (°C)",
    "Show the hourly humidity (%)",
    "Show the hourly dewpoint (%)",
    "Show what it \"Feels Like\" with rain, windchill, etc each hour (°C)",
    "Show the hourly precipitation(includes rain, snowfall and showers) (mm)",
    "Show the hourly rain (mm)",
    "Show the hourly snowfall (mm)",
    "Show the hourly snow depth (m)",
    "Show the hourly cloud coverage (%)",
    "Show the hourly wind speed (km/h)",
    "Show the hourly wind direction (°, with North as 0°)",
    "Show the hourly soil temperature (°)",
    "Show the hourly soil moisture (m³/m³)"
  ];
/*
  // Whether each setting is checked off
  // TODO might be able to remove this since settings is stored in the BLoC
  List<bool> isChecked = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  Settings({booleans = const []}){
    if (booleans.length == 13){
      for (int index = 0; index < booleans.length; index++){
        isChecked[index] = booleans[index];
      }
    }
  }*/
}

class SettingsBLoC with ChangeNotifier{
  List _usernames = [];
  List _passwords = [];
  List _settings = [];
  List _userSettings =
    [true,true,true,true,true,true,true,true,true,true,true,true,true];
  //TODO make the default setting whatever is stored in local storage

  SettingsBLoC(){
    initializeList();
  }

  initializeList() async{
    var accounts = await AccountModel().getAccounts();
    List users = accounts.docs.map((doc) => doc.data()).toList();
    for (int index = 0; index < users.length; index++){
      _usernames.add(users[index]['username']);
      _passwords.add(users[index]['password']);
      _settings.add(users[index]['settings']);
    }
    notifyListeners();
  }

  get usernames => _usernames;
  get passwords => _passwords;
  get settings => _settings;
  get userSettings => _userSettings;

  set userSettings(value) {
    _userSettings = value;
    notifyListeners();
  }

  int usernameIsIn(String username){
    for (int index = 0; index < _usernames.length; index++){
      if(_usernames[index] == username){
        return index;
      }
    }
    return -1;
  }

  bool passwordIsIn(String password, int location) {
    if(_passwords[location] == password){
      return true;
    }
    return false;
  }
}