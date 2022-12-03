import 'package:flutter/material.dart';

class WeatherDownload extends StatefulWidget {
  const WeatherDownload({Key? key}) : super(key: key);

  @override
  State<WeatherDownload> createState() => _WeatherDownloadState();
}

class _WeatherDownloadState extends State<WeatherDownload> {
  DateTime _weatherDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
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
                              firstDate: rightNow,
                              lastDate: DateTime(2100)
                          ).then((value) {
                            setState(() {
                              _weatherDate = DateTime(
                                  value!.year, value.month, value.day, _weatherDate.hour,
                                  _weatherDate.minute
                              );
                            });
                          }
                          );
                        },
                        child: Text(
                          _toDateString(_weatherDate),
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

  String _twoDigits(int value){
    if (value > 9){
      return "$value";
    }
    return "0$value";
  }

  String _toDateString(DateTime date){
    return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
  }
}
