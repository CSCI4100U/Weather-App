import 'package:flutter/material.dart';
import 'package:weather_app/icon_reference.dart';
import 'package:weather_app/settings_page.dart';
import 'package:weather_app/weather_from_url.dart';

import 'Weather.dart';

// TODO
// Average For Each Weather Info
// Display All More Information In Charts, Display Charts on Click
// - Current Temperature
// - Apparent Temperature
// - Dewpoint
// - Precipitation
// - Rainfall
// - Humidity
// - Snowfall
// - Snow Depth
// - Windfall
// - Wind Direction (North is 0 degrees)
// - Cloud Coverage
// - Soil Temperature
// - Soil Moisture

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Text("More"),
      body: FutureBuilder(
          future: getWeather(context),
          builder: (context, snapshot) {
            print("Recieved weather data");
            return snapshot.hasData
            ? ListView.separated(
              itemCount: 13,
              itemBuilder: (content, index) {
                return index != 0 && settings.isChecked[index] == false
                ? Container()
                : Row(
                  children: [
                    Icon(
                      IconReference.moreIcons[index],
                      size: 30,
                    ),
                    Text(
                      settings.settingNames[index],
                      style: const TextStyle(fontSize: 30),
                    ),
                  ],
                );
              }, separatorBuilder: (BuildContext context, int index)
                    =>  index != 0 && settings.isChecked[index] == false
                        ? Container()
                        : const Divider(),
            )
            : const Center(child: CircularProgressIndicator());
          }
      ),
    );
  }
}

