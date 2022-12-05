import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/utility/weather_from_url.dart';

import '../views/settings_page.dart';
import 'icon_reference.dart';

class HomePageList extends StatefulWidget {
  const HomePageList({Key? key}) : super(key: key);

  @override
  State<HomePageList> createState() => _HomePageListState();
}

class _HomePageListState extends State<HomePageList> {

  String temperatureUnit = "C";
  final List<bool> _selectedUnit = <bool>[true, false];

  Shadow shadow = const Shadow(
      color: Colors.white,
      offset: Offset.zero,
      blurRadius:40
  );

  @override
  Widget build(BuildContext context) {
    WeatherBLoC weatherBLoC = context.watch<WeatherBLoC>();
    weather = weatherBLoC.weather;

    List<Widget> page = [
      // TODO WEATHER IMAGES
      Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            weatherBLoC.countryArea,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25,
                shadows: [shadow]
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ),
      Text(
        weatherBLoC.sDate,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20,
          shadows: [shadow]
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${(
                weather!.temperatures != null ?
                temperatureUnit == "C" ?
                  "${weather!.temperatures! [weather!.whenCreated!.hour]}" :
                  "${celsiusToFahrenheit(weather!.temperatures! [weather!.whenCreated!.hour])}"
                    :
                "??"
            )}°$temperatureUnit",
            style: TextStyle(
                fontSize: 70,
              fontWeight: FontWeight.w500,
                shadows: [shadow]
            ),
          ),
          weather!.weatherCodes != null
              ? IconReference.generateWeatherIcon(
                  weather!.weatherCodes![weather!.whenCreated!.hour],
                  weather!.whenCreated!.hour,
                  size: 50,
                )
              : Icon(Icons.question_mark, size: 50, shadows: [shadow],),
        ],
      ),
      Center(child: Text(
        weather!.apparentTemperatures != null ?
        temperatureUnit == "C" ?
          "${FlutterI18n.translate(context, "home.apparenttemperature")} ${
              weather!.apparentTemperatures![weather!.whenCreated!.hour]
          }°$temperatureUnit"
            :
          "${FlutterI18n.translate(context, "home.apparenttemperature")} ${
              celsiusToFahrenheit(weather!.apparentTemperatures![weather!.whenCreated!.hour])
          }°$temperatureUnit"
        :
        "${FlutterI18n.translate(context, "home.apparenttemperature")} ??°",
        style: const TextStyle(fontSize: 17),
      )),
      Center(child: Text(
        temperatureUnit == "C" ?
            // Celsius
        weather!.temperatures != null
            ? "${FlutterI18n.translate(context, "home.high")}: ${weather!.temperatureMaxs![0]}°$temperatureUnit      "
            "${FlutterI18n.translate(context, "home.low")}: ${weather!.temperatureMins![0]}°$temperatureUnit" :
            "${FlutterI18n.translate(context, "home.high")}: ??°      ${FlutterI18n.translate(context, "home.low")}: ??°"
            :
            // Fahrenheit
        weather!.temperatures != null
            ? "${FlutterI18n.translate(context, "home.high")}: ${celsiusToFahrenheit(weather!.temperatureMaxs![0])}°$temperatureUnit      "
            "${FlutterI18n.translate(context, "home.low")}: ${celsiusToFahrenheit(weather!.temperatureMins![0])}°$temperatureUnit" :
            "${FlutterI18n.translate(context, "home.high")}: ??°      ${FlutterI18n.translate(context, "home.low")}: ??°",
        style: const TextStyle(fontSize: 17),
      )),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SizedBox(
            height: 75,
            child: ListView.separated(
              itemBuilder: (context, index) {
                int nextHour = weather!.whenCreated!.hour + index;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (nextHour % 12 == 0
                          ? "${nextHour % 12 + 12}"
                          : "${nextHour % 12}"
                      ) + (nextHour % 24 < 12 ? " AM" : " PM"),
                      style: const TextStyle(
                          fontSize: 17
                      ),
                    ),
                    IconReference.generateWeatherIcon(
                      weather!.weatherCodes?[nextHour],
                      nextHour,
                      size: 30,
                    ),
                    Text(
                      weather!.temperatures != null ?
                      temperatureUnit == "C" ?
                        "${weather!.temperatures![nextHour]}°$temperatureUnit"
                        :
                        "${celsiusToFahrenheit(weather!.temperatures![nextHour])}°$temperatureUnit"
                      :
                      "??°",
                      style: const TextStyle(
                          fontSize: 17
                      ),
                    ),
                  ],
                );
              },
              itemCount: 12,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8, width: 30,);
              },
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
            )
        ),
      ),
      SizedBox(
        height: 250,
        width: 460,
        child:
            ListView.separated(
              itemBuilder: (context, index){
                int weekday = weatherBLoC.date.weekday+index;
                if (weatherBLoC.date == null) {
                  weekday = DateTime.now().weekday+index;
                }
                if (weekday > 7){
                  weekday -= 7;
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    index == 0 ?
                    SizedBox(
                        width: 80,
                        child: Text(
                          "${FlutterI18n.translate(context, "home.today")}\t",
                          style: const TextStyle(
                              fontSize: 20
                          ),
                        )
                    ) :
                    SizedBox(
                      width: 80,
                      child: Text(
                        "${weekdayDecoder(weekday)}\t",
                        style: const TextStyle(
                            fontSize: 22
                        ),
                      ),
                    ),
                    IconReference.generateWeatherIcon(
                        weather!.dailyWeatherCodes![index],
                        12,
                        size: 25
                    ),
                    Text(
                      temperatureUnit == "C" ?
                      weather!.temperatureMins![index] > 0 ?
                          // Celsius
                      "   ${weather!.temperatureMins![index]}°$temperatureUnit " :
                      "  ${weather!.temperatureMins![index]}°$temperatureUnit "
                          :
                          // Fahrenheit
                      celsiusToFahrenheit(weather!.temperatureMins![index]) > 0 ?
                      "   ${celsiusToFahrenheit(weather!.temperatureMins![index])}°$temperatureUnit " :
                      "  ${celsiusToFahrenheit(weather!.temperatureMins![index])}°$temperatureUnit ",
                      style: const TextStyle(
                          fontSize: 22,
                          color: Colors.grey
                      ),
                    ),
                    Text(
                      temperatureUnit == "C" ?
                          //Celsius
                      weather!.temperatureMaxs![index] > 0 ?
                      "|  ${weather!.temperatureMaxs![index]}°$temperatureUnit" :
                      "| ${weather!.temperatureMaxs![index]}°$temperatureUnit"
                      :
                          // Fahrenheit
                      weather!.temperatureMaxs![index] > 0 ?
                      "|  ${celsiusToFahrenheit(weather!.temperatureMaxs![index])}°$temperatureUnit" :
                      "| ${celsiusToFahrenheit(weather!.temperatureMaxs![index])}°$temperatureUnit",
                      style: const TextStyle(
                          fontSize: 25
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8, width: 40,);
              },
              itemCount: 7,
              scrollDirection: Axis.vertical,
            ),
      ),
      Center(
        child: ToggleButtons(
            isSelected: _selectedUnit,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.cyan,
            selectedColor: Colors.white,
            fillColor: Colors.cyan,
            color: Colors.cyan,
            onPressed: (int index){
              if (_selectedUnit[index] != true){
                if (temperatureUnit == "C"){
                  temperatureUnit = "F";
                }
                else{
                  temperatureUnit = "C";
                }
                for (int i = 0; i < _selectedUnit.length; i++){
                  setState(() {
                    _selectedUnit[i] = !_selectedUnit[i];
                  });
                }
              }
            },
            children: const [
              Text("°C"),
              Text("°F")
            ],
        ),
      )
    ];


    return ListView.separated(
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8);
        },
        itemCount: page.length,
        itemBuilder: (context, index) {
          return page[index];
        }
    );
  }

  String weekdayDecoder(int weekdayNum){
    switch(weekdayNum){
      case 1:
          return FlutterI18n.translate(context, "home.monday");
      case 2:
        return FlutterI18n.translate(context, "home.tuesday");
      case 3:
        return FlutterI18n.translate(context, "home.wednesday");
      case 4:
        return FlutterI18n.translate(context, "home.thursday");
      case 5:
        return FlutterI18n.translate(context, "home.friday");
      case 6:
        return FlutterI18n.translate(context, "home.saturday");
      default:
        return FlutterI18n.translate(context, "home.sunday");
    }
  }

  double celsiusToFahrenheit(double celsius){
    return double.parse((celsius*1.8+32).toStringAsFixed(1));
  }
}
