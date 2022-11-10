import 'package:flutter/material.dart';
import 'package:weather_app/models/icon_reference.dart';
import 'package:weather_app/views/settings_page.dart';

// TODO
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
    List<Widget> page = _generateHomePage();
    return Scaffold(
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8);
        },
        itemCount: page.length,
        itemBuilder: (context, index) {
          return page[index];
        }
      ),
    );
  }

  _generateHomePage() {
    return [
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
      Center(child: Text("High: 50°      Low: 100°")),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
              Text("5 PM"),
              Icon(Icons.sunny),
              Text("90°"),
            ],
          ),
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
              Text("5 PM"),
              Icon(Icons.sunny),
              Text("90°"),
            ],
          ),
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
              Text("5 PM"),
              Icon(Icons.sunny),
              Text("90°"),
            ],
          ),
        ],
      ),
    ];
  }
}