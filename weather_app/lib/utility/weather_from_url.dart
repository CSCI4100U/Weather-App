import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/WeatherModel.dart';
import 'dart:convert';

import '../models/Weather.dart';

// Make an URL from a Settings object
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
  print(result); // Prints the url so you can read the json while debugging
  return result;
}

String _twoDigits(int value){
  if (value > 9){
    return "$value";
  }
  return "0$value";
}

String _toDateString(DateTime date){
  return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
}

// Load The Weather Information From The API
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

/// BLoC used to have access to usernames, passwords, and settings quickly,
///   across all pages
class WeatherBLoC with ChangeNotifier{
  Weather? _weather;
  String _sWeather = "";
  Position? currentPosition;
  String _address = "Loading Address";
  String countryArea = "";
  bool changedPosition = false;
  bool changedDate = true;
  DateTime _date = DateTime.now();
  List _downloads = [];
  int? _selectedIndex;
  bool initial = true;

  get weather => _weather;
  get date => _date;
  get sDate => _toDateString(_date);
  get downloads => _downloads;
  get sWeather => _sWeather;
  get selectedIndex => _selectedIndex;
  get address => _address;

  set date(value){
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

  WeatherBLoC(){
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best
      ),
    ).listen(updatePosition);

    initializeList();
    initializeDownloads();
  }

  updatePosition(Position newPosition){
    if (currentPosition == null){
      print(newPosition);
      print(currentPosition);
      currentPosition = newPosition;
      changedPosition = true;
      updateAddress();
      generateWeather();
      notifyListeners();
    }
    // else if (currentPosition!.latitude != newPosition.latitude &&
    //     currentPosition!.longitude != newPosition.longitude &&
    //     changedPosition == false && changedDate == true){
    //   print(newPosition);
    //   print(currentPosition);
    //   _address = "";
    //   countryArea = "";
    //   currentPosition = newPosition;
    //   changedPosition = true;
    //   updateAddress();
    //   generateWeather();
    //   notifyListeners();
    // }
  }

  updateAddress() async{
    final List<Placemark> places = await placemarkFromCoordinates(
        currentPosition!.latitude,
        currentPosition!.longitude
    );
    if (address != "${places[0].subThoroughfare} ${places[0].thoroughfare}") {
        address = "${places[0].subThoroughfare} ${places[0].thoroughfare}";
        countryArea = "${places[0].administrativeArea} ${places[0].isoCountryCode}";
        //   // getWeather(context);
    }
  }

  updateToDownloadedWeather(String data) async{
    Map<String, Object?> contents = jsonDecode(data);
    _weather = Weather.fromMap(contents);
    _sWeather = data;
    final placemark = await placemarkFromCoordinates(_weather!.latitude!, _weather!.longitude!);
    _address = "${placemark[0].subThoroughfare} "
        "${placemark[0].thoroughfare}";
    countryArea = "${placemark[0].administrativeArea} "
        "${placemark[0].isoCountryCode}";
    notifyListeners();
  }

  Future initializeList() async{
    // If the weather object is already up to date and not empty
    if (
      _weather != null
        && _weather!.whenCreated != null
        && DateTime.now().difference(_weather!.whenCreated!).inHours <= 0
    ) {
      print('Fetching old weather object...');
    } else {
      print('Generating new weather object...');
      _weather = await generateWeather();
    }
    return _weather;
  }

  Future initializeDownloads() async{
    _downloads = await WeatherModel().getDownloads();
    if (_downloads.isEmpty) generateWeather(true);
    notifyListeners();
  }

  Future generateWeather([bool? rightNow]) async{
    if (rightNow == true) _date == DateTime.now();
    if ((changedPosition || changedDate) && currentPosition != null){
      changedPosition = false;
      changedDate = false;
      _weather = await loadContent(generateUrl(currentPosition!.latitude, currentPosition!.longitude, _date));
      _sWeather = await getStringDataFromUrl(generateUrl(currentPosition!.latitude, currentPosition!.longitude, _date), _downloads);

      notifyListeners();
      return _weather;
    }
  }

  // Load The Weather Information From The API or Downloads
  Future loadContent(String url) async{
    var response = await http.get(Uri.parse(url));

    // If successful in fetching results
    if (response.statusCode == 200){
      String data = response.body;
      Map<String, Object?> contents = jsonDecode(data);
      _weather = Weather.fromMap(contents);
      return _weather;
    }
    else if (_downloads.isNotEmpty){
      DateTime highest = DateTime.parse(_downloads[0]['date']);
      int index = 0;
        for (int downloadedWeather = 1; downloadedWeather < _downloads.length; downloadedWeather++){
          if (DateTime.parse(_downloads[0]['date']).compareTo(highest) < 0){
            highest = DateTime.parse(_downloads[0]['date']);
            index = downloadedWeather;
          }
        }
      _date = highest;
      updateToDownloadedWeather(_downloads[index]['weather']);
      Map<String, Object?> contents = jsonDecode(_downloads[index]['weather']);
      return Weather.fromMap(contents);
    }
    // If you fail to fetch results
    else{
      return SnackBar(content: Text("Unsuccessful fetch status code: ${response.statusCode}"));
    }
  }

  Future<String> getStringDataFromUrl(String url, List downloads) async{
    var response = await http.get(Uri.parse(url));

    // If successful in fetching results
    if (response.statusCode == 200){
      return response.body;
    }
    else if (_downloads.isNotEmpty){
      DateTime highest = DateTime.parse(_downloads[0]['date']);
      int index = 0;
      for (int downloadedWeather = 1; downloadedWeather < _downloads.length; downloadedWeather++){
        if (DateTime.parse(_downloads[0]['date']).compareTo(highest) < 0){
          highest = DateTime.parse(_downloads[0]['date']);
          index = downloadedWeather;
        }
      }
      _date = highest;
      updateToDownloadedWeather(_downloads[index]['weather']);
      return _downloads[index]['weather'];
    }
    return "";
  }

  String _twoDigits(int value){
    if (value > 9){
      return "$value";
    }
    return "0$value";
  }

  String _toDateString(DateTime date){
    return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
  }
}