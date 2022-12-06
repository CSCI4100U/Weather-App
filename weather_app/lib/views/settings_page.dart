import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/Settings.dart';

import '../models/Weather.dart';

Settings settings = Settings();   // The current Settings object
Weather? weather = Weather();     // The current Weather object

/// The Settings Page where you can toggle what to show in the More Page
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<String> languages = ["en", "fr", "es"];
  String? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    selectedLanguage = FlutterI18n.currentLocale(context)!.languageCode;
    SettingsBLoC settingsBLoC = context.watch<SettingsBLoC>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, "app.title")
        ),
        elevation: 3,
        /// The Language DropdownButton in the AppBar
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
                await FlutterI18n.refresh(context, newLocale).then(
                        (value) {
                          setState(() {
                            selectedLanguage = selection!;
                          });
                        }
                );
              }
          )
        ],
      ),
      /// The ListView explaining what each of the settings is
      /// Each row consists of:
      ///  1. A Checkbox to toggle displaying specific weather information
      ///  2. A ListTile explaining what the weather information is
      body: ListView.builder(
          itemCount: 13,
          itemBuilder: (content, index){
            return Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Checkbox(
                    value: settingsBLoC.userSettings[index],
                    onChanged: (value) async{
                      settingsBLoC.userSettings[index] = value!;
                      await settingsBLoC.updateSettings();
                      setState(() {
                      });
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

