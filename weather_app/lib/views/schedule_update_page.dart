import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:weather_app/models/Weather.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:io';
import "package:timezone/data/latest.dart" as tz;
import "package:timezone/timezone.dart" as tz;

import '../models/weather_from_url.dart';

class ScheduleUpdatePage extends StatefulWidget {
  const ScheduleUpdatePage({Key? key}) : super(key: key);

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

  TimeOfDayFormat timeFormat = TimeOfDayFormat.h_colon_mm_space_a;
  TimeOfDay? setTime;
  String notificationType = "Weekly";

  var _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  NotificationDetails? _platformChannelInfo;

  @override
  void initState() {
    super.initState();
    dropdownValue = weekdays[DateTime.now().weekday-1];
    setTime = TimeOfDay.now();
    tz.initializeTimeZones();
    preparePlatformChannelInfo();
  }

  void preparePlatformChannelInfo(){
    if (Platform.isIOS){
      _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation
      <IOSFlutterLocalNotificationsPlugin>()!.requestPermissions(
          alert: false,
          badge: true,
          sound: true
      );
    }

    var initializationSettingsAndroid = AndroidInitializationSettings("mipmap/ic_launcher");
    var initializationSettingsIOS = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload){
        return null;
      },
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    var androidChannelInfo = AndroidNotificationDetails(
        "WeatherUpdate", "Weather Notifications", channelDescription: "The Weather Update Is Set"
    );

    var iosChannelInfo = DarwinNotificationDetails();
    _platformChannelInfo = NotificationDetails(
        android: androidChannelInfo,
        iOS: iosChannelInfo
    );
  }

  Future onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async{
    if (notificationResponse != null){
      print("onDidReceiveNotificationResponse::payload = ${notificationResponse.payload}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              const Text("Select When To Show Daily Weather Updates",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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

  Future scheduleNotification() async{
    // TODO Background Task For Fetching Real Time Weather Information
    // // If Daily Weather Update
    // if (notificationType == "Daily"){
      var information = await weatherFromUrl(
          "${generateUrl(43.90, -78.86)}"
          "&start_date=${DateTime.now().toIso8601String().substring(0, 10)}"
          "&end_date=${DateTime.now().toIso8601String().substring(0, 10)}"
      ).then((information) async{
        if (information.runtimeType == Weather){
          return _flutterLocalNotificationsPlugin.zonedSchedule(
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
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(information as SnackBar);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Scheduled Notification")));
    // }
    // // If Weekly Weather Update
    // else{
    //
    // }
  }
}
