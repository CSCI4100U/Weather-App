import 'package:flutter/material.dart';
import 'package:weather_app/models/icon_reference.dart';
import 'package:weather_app/views/settings_page.dart';

import '../models/weather_from_url.dart';

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
      body: FutureBuilder(
        future: getWeather(context),
        builder: (context, snapshot) {
          List<Widget> page = _generateHomePage();
          return !snapshot.hasData
            ? const Center(child: CircularProgressIndicator(),)
            : ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },
              itemCount: page.length,
              itemBuilder: (context, index) {
                return page[index];
              }
            );
        }
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getWeather(context).then(
        (value){
          setState(() {
            print("Weather fetched in Home Page.");
          });
          return value;
        }
    );
  }

  // Generates widgets to display on the home page
  _generateHomePage() {
    return [
      // TODO: Get appropriate hourly weather
      // TODO: Stack image of weather type?
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${(
                  weather!.temperatures != null
                ? "${weather!.temperatures![0]}"
                : "??"
            )}°",
            style: const TextStyle(
                fontSize: 80
            ),
          ),
          weather!.weatherCodes != null
          ? IconReference.generateWeatherIcon(
              weather!.weatherCodes![0],
              size: 50,
              color: true,
          )
          : const Icon(Icons.question_mark, size: 50),
        ],
      ),
      Center(child: Text(
          weather!.apparentTemperatures != null
          ? "Feels like ${weather!.apparentTemperatures![0]}°"
          : "Feels like ??°"
      )),
      // TODO: Implement daily high and low
      Center(child: Text("High: 50°      Low: 100°")),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // TODO: Make function that builds hourly forecast
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("5 PM"),
              Icon(Icons.sunny),
              Text("90°"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("6 PM"),
              Icon(Icons.sunny),
              Text("90°"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("7 PM"),
              Icon(Icons.sunny),
              Text("90°"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("8 PM"),
              Icon(Icons.sunny),
              Text("90°"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("9 PM"),
              Icon(Icons.sunny),
              Text("90°"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("10 PM"),
              Icon(Icons.sunny),
              Text("90°"),
            ],
          ),
        ],
      ),
    ];
  }
}