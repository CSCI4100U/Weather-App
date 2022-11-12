import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:weather_app/models/Weather.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:io';
import "package:timezone/data/latest.dart" as tz;
import "package:timezone/timezone.dart" as tz;

import '../models/weather_from_url.dart';

class ScheduleUpdatePage extends StatefulWidget {
  ScheduleUpdatePage({Key? key, this.flutterLocalNotificationsPlugin, this.platformChannelInfo}) : super(key: key);

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  NotificationDetails? platformChannelInfo;

  @override
  State<ScheduleUpdatePage> createState() => _ScheduleUpdatePageState();
}

class _ScheduleUpdatePageState extends State<ScheduleUpdatePage> {
  List<String> weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  String? dropdownValue;

  // Setting TimeOfDay to display in h:mm format
  TimeOfDayFormat timeFormat = TimeOfDayFormat.h_colon_mm_space_a;
  TimeOfDay? setTime;
  // String notificationType = "Weekly";

  var _flutterLocalNotificationsPlugin;
  NotificationDetails? _platformChannelInfo;

  // Variable initializations
  @override
  void initState() {
    super.initState();
    dropdownValue = weekdays[DateTime.now().weekday-1];
    setTime = TimeOfDay.now();
    _flutterLocalNotificationsPlugin = widget.flutterLocalNotificationsPlugin;
    _platformChannelInfo = widget.platformChannelInfo;
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        actions: [
          // Button to cancel ongoing weather updates
          IconButton(
              tooltip: "Cancel All Ongoing Weather Updates",
              onPressed: (){
                _flutterLocalNotificationsPlugin.cancelAll();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Cancelled Ongoing Notifications")
                    )
                );
              },
              icon: Icon(Icons.stop)
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: const Text("Schedule A Periodic Weather Update Every",
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
                    padding: EdgeInsets.all(10),
                    width: 140,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 3)
                      ),
                      onPressed: () {
                        setState(() {
                          updateTime();
                        });
                      },
                      child: Text(
                        "${setTime!.format(context)}",
                        style: const TextStyle(
                            fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  // DropdownButton(
                  //   value: dropdownValue,
                  //   items: weekdays.map(
                  //           (String weekday){
                  //         return DropdownMenuItem(
                  //             value: weekday,
                  //             child: Text(weekday,
                  //               style: const TextStyle(
                  //                   fontSize: 20,
                  //               ),
                  //             )
                  //         );
                  //       }
                  //   ).toList(),
                  //   onChanged: (String? value) {
                  //     setState(() {
                  //       dropdownValue = value;
                  //     });
                  //   },
                  // )
                ],
            ),

            // Spacer
            const Padding(
              padding: EdgeInsets.only(top: 100),
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     SizedBox(
            //       width: 140,
            //       child: RadioListTile(
            //           title: const Text("Weekly",
            //             style: TextStyle(
            //                 fontWeight: FontWeight.bold
            //             ),
            //           ),
            //           value: "Weekly",
            //           groupValue: notificationType,
            //           onChanged: (value){
            //             setState(() {
            //               notificationType = value!;
            //             });
            //           }
            //       ),
            //     ),
            //     SizedBox(
            //       width: 130,
            //       child: RadioListTile(
            //           title: const Text("Daily",
            //             style: TextStyle(
            //                 fontWeight: FontWeight.bold
            //             ),
            //           ),
            //           value: "Daily",
            //           groupValue: notificationType,
            //           onChanged: (value){
            //             setState(() {
            //               notificationType = value!;
            //             });
            //           }
            //       ),
            //     )
            //   ],
            // ),

            // Button to schedule a notification at the selected time
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10)
                ),
                onPressed: scheduleNotification,
                child: const Text("Schedule",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30
                  ),
                )
            )
          ]
        )
      ),
    );
  }

  // The picker that shows up when you select the time of your weather update
  Future updateTime() async{
    TimeOfDay? result = await showTimePicker(
        context: context,
        initialTime: setTime!
    );
    if (result != null){
      setState(() {
        setTime = result;
      });
    }
  }

  // Function to schedule a daily notification at the set time
  Future scheduleNotification() async{
    // TODO Background Task For Fetching Real Time Weather Information
    // // If Daily Weather Update
    // if (notificationType == "Daily"){
      try {
        // Fetch the weather information
        var information = await weatherFromUrl(
            "${generateUrl(43.90, -78.86)}"
            "&start_date=${DateTime.now().toIso8601String().substring(0, 10)}"
            "&end_date=${DateTime.now().toIso8601String().substring(0, 10)}"
        ).then((information) async{
          // If there is no error fetching
          if (information.runtimeType == Weather){
            _flutterLocalNotificationsPlugin.zonedSchedule(
              0,
              "Weather Update",
              " It's ${(information as Weather).temperatures![0].toString()}°C Right Now",
              tz.TZDateTime(
                  tz.getLocation("Canada/Eastern"),
                  tz.TZDateTime.now(tz.getLocation("Canada/Eastern")).year,
                  tz.TZDateTime.now(tz.getLocation("Canada/Eastern")).month,
                  tz.TZDateTime.now(tz.getLocation("Canada/Eastern")).day,
                  setTime!.hour,
                  setTime!.minute
              ),
              _platformChannelInfo!,
              androidAllowWhileIdle: true,
              matchDateTimeComponents: DateTimeComponents.time,
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            );
            Navigator.pop(context, "Scheduled Notification");
          }
          // If an error occured
          else{
            Navigator.pop(context, "An Error Occured Scheduling Your Notification");
          }
        });
      } catch (e) {
        Navigator.pop(context, "An Error Occured Scheduling Your Notification");
      }
    // }
    // // If Weekly Weather Update
    // else{
    //
    // }
  }
}
