import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../views/settings_page.dart';
import '../models/Weather.dart';

// Make an URL from a Settings object
String generateUrl(double latitude, double longitude){
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
      "&daily=temperature_2m_max,"
      "temperature_2m_min"
      "&timezone=auto";
  print(result); // Prints the url so you can read the json while debugging
  return result;
}

// Make A Weather Object From An URL
Future weatherFromUrl(String url) async{
  return await loadContent(url);
}

// Fetch The Weather Information From The API
Future loadContent(String url) async{
  Weather? weather;

  var response = await http.get(Uri.parse(url));

  // If successful in fetching results
  if (response.statusCode == 200){
    Map<String, Object?> contents = jsonDecode(response.body);
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
  Position? _currentPosition;
  String address = "Loading Address";
  bool changedPosition = false;

  get weather => _weather;

  WeatherBLoC(){

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best
      ),
    ).listen(updatePosition);
    initializeList();
  }

  updatePosition(Position newPosition){
    if (_currentPosition == null){
      print(newPosition);
      print(_currentPosition);
      _currentPosition = newPosition;
      changedPosition = true;
      updateAddress();
      generateWeather();
      notifyListeners();
    }
    else if (_currentPosition!.latitude != newPosition.latitude &&
        _currentPosition!.longitude != newPosition.longitude &&
        changedPosition == false){
      print(newPosition);
      print(_currentPosition);
      _currentPosition = newPosition;
      changedPosition = true;
      updateAddress();
      generateWeather();
      notifyListeners();
    }
  }

  updateAddress() async{
    final List<Placemark> places = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude
    );
    if (address != "${places[0].subThoroughfare} ${places[0].thoroughfare}") {
        address = "${places[0].subThoroughfare} ${places[0].thoroughfare}";
        //   // getWeather(context);
    }
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
      print("Generated");
    }
    return _weather;
  }

  Future generateWeather() async{ //BuildContext context) async{
    // Geolocator.getCurrentPosition().then(
    //         (Position currentPosition) async {
    if (changedPosition){
      changedPosition = false;
      var result = await weatherFromUrl(generateUrl(_currentPosition!.latitude, _currentPosition!.longitude));

      // If an error occured fetching the weather then display it as a snackbar
      if (result.runtimeType == SnackBar){
        // ScaffoldMessenger.of(context).showSnackBar(result as SnackBar);
      }
      // Otherwise
      else{
        _weather = result as Weather;
      }
      notifyListeners();
      return weather;
    }
        // }
    // );
  }
}