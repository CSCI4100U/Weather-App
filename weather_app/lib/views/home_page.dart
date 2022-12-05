import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/icon_reference.dart';
import 'package:weather_app/utility/weather_from_url.dart';
import 'package:weather_app/views/weather_preview_map.dart';
import 'weather_download_page.dart';

import '../models/home_page_list.dart';

// Current Weather
// Weather For 6 Hours In Advance

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    WeatherBLoC weatherBLoC = context.watch<WeatherBLoC>();
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "app.title")),
        elevation: 3,
        actions: [
          IconButton(
            onPressed: () async{
              await Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const WeatherPreviewMap())
              );
              setState(() {
              });
            },
            icon: const Icon(Icons.location_on),
            tooltip: FlutterI18n.translate(context, "home.maptooltip"),
          ),
          IconButton(
            onPressed: () async {
              weatherBLoC.initial = true;
              await Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const WeatherDownload())
              );
              setState(() {
              });
            },
            icon: const Icon(Icons.download),
            tooltip: FlutterI18n.translate(context, "home.downloadtooltip"),
          )
        ],
      ),
      body: Stack(
          children: [
            Image(
                image: IconReference.generateWeatherImage(
                  (weatherBLoC.weather != null)
                      ? weatherBLoC.weather!.weatherCodes!
                        [weatherBLoC.weather!.whenCreated!.hour] : 0,
                  (weatherBLoC.weather != null)
                      ? weatherBLoC.weather!.whenCreated!.hour : 12,
                ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white.withOpacity(0.4)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0.67, 0.9],
                  tileMode: TileMode.mirror,
                ),
              ),
            ),
            const HomePageList(),
          ],
      )
    );
  }
}