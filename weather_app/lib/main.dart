import 'package:flutter/material.dart';
import 'package:weather_app/home_page.dart';
import 'package:weather_app/settings_page.dart';

import 'account_page.dart';
import 'more_page.dart';

void main() {
  runApp(const MyApp());
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

  int _selectedIndex = 1;
  final List _pages = [
    const AccountPage(),
    const HomePage(),
    const MorePage(),
    const SettingsPage()
  ];

  String tempUrl = "https://api.open-meteo.com/v1/forecast?"
      "latitude=43.90"
      "&longitude=-78.86"
      "&hourly=temperature_2m,"
      "relativehumidity_2m,"
      "dewpoint_2m,"
      "apparent_temperature,"
      "precipitation,"
      "rain,"
      "snowfall,"
      "snow_depth,"
      "cloudcover,"
      "windspeed_10m,"
      "winddirection_10m,"
      "soil_temperature_0cm,"
      "soil_moisture_0_1cm"
      "&timezone=auto";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        elevation: 3,
      ),
      body: _pages.elementAt(_selectedIndex),
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
}
