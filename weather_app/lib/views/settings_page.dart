import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/Settings.dart';
import 'package:weather_app/utility/weather_from_url.dart';

import '../models/Weather.dart';

// User Selecting Weather Information Stored In Settings Object
// Fetching Information
// Return Weather Info In Weather Object

Settings settings = Settings();   // The current Settings object
Weather? weather = Weather();     // The current Weather object

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    WeatherBLoC weatherBLoC = context.watch<WeatherBLoC>();
    super.initState();
    weatherBLoC.initializeList().then(
            (value){
          setState(() {
            print("Weather fetched in Settings Page.");
          });
          return value;
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    SettingsBLoC settingsBLoC = context.watch<SettingsBLoC>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        elevation: 3,
      ),
      body: ListView.builder(
          itemCount: 13,
          itemBuilder: (content, index){
            // Each row consists of:
            // 1. A Checkbox to toggle displaying specific weather information
            // 2. A ListTile explaining what the weather information is
            return Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Checkbox(
                    value: settingsBLoC.userSettings[index],
                    onChanged: (value){
                      setState(() {
                        settingsBLoC.userSettings[index] = value!;
                      });
                      settingsBLoC.updateSettings();
                    },
                  ),
                ),
                Expanded(
                    child: ListTile(
                      title: Text(settings.settingNames[index],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(settings.descriptions[index]),
                    )
                )
              ],
            );
          }
      ),
    );
  }
}

