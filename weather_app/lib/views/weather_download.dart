import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utility/weather_from_url.dart';

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
        title: const Text("Weather App"),
        actions: [
          // Button to cancel ongoing weather updates
          IconButton(
              tooltip: "Delete all downloaded weather",
              onPressed: (){
                //TODO delete all downloaded weather
              },
              icon: const Icon(Icons.delete)
          )
        ],
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text("Download Weather For:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Button to select the time of your weather update
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 200,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(width: 3)
                        ),
                        onPressed: (){
                          showDatePicker(context: context,
                              initialDate: rightNow,
                              firstDate: DateTime(
                                  rightNow.year,
                                  rightNow.month - 5,
                                  rightNow.day
                              ),
                              lastDate: rightNow,
                          ).then((value) {
                            if (value != null) {
                                weatherBLoC.date = DateTime(
                                    value.year, value.month, value.day
                                );
                                setState(() {
                                  weatherBLoC.generateWeather();
                                });
                            }
                          }
                          );
                        },
                        child: Text(
                          weatherBLoC.sDate,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      // Button to schedule a notification at the selected time
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10)
                          ),
                          onPressed: () {
                            // TODO Download the weather for the selected date
                          },
                          child: const Text("Download",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ]
          )
      ),
    );
  }
}
