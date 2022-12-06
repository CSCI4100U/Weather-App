import 'package:flutter/material.dart';

/// A class used to manage common icons
/// and other assets.
class IconReference {
  /// A list of icons that appears on the "more page" that
  /// corresponds to a type of weather data
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
    /// Generates an icon based on the time of day and
    /// current weather condition
    /// @param integer code corresponding to a weather type
    /// @param the hour the weather occurs
    /// @param optional size modifier for bigger icons
    /// @return an Icon which represents the weather

    bool isDay = hour % 24 > 5 && hour % 24 < 18; /// [6AM,5PM]
    switch (weatherCode) {
      case 0: /// Clear sky
        return Icon(
            (isDay ? Icons.sunny : Icons.bedtime),
            size: size,
            color: (isDay ? Colors.orangeAccent : Colors.blueGrey),
            shadows: const [Shadow(
                color: Colors.white,
                offset: Offset.zero,
                blurRadius:40
            )]
        );
      case 1:
      case 2:
      case 3: /// Partly cloudy
        return Icon(
            (isDay ? Icons.wb_cloudy : Icons.nights_stay),
            size: size,
            color: Colors.blueGrey,
            shadows: const [Shadow(
            color: Colors.white,
                offset: Offset.zero,
                blurRadius:40
            )]
        );
      case 45:
      case 48: /// Foggy
        return Icon(
            Icons.foggy,
            size: size,
            color: Colors.blueGrey,
            shadows: const [Shadow(
                color: Colors.white,
                offset: Offset.zero,
                blurRadius:40
            )]
        );
      case 51:
      case 53:
      case 55: /// Drizzle
        return Icon(
            Icons.water_drop_outlined,
            size: size,
            color: Colors.blue,
            shadows: const [Shadow(
                color: Colors.white,
                offset: Offset.zero,
                blurRadius:40
            )]
        );
      case 61:
      case 63:
      case 65:
      case 66:
      case 67: /// Rain
      case 80:
      case 81:
      case 82:
        return Icon(
            Icons.water_drop,
            size: size,
            color: Colors.blue,
            shadows: const [Shadow(
                color: Colors.white,
                offset: Offset.zero,
                blurRadius:40
            )]
        );
      case 71:
      case 73:
      case 75:
      case 77: /// Snow
      case 85:
      case 86:
        return Icon(
            Icons.snowing,
            size: size,
            color: Colors.lightBlueAccent,
            shadows: const [Shadow(
                color: Colors.white,
                offset: Offset.zero,
                blurRadius:40
            )]
        );
      case 95:
      case 96:
      case 99: /// Thunder
        return Icon(
            Icons.electric_bolt,
            size: size,
            color: Colors.yellow,
            shadows: const [Shadow(
                color: Colors.white,
                offset: Offset.zero,
                blurRadius:40
            )]
        );
      default:
        return Icon(
            Icons.question_mark,
            size: size,
            color: Colors.red,
            shadows: const [Shadow(
                color: Colors.white,
                offset: Offset.zero,
                blurRadius:40
            )]
        );
    }
  }

  static AssetImage generateWeatherImage(int weatherCode, int hour) {
    /// Generates a background image based on the time of day
    /// and current weather conditions
    /// @param integer code corresponding to a weather type
    /// @param the hour the weather occurs
    /// @return an AssetImage of the current weather

    bool isDay = hour % 24 > 5 && hour % 24 < 18; // 6AM-5PM
    String filename = "clear-day";
    switch (weatherCode) {
      case 0: /// Clear sky
        filename = (isDay ? "clear-day" : "clear-night"); break;
      case 1:
      case 2:
      case 3: /// Partly cloudy
      case 51:
      case 53:
      case 55: /// Drizzle
        filename = (isDay ? "cloudy-day" : "cloudy-night"); break;
      case 45:
      case 48: /// Foggy
        filename = (isDay ? "foggy-day" : "foggy-night"); break;
      case 61:
      case 63:
      case 65:
      case 66:
      case 67: /// Rain
      case 80:
      case 81:
      case 82:
        filename = (isDay ? "rainy-day" : "rainy-night"); break;
      case 71:
      case 73:
      case 75:
      case 77: /// Snow
      case 85:
      case 86:
        filename = (isDay ? "snowy-day" : "snowy-night"); break;
      case 95:
      case 96:
      case 99: /// Thunder
        filename = "thunder"; break;
    }
    return AssetImage("assets/weather-images/$filename.png");
    /**
    * Image credits:
    * clear-day:        "Sky" by Hannes Thaller on flickr
    * clear-night:      "Starry Sky" by Danny Thompson on flickr
    * cloudy-day:       "Cumulus clouds Montenegro" by Bratislav Tabaš on Wikimedia Commons
    * cloudy-night:     "Cloudy Night Sky" by wildflower1555 on flickr
    * foggy-day:        "Foggy day" by peterdehaan on piqs.de
    * foggy-night:      "Foggy night at the parking lot" by W.carter on Wikimedia Commons
    * rainy-day:        "..rainy days are here again.." by elaine ross baylon on flickr
    * rainy-night:      "Rainy Night" by Denis Dervisevic on flickr
    * snowy-day:        "snowing Lapland" by Heather Sunderland on flickr
    * snowy-night:      "nightfall and snowing" by Tallis Keeton on flickr
    * thunder:          "Storm Flash" by Max Pexel from maxpixel.freegreatpicture.com
    *
    * All images used for this project are a part
    * of the Creative Commons and are permitted for
    * use commercially.
    * */
  }
}