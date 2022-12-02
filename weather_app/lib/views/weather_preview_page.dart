import "package:flutter/material.dart";
import '../models/Weather.dart';
import '../models/icon_reference.dart';

class WeatherPreviewPage extends StatefulWidget {
  WeatherPreviewPage({Key? key, this.address, this.countryArea, this.weather}) : super(key: key);

  String? address;
  String? countryArea;
  Weather? weather;

  @override
  State<WeatherPreviewPage> createState() => _WeatherPreviewPageState();
}

class _WeatherPreviewPageState extends State<WeatherPreviewPage> {
  String address = "";
  String countryArea = "";
  Weather? weather;

  @override
  void initState() {
    super.initState();
    address = widget.address!;
    countryArea = widget.countryArea!;
    weather = widget.weather!;
  }

  @override
  Widget build(BuildContext context) {
      List<Widget> page = [
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 5),
          child: Text(
            address,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 30
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          countryArea,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 30
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
              )}°",
              style: const TextStyle(
                  fontSize: 80
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
          }°"
              : "Feels like ??°",
          style: const TextStyle(fontSize: 17),
        )),
        // TODO: Implement daily high and low
        Center(child: Text(
          weather!.temperatures != null
              ? "High: ${"50"}°      Low: ${"100"}°"
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
                            ? "${weather!.temperatures![nextHour]}°"
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
      ];

      return Scaffold(
        appBar: AppBar(
          title: const Text("Weather Map"),
        ),
        body: ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemCount: page.length,
            itemBuilder: (context, index) {
              return page[index];
            }
        ),
      );
  }
}
