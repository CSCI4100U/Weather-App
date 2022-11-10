import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/Settings.dart';
import 'package:weather_app/models/weather_from_url.dart';

import '../models/Weather.dart';

// User Selecting Weather Information Stored In Settings Object
// Fetching Information
// Return Weather Info In Weather Object

Settings settings = Settings();   // The current Settings object
Weather? weather = Weather();     // The current Weather object

// Everytime you check or uncheck a box update the weather object
Future generateWeather(BuildContext context) async{
  double latitude = 43.90;
  double longitude = -78.86;
  var result = await weatherFromUrl(generateUrl(latitude, longitude));
  if (result.runtimeType == SnackBar){
    ScaffoldMessenger.of(context).showSnackBar(result as SnackBar);
  }
  else{
    weather = result as Weather;
  }
  return weather;
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    super.initState();

    generateWeather(context);
    // TODO Implement Settings and Update Weather
  }

  @override
  Widget build(BuildContext context) {
    SettingsBLoC settingsBLoC = context.watch<SettingsBLoC>();
    return Scaffold(
      body: ListView.builder(
          itemCount: 13,
          itemBuilder: (content, index){
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

