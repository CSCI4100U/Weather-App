import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/Weather.dart';
import "package:timezone/data/latest.dart" as tz;
import 'dart:io';
import 'package:provider/provider.dart';
import '../utility/weather_from_url.dart';

class ScheduleUpdatePage extends StatefulWidget {
  ScheduleUpdatePage({Key? key,}) : super(key: key);

  // FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  @override
  State<ScheduleUpdatePage> createState() => _ScheduleUpdatePageState();
}

class _ScheduleUpdatePageState extends State<ScheduleUpdatePage> {

  // Setting TimeOfDay to display in h:mm format
  TimeOfDayFormat timeFormat = TimeOfDayFormat.h_colon_mm_space_a;
  TimeOfDay? displayTime;

  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;
  // static NotificationDetails? _platformChannelInfo;

  // Variable initializations
  @override
  void initState() {
    super.initState();
    displayTime = TimeOfDay.now();
    // _flutterLocalNotificationsPlugin = widget.flutterLocalNotificationsPlugin;
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    WeatherBLoC weatherBLoC = context.watch<WeatherBLoC>();
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "app.title")),
        actions: [
          // Button to cancel ongoing weather updates
          IconButton(
              tooltip: FlutterI18n.translate(context, "notifications.canceltooltip"),
              onPressed: (){
                AndroidAlarmManager.cancel(0);
                _flutterLocalNotificationsPlugin!.cancelAll();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(FlutterI18n.translate(context, "notifications.cancelsnackbar"))
                    )
                );
              },
              icon: const Icon(Icons.stop)
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Container(
                padding: const EdgeInsets.all(5),
                child:Text(
                  FlutterI18n.translate(context, "notifications.scheduleprompt"),
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
                  // Button to select the time of your weather update
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 140,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 3)
                      ),
                      onPressed: () {
                        setState(() {
                          updateTime();
                        });
                      },
                      child: Text(
                        displayTime!.format(context),
                        style: const TextStyle(
                            fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
            ),

            // Spacer
            Padding(
              padding: const EdgeInsets.only(top: 100),
              // Button to schedule a notification at the selected time
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10)
                  ),
                  onPressed: () async{
                    DateTime now = DateTime.now();
                    print(displayTime!);

                    DateTime startTime;
                    // If it's the end of the year set it for next year
                    if (now.month == 12 && now.day == 31){
                      startTime = DateTime(
                          now.year+1,
                          1,
                          1,
                          displayTime!.hour,
                          displayTime!.minute
                      );
                    }
                    // Otherwise
                    else{
                      startTime = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          displayTime!.hour,
                          displayTime!.minute
                      );
                    }

                    await AndroidAlarmManager.cancel(0);
                    await AndroidAlarmManager.periodic(
                        const Duration(days: 1),
                        0,
                        scheduleNotification,
                        startAt: startTime,
                        allowWhileIdle: true,
                        exact: true,
                        // wakeup: true,
                        // rescheduleOnReboot: true
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(FlutterI18n.translate(context, "notifications.schedulesnackbar"))
                        )
                    );
                  },
                  child: Text(
                    FlutterI18n.translate(context, "notifications.schedule"),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                    ),
                  )
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
                child: Text(
                  FlutterI18n.translate(context, "notifications.disclaimer"),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20
                  ),
                  textAlign: TextAlign.center,
                ),
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
        initialTime: displayTime!
    );
    if (result != null){
      setState(() {
        displayTime = result;
      });
    }
  }

  static Future onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async{
    print("Setting up notifications");
    if (notificationResponse != null){
      print("onDidReceiveNotificationResponse::payload = ${notificationResponse.payload}");
    }
  }

  // Function to schedule a daily notification at the set time
  static Future scheduleNotification() async{
    // NOTE: Any variables declared outside of this function need to be reinitialized
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    NotificationDetails? platformChannelInfo;

    print("Setting Up Notification");
    if (Platform.isIOS){
      _flutterLocalNotificationsPlugin!.resolvePlatformSpecificImplementation
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

    _flutterLocalNotificationsPlugin!.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    var androidChannelInfo = AndroidNotificationDetails(
        "WeatherUpdate", "Weather Notifications", channelDescription: "The Weather Update Is Set"
    );

    var iosChannelInfo = DarwinNotificationDetails();
    platformChannelInfo = NotificationDetails(
        android: androidChannelInfo,
        iOS: iosChannelInfo
    );

    // Timezones also need to be reinitialized
    tz.initializeTimeZones();

    print("Scheduling Notification");
    // Fetch the weather information
    await Geolocator.getCurrentPosition().then(
            (Position currentPosition) async {
              var information = await loadContent(
                  "${generateUrl(currentPosition.latitude, currentPosition.longitude, DateTime.now())}"
                  "&start_date=${DateTime.now().toIso8601String().substring(0, 10)}"
                  "&end_date=${DateTime.now().toIso8601String().substring(0, 10)}"
              ).then((information) async{
                // If there is no error fetching
                if (information.runtimeType == Weather){
                  _flutterLocalNotificationsPlugin!.show(
                    0,
                    "Weather Update",
                    "${(information as Weather).temperatures![DateTime.now().hour].toString()}°C Now",
                    platformChannelInfo
                  );
                }
                // If an error occurred
                else{
                  print("Information Error Occurred");
                }
              });
            }
    );
  }
}
