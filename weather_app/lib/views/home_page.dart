import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/home_page_list.dart';
import '../utility/weather_from_url.dart';

// Current Weather
// Weather For 6 Hours In Advance

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageList? page = const HomePageList();
  String? address;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        elevation: 3,
      ),
      body:
        FutureBuilder(
            // future: getWeather(context).then(
            //     (value) {
            //       page = const HomePageList();
            //       return value;
            //     }
            future: reload(),
            builder: (context, snapshot) {
              return !snapshot.hasData || page == null
                  ? const Center(child: CircularProgressIndicator(),)
                  : page!;
            }
        ),
    );
  }
}