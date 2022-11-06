import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Settings.dart';
import 'Weather.dart';

// Make an URL from a Settings object
String generateUrl(Settings settings, double latitude, double longitude){
  String result = "https://api.open-meteo.com/v1/forecast?"
      "latitude=$latitude"
      "&longitude=$longitude";

  if (settings.isChecked[0]){
    result += "&hourly=temperature_2m,";
  }
  if (settings.isChecked[1]){
    result += "relativehumidity_2m,";
  }
  if (settings.isChecked[2]){
    result += "dewpoint_2m,";
  }
  if (settings.isChecked[3]){
    result += "apparent_temperature,";
  }
  if (settings.isChecked[4]){
    result += "precipitation,";
  }
  if (settings.isChecked[5]){
    result += "rain,";
  }
  if (settings.isChecked[6]){
    result += "snowfall,";
  }
  if (settings.isChecked[7]){
    result += "snow_depth,";
  }
  if (settings.isChecked[8]){
    result += "cloudcover,";
  }
  if (settings.isChecked[9]){
    result += "windspeed_10m,";
  }
  if (settings.isChecked[10]){
    result += "winddirection_10m,";
  }
  if (settings.isChecked[11]){
    result += "soil_temperature_0cm,";
  }
  if (settings.isChecked[12]){
    result += "soil_moisture_0_1cm,";
  }

  // The timezone does not have a comma before it
  // if there are any arguments cut out the last comma
  if (result[result.length-1] == ','){
    result = result.substring(0, result.length-1)+"&timezone=auto";
  }
  // Otherwise if it's just the latitude and longitude with no settings
  else{
    result += "&timezone=auto";
  }

  print(result);
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
    print(response.body);
    Map<String, Object?> contents = jsonDecode(response.body);
    weather = Weather.fromMap(contents);
    return weather;
  }
  // If you fail to fetch results
  else{
    return SnackBar(content: Text("Unsuccessful fetch status code: ${response.statusCode}"));
  }
}