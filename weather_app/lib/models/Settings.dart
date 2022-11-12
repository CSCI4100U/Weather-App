import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'AccountModel.dart';

// A class to store the state(whether to display or not) of each setting
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
}

/// BLoC used to have access to usernames, passwords, and settings quickly,
///   across all pages
class SettingsBLoC with ChangeNotifier{
  int? _selectedIndex;    // Uses this to know which element to grab from the following arrays:
  List _usernames = [];   // Array of all usernames stored in the cloud
  List _passwords = [];   // Array of all passwords stored in the cloud
  List _settings = [];    // Array of all settings stored in the cloud
  List _references = [];  // Array of all Document References, used to edit the cloud database

  // Array of the current user's settings
  // (each value corresponds to a setting in the settings page)
  List _userSettings =
    [true,true,true,true,true,true,true,true,true,true,true,true,true];

  // runs the asyn function when SettingsBLoC is initialized
  SettingsBLoC(){
    initializeList();
  }

  // grabs usernames, passwords, and settings from the cloud and stores it
  // in the local arrays
  initializeList() async{
    var accounts = await AccountModel().getAccounts();
    List users = accounts.docs.map((doc) => doc.data()).toList();
    for (int index = 0; index < users.length; index++){
      _usernames.add(users[index]['username']);
      _passwords.add(users[index]['password']);
      _settings.add(users[index]['settings']);
    }
    // stores the Document reference of each document
    _references = accounts.docs.map( (document)
      => getRef(document)
      ).toList();
    // if an account is in local storage (signed out of the app without
    // logging out of the account, then it is automatically logged into
    List local = await AccountModel().getLocal();
    if (local.isNotEmpty){
      _userSettings = local[0]; // local[0] is an array of settings like _usersettings
      selectedIndex = usernameIsIn(local[1]); // local[1] is the username
    }
    notifyListeners();
  }

  // returns the reference of the gradeData
  getRef(DocumentSnapshot gradeData){
    return gradeData.reference;
  }

  // getters for the private variables
  get usernames => _usernames;
  get passwords => _passwords;
  get settings => _settings;
  get userSettings => _userSettings;
  get selectedIndex => _selectedIndex;

  // setters for _selectedIndex and _userSettings
  set selectedIndex(value) {
    _selectedIndex = value;
    notifyListeners();
  }
  set userSettings(value) {
    _userSettings = value;
    notifyListeners();
  }

  /// checks if the username is in the cloud database
  /// @param username the username to search in the cloud
  /// @return returns the index of the username if it is in the database,
  ///  otherwise returns -1 (not in the database)
  int usernameIsIn(String username){
    for (int index = 0; index < _usernames.length; index++){
      if(_usernames[index] == username){
        return index;
      }
    }
    return -1;
  }

  /// checks if the password is in the cloud database
  /// @param password the password to search in the cloud
  /// @param location the index to check (want to check the password with
  ///   the username of same index)
  /// @return returns true if the password matches the username
  bool passwordIsIn(String password, int location) {
    if(_passwords[location] == password){
      return true;
    }
    return false;
  }

  /// updates the cloud and local storages with the new values
  /// for cloud storage it will change the currently selected account
  /// for local storage it will replace the account that is currently in there
  updateSettings() async{
    if (_selectedIndex != null && _selectedIndex! >= 0){
      AccountModel().updateAccount(
          _references[_selectedIndex!],
          _usernames[_selectedIndex!],
          _passwords[_selectedIndex!],
          _userSettings
      );
      notifyListeners();
    }
  }
}