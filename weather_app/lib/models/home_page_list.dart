import 'package:flutter/material.dart';
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

  String address = "Loading Address";
  String countryArea = "";
  String temperatureUnit = "C";

  @override
  Widget build(BuildContext context) {
    WeatherBLoC weatherBLoC = context.watch<WeatherBLoC>();
    weather = weatherBLoC.weather;
    address = weatherBLoC.address;
    countryArea = weatherBLoC.countryArea;

    List<Widget> page = [
      // TODO: Stack image of weather type?
      Padding(
          padding: const EdgeInsets.only(top: 10, right: 5),
          child: Text(
            address,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 25
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ),
      Text(
        countryArea,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 25
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${(
                weather!.temperatures != null
                    ? "${weather!.temperatures! [weather!.whenCreated!.hour]}"
                    : "??"
            )}°$temperatureUnit",
            style: const TextStyle(
                fontSize: 70
            ),
          ),
          weather!.weatherCodes != null
              ? IconReference.generateWeatherIcon(
                  weather!.weatherCodes![weather!.whenCreated!.hour],
                  weather!.whenCreated!.hour,
                  size: 50,
                )
              : const Icon(Icons.question_mark, size: 50),
        ],
      ),
      Center(child: Text(
        weather!.apparentTemperatures != null
            ? "Feels like ${
            weather!.apparentTemperatures![weather!.whenCreated!.hour]
        }°$temperatureUnit"
            : "Feels like ??°",
        style: const TextStyle(fontSize: 17),
      )),
      // TODO: Implement daily high and low
      Center(child: Text(
        weather!.temperatures != null
            ? "High: ${weather!.temperatureMaxs![0]}°$temperatureUnit      "
            "Low: ${weather!.temperatureMins![0]}°$temperatureUnit"
            : "High: ??°      Low: ??°",
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
                      weather!.temperatures != null
                          ? "${weather!.temperatures![nextHour]}°$temperatureUnit"
                          : "??°",
                      style: const TextStyle(
                          fontSize: 17
                      ),
                    ),
                  ],
                );
              },
              itemCount: 12,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8, width: 40,);
              },
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
            )
        ),
      ),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
          child: SizedBox(
            height: 500,
            width: 400,
            child: ListView.separated(
              itemBuilder: (context, index){
                int weekday = DateTime.now().weekday+index;
                if (weekday > 7){
                  weekday -= 7;
                }
                return Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    index == 0 ?
                    const SizedBox(
                        width: 80,
                        child: Text(
                          "Today\t",
                          style: TextStyle(
                              fontSize: 25
                          ),
                        )
                    ) :
                    SizedBox(
                      width: 80,
                      child: Text(
                        "${weekdayDecoder(weekday)}\t",
                        style: const TextStyle(
                            fontSize: 25
                        ),
                      ),
                    ),
                    IconReference.generateWeatherIcon(
                        weather!.dailyWeatherCodes![index],
                        12,
                        size: 35
                    ),
                    Text(
                      weather!.temperatureMins![index] > 0 ?
                      "   ${weather!.temperatureMins![index]}° " :
                      "  ${weather!.temperatureMins![index]}° ",
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.grey
                      ),
                    ),
                    Text(
                      weather!.temperatureMaxs![index] > 0 ?
                      "|  ${weather!.temperatureMaxs![index]}°" :
                      "| ${weather!.temperatureMaxs![index]}°",
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
          return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      default:
        return "Sun";
    }
  }
}
