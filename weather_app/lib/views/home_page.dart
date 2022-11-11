import 'dart:math';

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
      // TODO: Stack image of weather type?
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${(
                  weather!.temperatures != null
                ? "${weather!.temperatures! [weather!.whenCreated!.hour]}"
                : "??"
            )}°",
            style: const TextStyle(
                fontSize: 80
            ),
          ),
          weather!.weatherCodes != null
          ? IconReference.generateWeatherIcon(
              weather!.weatherCodes![weather!.whenCreated!.hour],
              weather!.whenCreated!.hour,
              size: 50,
          )
          : const Icon(Icons.question_mark, size: 50),
        ],
      ),
      Center(child: Text(
        weather!.apparentTemperatures != null
        ? "Feels like ${
            weather!.apparentTemperatures![weather!.whenCreated!.hour]
        }°"
        : "Feels like ??°",
        style: const TextStyle(fontSize: 17),
      )),
      // TODO: Implement daily high and low
      Center(child: Text(
        weather!.temperatures != null
        ? "High: ${"50"}°      Low: ${"100"}°"
        : "High: ??°      Low: ??°",
        style: const TextStyle(fontSize: 17),
      )),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SizedBox(
          height: 75,
          child: _generateHourlyForecast(weather!.whenCreated!.hour)
        ),
      ),
    ];
  }

  ListView _generateHourlyForecast(int hour) {
    if (hour == null) hour = 0;
    return ListView.separated(
      itemBuilder: (context, index) {
        int nextHour = hour + index;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (nextHour % 12 == 0
                  ? "${nextHour % 12 + 12}"
                  : "${nextHour % 12}"
              ) + (nextHour % 24 < 12 ? " AM" : " PM"),
              style: const TextStyle(
                  fontSize: 17
              ),
            ),
            IconReference.generateWeatherIcon(
              weather!.weatherCodes?[nextHour],
              nextHour,
              size: 30,
            ),
            Text(
              weather!.temperatures != null
                  ? "${weather!.temperatures![nextHour]}°"
                  : "??°",
              style: const TextStyle(
                  fontSize: 17
              ),
            ),
          ],
        );
      },
      itemCount: 12,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8, width: 40,);
      },
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
    );
  }
}