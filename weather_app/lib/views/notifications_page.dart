import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:weather_app/views/create_notification_page.dart';
import 'dart:io';

class ToolsPage extends StatefulWidget {
  const ToolsPage({Key? key}) : super(key: key);

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  var _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  NotificationDetails? _platformChannelInfo;

  // Initializing for flutter notifications
  @override
  void initState() {
    super.initState();

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
  }
  Future onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async{
    if (notificationResponse != null){
      print("onDidReceiveNotificationResponse::payload = ${notificationResponse.payload}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
          // Button to direct you to the weather update page
          ElevatedButton(
            onPressed: () async{
              // Show the weather update page
              await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ScheduleUpdatePage(
                        flutterLocalNotificationsPlugin: _flutterLocalNotificationsPlugin,
                      )
                  )
              );
            },
            child: const Text("Manage Weather Updates")
          ),
      ),
    );
  }
}
