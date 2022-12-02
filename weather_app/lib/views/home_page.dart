import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/views/weather_preview_page.dart';

import '../models/home_page_list.dart';
import '../utility/weather_from_url.dart';

// Current Weather
// Weather For 6 Hours In Advance

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        elevation: 3,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const WeatherPreviewPage())
              );
            },
            icon: Icon(Icons.location_on),
            tooltip: "View Another Location's Weather",
          )
        ],
      ),
      body: const HomePageList()
    );
  }
}