import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Weather.dart';

class ListWeather extends StatefulWidget {
  const ListWeather({Key? key}) : super(key: key);

  @override
  State<ListWeather> createState() => _ListWeatherState();
}

class _ListWeatherState extends State<ListWeather> {
  // This is the url to the website itself
  String baseUrl = "https://open-meteo.com/en/docs#api-documentation";

  String url = "https://api.open-meteo.com/v1/forecast?"
      "latitude=43.84&longitude=-79.31"
      "&hourly=temperature_2m"
      "&timezone=auto"
      "&start_date=2022-11-02"
      "&end_date=2022-11-03";

  Weather? weather;

  // On creation of ListWeather Widget
  @override
  void initState(){
    super.initState();

    // Get the
    loadContent(url);
  }

  //
  Future loadContent(String url) async{
    var response = await http.get(Uri.parse(url));

    // If successful in fetching results
    if (response.statusCode == 200){
      setState(() {
        print(response.body);
        Map<String, Object?> contents = jsonDecode(response.body);
        weather = Weather.fromMap(contents);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (weather == null){
      return CircularProgressIndicator();
    }
    return ListView.builder(
        itemBuilder: (context, index){
          return ListTile(
              title: Text("${weather!.times![index]}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${weather!.temperatures![index]}",
                style: TextStyle(fontSize: 20),
              )
          );
        }
    );
  }
}
