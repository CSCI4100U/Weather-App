import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:weather_app/models/Settings.dart';
import 'package:weather_app/views/create_notification_page.dart';
import 'views/account_page.dart';
import 'views/home_page.dart';
import 'views/more_page.dart';
import 'views/settings_page.dart';

const taskName = "taskName";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (value) => SettingsBLoC()),
          ChangeNotifierProvider(create: (value) => AccountPageBLoC()),
        ],
        child: const MyApp(),
      )
  );
}

class NoPermission extends StatelessWidget {
  const NoPermission({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // The default page to be opened on startup
  int _selectedIndex = 1;

  // All the pages associated with the NavigationBar
  final List _pages = [
    const AccountPage(),
    const HomePage(),
    const MorePage(),
    const SettingsPage(),
    ScheduleUpdatePage()
  ];

  bool allowed = false;

  checkPermissions() async{
    Geolocator.checkPermission().then(
            (LocationPermission locationPermission) => {
              if (locationPermission == LocationPermission.deniedForever || locationPermission == LocationPermission.denied){
                  Geolocator.requestPermission().then(
                      (value) => Geolocator.checkPermission().then(
                          (LocationPermission permission) {
                            print(permission);
                            if (permission != LocationPermission.deniedForever && permission != LocationPermission.denied){
                              setState(() {
                                allowed = true;
                              });
                            }
                          }
                      )
                  )
              }
            }
    );
  }

  // @override
  // void initState() {
  //   checkPermissions();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    checkPermissions();
    if (allowed){
      return Scaffold(
        // appBar: AppBar(
        //   title: const Text("Weather App"),
        //   elevation: 3,
        // ),
        body: _pages.elementAt(_selectedIndex),
        // NavigationBar to switch between pages
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                label: "Account",
                icon: Icon(Icons.person)),
            BottomNavigationBarItem(
                label: "Home",
                icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                label: "More",
                icon: Icon(Icons.list)),
            BottomNavigationBarItem(
                label: "Settings",
                icon: Icon(Icons.settings)),
            BottomNavigationBarItem(
                label: "Notifs",
                icon: Icon(Icons.notifications)),
          ],
          currentIndex: _selectedIndex,
          onTap: (index){
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      );
    }
    else{
      // setState(() {
      //   checkPermissions();
      // });
      return const Center(
        child: Text("Location Service Disabled",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40,
            color: Colors.red
          ),
        ),
      );
    }
  }
}
