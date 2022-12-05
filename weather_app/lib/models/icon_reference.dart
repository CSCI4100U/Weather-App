import 'package:flutter/material.dart';

class IconReference {
  static final List<IconData> moreIcons = [
    Icons.thermostat_outlined, // temperature
    Icons.water_drop_outlined, // humidity
    Icons.grass, // dew point
    Icons.thermostat_auto, // apparent temp
    Icons.cloudy_snowing, // precipitation
    Icons.water_drop, // rain
    Icons.snowing, // snowfall
    Icons.swipe_down_alt, // snow depth
    Icons.cloud, // cloud cover
    Icons.air, // wind speed
    Icons.emoji_flags, // wind direction
    Icons.device_thermostat, // soil temp
    Icons.water_drop_outlined, // soil humidity
  ];

  static Icon generateWeatherIcon(
      int weatherCode, int hour,
      {double size = 24.0}
  ){
    bool isDay = hour % 24 > 5 && hour % 24 < 18; // 6AM-5PM
    switch (weatherCode) {
      case 0: // Clear sky
        return Icon(
            (isDay ? Icons.sunny : Icons.bedtime),
            size: size,
            color: (isDay ? Colors.orangeAccent : Colors.blueGrey),
        );
      case 1:
      case 2:
      case 3: // Partly cloudy
        return Icon(
            (isDay ? Icons.wb_cloudy : Icons.nights_stay),
            size: size,
            color: Colors.blueGrey
        );
      case 45:
      case 48: // Foggy
        return Icon(
            Icons.foggy,
            size: size,
            color: Colors.blueGrey
        );
      case 51:
      case 53:
      case 55: // Drizzle
        return Icon(
            Icons.water_drop_outlined,
            size: size,
            color: Colors.blue
        );
      case 61:
      case 63:
      case 65:
      case 66:
      case 67: // Rain
      case 80:
      case 81:
      case 82:
        return Icon(
            Icons.water_drop,
            size: size,
            color: Colors.blue
        );
      case 71:
      case 73:
      case 75:
      case 77: // Snow
      case 85:
      case 86:
        return Icon(
            Icons.snowing,
            size: size,
            color: Colors.lightBlueAccent
        );
      case 95:
      case 96:
      case 99: // Thunder
        return Icon(
            Icons.electric_bolt,
            size: size,
            color: Colors.yellow
        );
      default:
        return Icon(
            Icons.question_mark,
            size: size,
            color: Colors.red
        );
    }
  }

  static AssetImage generateWeatherImage(int weatherCode, int hour) {
    bool isDay = hour % 24 > 5 && hour % 24 < 18; // 6AM-5PM
    String filename = "clear-day";
    // switch (weatherCode) {
    //   case 0: // Clear sky
    //     filename = (isDay ? "sunny" : "night"); break;
    //   case 1:
    //   case 2:
    //   case 3: // Partly cloudy
    //   case 51:
    //   case 53:
    //   case 55: // Drizzle
    //     filename = (isDay ? "cloudy day" : "cloudy night"); break;
    //   case 45:
    //   case 48: // Foggy
    //     filename = (isDay ? "foggy day" : "foggy night"); break;
    //   case 61:
    //   case 63:
    //   case 65:
    //   case 66:
    //   case 67: // Rain
    //   case 80:
    //   case 81:
    //   case 82:
    //     filename = (isDay ? "rainy day" : "dream away"); break;
    //   case 71:
    //   case 73:
    //   case 75:
    //   case 77: // Snow
    //   case 85:
    //   case 86:
    //     filename = (isDay ? "snow day" : "snow night"); break;
    //   case 95:
    //   case 96:
    //   case 99: // Thunder
    //     filename = "thunder day"; break;
    // }
    return AssetImage("assets/weather-images/$filename.png");
  }
}