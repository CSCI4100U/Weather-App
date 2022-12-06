import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/WeatherModel.dart';
import 'dart:convert';

import '../models/Weather.dart';

/// Generates a URL for getting weather from the API
/// @param latitude latitude to put in the url
/// @param longitude longitude to put in the url
/// @param weatherDate date to put in the url
/// @return returns a string of the url
String generateUrl(double latitude, double longitude, DateTime weatherDate){
  String date = _toDateString(weatherDate);
  String result = "https://api.open-meteo.com/v1/forecast?"
      "latitude=$latitude"
      "&longitude=$longitude"
      "&hourly=temperature_2m,"
      "relativehumidity_2m,"
      "dewpoint_2m,"
      "apparent_temperature,"
      "precipitation,"
      "rain,"
      "snowfall,"
      "snow_depth,"
      "weathercode,"
      "cloudcover,"
      "windspeed_10m,"
      "winddirection_10m,"
      "soil_temperature_0cm,"
      "soil_moisture_0_1cm"
      "&daily=weathercode,"
      "temperature_2m_max,"
      "temperature_2m_min"
      "&timezone=auto"
      "&start_date=$date"
      "&end_date=${_toDateString(DateTime(
        weatherDate.year,
        weatherDate.month,
        weatherDate.day + 6))}";
  return result;
}

/// takes an integer and returns a two digit form of it. 5 -> 05, 11 -> 11
/// @param value integer to convert
/// @return String value of the integer
String _twoDigits(int value){
  if (value > 9){
    return "$value";
  }
  return "0$value";
}

/// takes a DateTime date and returns a String version of it
/// @param date date to convert
/// @return String version of date
String _toDateString(DateTime date){
  return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
}

/// Load The Weather Information From The API
/// @param url url to load
/// @return Weather object gained from the API
Future loadContent(String url) async{
  Weather? weather;

  var response = await http.get(Uri.parse(url));

  // If successful in fetching results
  if (response.statusCode == 200){
    String data = response.body;
    Map<String, Object?> contents = jsonDecode(data);
    weather = Weather.fromMap(contents);
    return weather;
  }
  // If you fail to fetch results
  else{
    return SnackBar(content: Text("Unsuccessful fetch status code: ${response.statusCode}"));
  }
}

/// BLoC used to have access to usernames, passwords, and settings quickly across all pages
class WeatherBLoC with ChangeNotifier{
  // values for weather and its string variant
  Weather? _weather;
  String _sWeather = "";

  // values for the current position, address, and if the position has been changed
  Position? currentPosition;
  String _address = "Loading Address";
  String countryArea = "";
  bool changedPosition = false;

  // values for date and weather or not the date has been changed
  bool changedDate = true;
  DateTime _date = DateTime.now();

  // stores a list of downloaded weather data
  List _downloads = [];

  // the selected index in the downloads page
  int? _selectedIndex;

  // while this is true, the downloads page will prompt the user to enter a date
  bool initial = true;

  // getters for variables
  get weather => _weather;
  get date => _date;
  get sDate => _toDateString(_date);
  get downloads => _downloads;
  get sWeather => _sWeather;
  get selectedIndex => _selectedIndex;
  get address => _address;

  // setters which also run notifyListeners()
  set date(value){
    // if the new date is different, set changedDate to true
    if (_date != value) changedDate = true;
    _date = value;
    notifyListeners();
  }
  set selectedIndex(value) {
    _selectedIndex = value;
    notifyListeners();
  }
  set address(value) {
    _address = value;
    notifyListeners();
  }

