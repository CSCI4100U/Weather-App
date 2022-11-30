import 'package:flutter/material.dart';
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

// Returns the weather object and generates a new Weather if necessary
Future getWeather(context) async {
  // If the weather object is already up to date and not empty
  //print(weather!.whenCreated!.difference(DateTime.now()).inHours);
  if (
    weather != null
    && weather!.whenCreated != null
    && DateTime.now().difference(weather!.whenCreated!).inHours <= 0
  ) {
    print('Fetching old weather object...');
    return Future.value(weather!);
  // If the weather object needs to be regenerated
  } else {
    print('Generating new weather object...');
    return generateWeather(context);
  }
}