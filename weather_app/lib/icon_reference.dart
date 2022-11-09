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
      int weatherCode,
      {double size = 24.0, Color color = Colors.black}
  ){
    switch (weatherCode) {
      case 0: // Clear sky
        return Icon(Icons.sunny, size: size, color: color);
      case 1:
      case 2:
      case 3: // Partly cloudy
        return Icon(Icons.wb_cloudy, size: size, color: color);
      case 45:
      case 48: // Foggy
        return Icon(Icons.foggy, size: size, color: color);
      case 51:
      case 53:
      case 55: // Drizzle
        return Icon(Icons.water_drop_outlined, size: size, color: color);
      case 61:
      case 63:
      case 65:
      case 66:
      case 67: // Rain
      case 80:
      case 81:
      case 82:
        return Icon(Icons.water_drop, size: size, color: color);
      case 71:
      case 73:
      case 75:
      case 77: // Snow
      case 85:
      case 86:
        return Icon(Icons.snowing, size: size, color: color);
      case 95:
      case 96:
      case 99: // Thunder
        return Icon(Icons.thunderstorm, size: size, color: color);
      default:
        return Icon(Icons.question_mark, size: size, color: color);
    }
  }
}