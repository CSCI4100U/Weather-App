import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../utility/weather_from_url.dart';
import '../models/WeatherModel.dart';

class WeatherDownload extends StatefulWidget {
  const WeatherDownload({Key? key}) : super(key: key);

  @override
  State<WeatherDownload> createState() => _WeatherDownloadState();
}

class _WeatherDownloadState extends State<WeatherDownload> {
  @override
  Widget build(BuildContext context) {
    WeatherBLoC weatherBLoC = context.watch<WeatherBLoC>();
    DateTime rightNow = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "app.title")),
        actions: [
          /// Button to set weather to the phone's current date and position
          IconButton(
              tooltip: FlutterI18n.translate(context, "download.resettooltip"),
              onPressed: () async{
                setState(() {
                  // unselects a box if it is selected
                  weatherBLoC.selectedIndex = null;

                  // set the date to the current date/time
                  weatherBLoC.date = rightNow;
                  weatherBLoC.currentPosition = null;
                  weatherBLoC.changedPosition = false;

                  // get the current position of the phone
                  Geolocator.getCurrentPosition();

                  // generate a new weather for the WeatherBLoC
                  weatherBLoC.generateWeather();
                });
              },
              icon: const Icon(Icons.undo)
          ),
          /// Button to delete the selected downloaded weather
          IconButton(
              tooltip: FlutterI18n.translate(context, "download.deletetooltip"),
              onPressed: () async{
                // removes the downloaded weather from local storage
                await WeatherModel().removeWeather(weatherBLoC.sWeather);
                setState(() {
                  // unselects a box if it is selected
                  weatherBLoC.selectedIndex = null;

                  // refreshes the list of downloaded weather in the WeatherBLoC
                  weatherBLoC.initializeDownloads();
                });
              },
              icon: const Icon(Icons.delete)
          )
        ],
      ),
      /// body of the downloads page
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    FlutterI18n.translate(context, "download.selectdateprompt"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Button to select the date for the weather data
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 200,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(width: 3)
                        ),
                        // when pressed, opens a date picker for the user to select a date
                        onPressed: (){
                          weatherBLoC.initial = false;
                          showDatePicker(context: context,
                              initialDate: rightNow,
                              firstDate: DateTime(
                                  rightNow.year,
                                  rightNow.month - 5,
                                  rightNow.day
                              ),
                              lastDate: rightNow,
                          ).then((value) {
                            // if the user selected a date
                            if (value != null) {
                              // set the date in WeatherBLoC to what the user picked
                                weatherBLoC.date = DateTime(
                                    value.year, value.month, value.day
                                );

                                // unselects a box if it is selected
                                weatherBLoC.selectedIndex = null;
                                setState(() {
                                  // generate a new weather for the WeatherBLoC
                                  weatherBLoC.generateWeather();
                                });
                            }
                          }
                          );
                        },
                        // once a user has selected a date, the box will show the date
                        child: (weatherBLoC.initial == false) ? Text(
                          weatherBLoC.sDate,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ) : Text(
                          FlutterI18n.translate(context, "download.selectdate"),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    /// Button to download weather for the selected date
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      // Button to schedule a notification at the selected time
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10)
                          ),
                          onPressed: () async{
                            // add the weather to local storage
                            await WeatherModel().addWeather(weatherBLoC.sDate, weatherBLoC.sWeather, weatherBLoC);
                            setState(() {
                              // unselects a box if it is selected
                              weatherBLoC.selectedIndex = null;

                              // refreshes the list of downloaded weather in the WeatherBLoC
                              weatherBLoC.initializeDownloads();
                            });
                          },
                          child: Text(
                            FlutterI18n.translate(context, "download.download"),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30
                            ),
                          )
                      ),
                    ),
                  ],
                ),
                Text(
                    FlutterI18n.translate(context, "download.downloadlabel"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                ),
                /// ListView of all downloaded weather
                Container(
                  padding: const EdgeInsets.all(25),
                  height: 500,
                  child: ListView.builder(
                      padding: const EdgeInsets.only(top: 15),
                      itemCount: weatherBLoC.downloads.length,
                      itemBuilder: (context, index){
                        return listBuilder(weatherBLoC.downloads[index], index, weatherBLoC);
                      }
                  ),
                )
              ]
          )
      ),
    );
  }
  Widget listBuilder(var weather, int index, WeatherBLoC weatherBLoC){
    return GestureDetector(
      onTap: () {
        setState(() {
          // when a list item is selected, highlight it and set its value as the weather in WeatherBLoC
          weatherBLoC.selectedIndex = index;
          weatherBLoC.date = DateTime.parse(weather['date']);
          weatherBLoC.updateToDownloadedWeather(weather['weather']);
        });
      },
      // if this is selected, colour it blue, otherwise colour it grey
      child: Container(
        decoration: BoxDecoration(
            color: (weatherBLoC.selectedIndex == index) ? Colors.blue : Colors.black12
        ),
        child: ListTile(
          // date
          title: Text(weather['date'],
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
          // address
          subtitle: Text(weather['addr'],
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
