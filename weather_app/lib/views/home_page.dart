import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/icon_reference.dart';
import 'package:weather_app/views/settings_page.dart';

import '../models/Settings.dart';
import '../models/home_page_list.dart';
import '../utility/weather_from_url.dart';
import 'account_page.dart';

// Current Weather
// Weather For 6 Hours In Advance

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageList? page;
  String? address;

  @override
  Widget build(BuildContext context) {
    SettingsBLoC settingsBLoC = context.watch<SettingsBLoC>();
    AccountPageBLoC accountBLoC = context.watch<AccountPageBLoC>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        elevation: 3,
        actions: [
          IconButton(onPressed: reload, icon: const Icon(Icons.refresh))
        ],
      ),
      body:
        FutureBuilder(
            future: getWeather(context).then(
                (value) {
                  page = const HomePageList();
                  return value;
                }
            ),
            builder: (context, snapshot) {
              return !snapshot.hasData || page == null
                  ? const Center(child: CircularProgressIndicator(),)
                  : page!;
            }
        ),
    );
  }

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    getWeather(context).then(
            (value){
          setState(() {
            print("Weather fetched in Home Page.");
          });
          return value;
        }
    );
  }

  // getAddress() async{
  //   final List<Placemark> places = await placemarkFromCoordinates(latitude, longitude)
  // }
}