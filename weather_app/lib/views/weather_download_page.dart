import 'package:flutter/material.dart';
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
        title: const Text("Weather App"),
        actions: [
          // Button to cancel ongoing weather updates
          IconButton(
              tooltip: "Delete selected downloaded weather",
              onPressed: () async{
                await WeatherModel().removeWeather(weatherBLoC.sDate);
                setState(() {
                  weatherBLoC.selectedIndex = null;
                  weatherBLoC.initializeDownloads();
                });
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
                  child: const Text("Select Day For Weather:",
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
                          onPressed: () async{
                            await WeatherModel().addWeather(weatherBLoC.sDate, weatherBLoC.sWeather);
                            setState(() {
                              weatherBLoC.selectedIndex = null;
                              weatherBLoC.initializeDownloads();
                            });
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
                const Text("Downloaded Weather:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                ),
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
          weatherBLoC.selectedIndex = index;
          weatherBLoC.date = DateTime.parse(weather['date']);
          weatherBLoC.updateToDownloadedWeather(weather['weather']);
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: (weatherBLoC.selectedIndex == index) ? Colors.blue : Colors.black12
        ),
        child: ListTile(
          title: Text(weather['date'],
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
