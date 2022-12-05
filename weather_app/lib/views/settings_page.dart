import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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
  List<String> languages = ["en", "fr", "es"];
  String selectedLanguage = "en";

  @override
  Widget build(BuildContext context) {
    SettingsBLoC settingsBLoC = context.watch<SettingsBLoC>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, "app.title")
        ),
        elevation: 3,
        actions: [
          DropdownButton(
              value: selectedLanguage,
              items: languages.map(
                      (language) {
                        return DropdownMenuItem(
                            value: language,
                            child: Text(
                                language.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                            )
                        );
                      }
              ).toList(),
              onChanged: (selection) async{
                Locale newLocale = Locale(selection!);
                await FlutterI18n.refresh(context, newLocale);
                setState(() {
                  selectedLanguage = selection!;
                });
              }
          )
        ],
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
                      title: Text(
                        FlutterI18n.translate(context, "settings.${settings.settingNames[index]}"),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          FlutterI18n.translate(context, "settings.${settings.descriptions[index]}")
                    ),
                    )
                )
              ],
            );
          }
      ),
    );
  }
}