  /// when WeatherBLoC is created, this runs
  WeatherBLoC(){
    // Geolocator will get the user's position
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best
      ),
    ).listen(updatePosition);

    // cloud storage will be downloaded locally for fast comparisons
    initializeList();
    // weather data is pulled from local storage
    initializeDownloads();
  }

  /// updates the position stored in WeatherBLoC
  /// @param newPosition the position to update to
  updatePosition(Position newPosition){
    if (currentPosition == null){
      currentPosition = newPosition;
      changedPosition = true;
      updateAddress();

      generateWeather();
      notifyListeners();
    }
  }

  /// updates the address stored in WeatherBLoC
  updateAddress() async{
    final List<Placemark> places = await placemarkFromCoordinates(
        currentPosition!.latitude,
        currentPosition!.longitude
    );
    if (address != "${places[0].subThoroughfare} ${places[0].thoroughfare}") {
        address = "${places[0].subThoroughfare} ${places[0].thoroughfare}";
        countryArea = "${places[0].locality}, ${places[0].administrativeArea}, ${places[0].isoCountryCode}";
    }
  }

  /// sets weather and location to what is stored in local storage
  /// @param data the string json result from a previously fetched API request
  updateToDownloadedWeather(String data) async{
    Map<String, Object?> contents = jsonDecode(data);
    _weather = Weather.fromMap(contents);
    _sWeather = data;

    final placemark = await placemarkFromCoordinates(_weather!.latitude!, _weather!.longitude!);
    _address = "${placemark[0].subThoroughfare} "
        "${placemark[0].thoroughfare}";
    countryArea = "${placemark[0].locality},"
        " ${placemark[0].administrativeArea}, "
        "${placemark[0].isoCountryCode}";

    notifyListeners();
  }

  /// if _weather has not been set, set it using the current position and time
  /// @return _weather varaible that contains weather information
  Future initializeList() async{
    // If the weather object is already up to date and not empty
    _weather ??= await generateWeather();
    return _weather;
  }

  /// grabs the downloaded weather from local storage
  Future initializeDownloads() async{
    // sets _downloads to what is stored in local storage
    _downloads = await WeatherModel().getDownloads();

    // if there is nothing in local storage, generateWeather using the current date
    if (_downloads.isEmpty) generateWeather(true);
    notifyListeners();
  }

  /// generates weather using the position stored in the WeatherBLoC
  /// @param rightNow option parameter which, when true, sets the time to the current time
  /// @return returns the weather object stored in the WeatherBLoC
  Future generateWeather([bool? rightNow]) async{
    // if rightNow is true, _date is set the the time of the phone
    if (rightNow == true) _date == DateTime.now();

    // if the user has changed position or date and WeatherBLoC does not have a position set
    if ((changedPosition || changedDate) && currentPosition != null){
      changedPosition = false;
      changedDate = false;

      // sets weather to what is resulted from the api using the current position and date stored in WeatherBLoC
      _weather = await loadContent(generateUrl(
          currentPosition!.latitude,
          currentPosition!.longitude,
          _date));

      // sets the string version of weather
      _sWeather = await getStringDataFromUrl(
          generateUrl(
          currentPosition!.latitude,
          currentPosition!.longitude,
          _date));

      notifyListeners();
      return _weather;
    }
  }

  /// Load The Weather Information From The API or Downloads
  /// @param url url to load
  /// @return Weather object gained from the API
  Future loadContent(String url) async{
    var response = await http.get(Uri.parse(url));

    // If successful in fetching results
    if (response.statusCode == 200){
      String data = response.body;
      Map<String, Object?> contents = jsonDecode(data);
      _weather = Weather.fromMap(contents);
      return _weather;
    }
    // if the API failed, weather is set to the latest weather in local storage
    else if (_downloads.isNotEmpty){
      // finds the latest date in local storage
      DateTime highest = DateTime.parse(_downloads[0]['date']);
      int index = 0;
        for (int downloadedWeather = 1; downloadedWeather < _downloads.length; downloadedWeather++){
          if (DateTime.parse(_downloads[0]['date']).compareTo(highest) < 0){
            highest = DateTime.parse(_downloads[0]['date']);
            index = downloadedWeather;
          }
        }
      _date = highest;

      // updates weather
      updateToDownloadedWeather(_downloads[index]['weather']);
      Map<String, Object?> contents = jsonDecode(_downloads[index]['weather']);
      return Weather.fromMap(contents);
    }
    // If you fail to fetch results
    return SnackBar(content: Text("Unsuccessful fetch status code: ${response.statusCode}"));
  }

  /// Load The Weather Information From The API or Downloads
  /// @param url url to load
  /// @return String of the Weather object from local storage or API
  Future<String> getStringDataFromUrl(String url) async{
    var response = await http.get(Uri.parse(url));

    // If successful in fetching results
    if (response.statusCode == 200){
      return response.body;
    }
    // if the API failed, weather is set to the latest weather in local storage
    else if (_downloads.isNotEmpty){
      // finds the latest date in local storage
      DateTime highest = DateTime.parse(_downloads[0]['date']);
      int index = 0;
      for (int downloadedWeather = 1; downloadedWeather < _downloads.length; downloadedWeather++){
        if (DateTime.parse(_downloads[0]['date']).compareTo(highest) < 0){
          highest = DateTime.parse(_downloads[0]['date']);
          index = downloadedWeather;
        }
      }
      _date = highest;

      // updates weather
      updateToDownloadedWeather(_downloads[index]['weather']);
      return _downloads[index]['weather'];
    }
    // If you fail to fetch results
    return "";
  }

  /// takes an integer and returns a two digit form of it. 5 -> 05, 11 -> 11
  /// @param value integer to convert
  /// @return String value of the integer
  String _twoDigits(int value){
    if (value > 9){
      return "$value";
    }
    return "0$value";
  }

  /// takes a DateTime date and returns a String version of it
  /// @param date date to convert
  /// @return String version of date
  String _toDateString(DateTime date){
    return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
  }
}