import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:weather_app/models/Settings.dart';
import 'package:weather_app/utility/weather_from_url.dart';
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
          ChangeNotifierProvider(create: (value) => WeatherBLoC())
        ],
        child: const MyApp(),
      )
  );
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
      localizationsDelegates: [
        FlutterI18nDelegate(
            missingTranslationHandler: (key, locale){
              print("MISSING KEY: $key, Language Code: ${locale!.languageCode}");
            },
            translationLoader: FileTranslationLoader(
                useCountryCode: false,
                fallbackFile: "en",
                basePath: "assets/i18n"
            )
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [
        Locale("en", ""),
        Locale("fr", ""),
        Locale("es", "")
      ],
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
            (LocationPermission locationPermission) {
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
                  );
              }
              else{
                setState(() {
                  allowed = true;
                });
              }
            }
    );
  }

  @override
  Widget build(BuildContext context) {
    checkPermissions();
    if (!allowed){
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
    AccountPageBLoC accountBLoC = context.watch<AccountPageBLoC>();
    SettingsBLoC settingsBLoC = context.watch<SettingsBLoC>();
    WeatherBLoC weatherBLoC = context.watch<WeatherBLoC>();
    if (weatherBLoC.weather != null){
      return Scaffold(
        body: _pages.elementAt(_selectedIndex),
        // NavigationBar to switch between pages
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                label: FlutterI18n.translate(context, "app.account"),
                icon: const Icon(Icons.person)),
            BottomNavigationBarItem(
                label: FlutterI18n.translate(context, "app.home"),
                icon: const Icon(Icons.home)),
            BottomNavigationBarItem(
                label: FlutterI18n.translate(context, "app.more"),
                icon: const Icon(Icons.list)),
            BottomNavigationBarItem(
                label: FlutterI18n.translate(context, "app.settings"),
                icon: const Icon(Icons.settings)),
            BottomNavigationBarItem(
                label: FlutterI18n.translate(context, "app.notifications"),
                icon: const Icon(Icons.notifications)),
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
      return const Center(
        child: Text("Loading App",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 40,
              color: Colors.green
          ),
        ),
      );
    }
  }
}
