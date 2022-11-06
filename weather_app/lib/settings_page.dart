import 'package:flutter/material.dart';
import 'package:weather_app/Settings.dart';
import 'package:weather_app/weather_from_url.dart';

import 'Weather.dart';

// User Selecting Weather Information Stored In Settings Object
// Fetching Information
// Return Weather Info In Weather Object

Settings settings = Settings();   // The current Settings object
Weather? weather;                 // The current Weather object

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  // Everytime you check or uncheck a box update the weather object
  Future generateWeather() async{
    double latitude = 43.90;
    double longitude = -78.86;
    var result = await weatherFromUrl(generateUrl(settings, latitude, longitude));
    if (result.runtimeType == SnackBar){
      ScaffoldMessenger.of(context).showSnackBar(result as SnackBar);
    }
    else{
      weather = result as Weather;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 13,
          itemBuilder: (content, index){
            return Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Checkbox(
                    value: settings.isChecked[index],
                    onChanged: (value){
                      setState(() {
                        settings.isChecked[index] = value!;
                      });
                      generateWeather();
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

