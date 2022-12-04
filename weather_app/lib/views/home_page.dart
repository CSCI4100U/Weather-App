import 'package:flutter/material.dart';
import 'package:weather_app/views/weather_preview_map.dart';
import 'weather_download_page.dart';

import '../models/home_page_list.dart';

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
            onPressed: () async{
              await Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const WeatherPreviewMap())
              );
              setState(() {
              });
            },
            icon: const Icon(Icons.location_on),
            tooltip: "View Another Location's Weather",
          ),
          IconButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const WeatherDownload())
              );
              setState(() {
              });
            },
            icon: const Icon(Icons.download),
            tooltip: "Download And Select Weather From Another Date",
          )
        ],
      ),
      body: const HomePageList()
    );
  }
}