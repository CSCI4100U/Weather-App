import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/icon_reference.dart';
import 'package:weather_app/utility/weather_from_url.dart';
import 'package:weather_app/views/settings_page.dart';

import '../models/Settings.dart';

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
  void initState() {
    super.initState();
    getWeather(context).then(
            (value){
          setState(() {
            print("Weather fetched in More Page.");
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
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  getWeather(context);
                });
              },
              icon: Icon(Icons.refresh),
          )
        ],
        elevation: 3,
      ),
      body: FutureBuilder(
          future: getWeather(context),
          builder: (context, snapshot) {
            return snapshot.hasData
            ? ListView.separated(
              itemCount: 13,
              itemBuilder: (content, index) {
                return settingsBLoC.userSettings[index] == false
                ? Container()
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Icon(
                            IconReference.moreIcons[index],
                            size: 25,
                          ),
                        ),
                        Text(
                          settings.settingNames[index],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                          "${
                              (weather == null) ?
                              "" :
                              weather!.getWeatherDetails(index)
                                [weather!.whenCreated!.hour]
                          }"
                          "${
                              ""
                          }",
                          style: const TextStyle(
                            fontSize: 30
                          ),
                      ),
                    ),
                  ],
                );
              }, separatorBuilder: (BuildContext context, int index)
                    =>  settingsBLoC.userSettings[index] == false
                        ? Container()
                        : const Divider(),
            )
            : const Center(child: CircularProgressIndicator());
          }
      ),
    );
  }
}

