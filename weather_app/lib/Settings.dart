class Settings{
  // Names of each setting
  List<String> settingNames = [
    "Temperature",
    "Humidity",
    "Dewpoint",
    "Apparent Temperature",
    "Precipitation",
    "Rain",
    "Snowfall",
    "Snow Depth",
    "Cloud Cover",
    "Wind Speed",
    "Wind Direction",
    "Soil Temperature",
    "Soil Moisture"
  ];

  // Descriptions for each setting
  List<String> descriptions = [
    "Show the hourly temperature (°C)",
    "Show the hourly humidity (%)",
    "Show the hourly dewpoint (%)",
    "Show what it \"Feels Like\" with rain, windchill, etc each hour (°C)",
    "Show the hourly precipitation(includes rain, snowfall and showers) (mm)",
    "Show the hourly rain (mm)",
    "Show the hourly snowfall (mm)",
    "Show the hourly snow depth (m)",
    "Show the hourly cloud coverage (%)",
    "Show the hourly wind speed (km/h)",
    "Show the hourly wind direction (°, with North as 0°)",
    "Show the hourly soil temperature (°)",
    "Show the hourly soil moisture (m³/m³)"
  ];

  // Whether each setting is checked off
  List<bool> isChecked = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  Settings({booleans = const []}){
    if (booleans.length == 13){
      for (int index = 0; index < booleans.length; index++){
        isChecked[index] = booleans[index];
      }
    }
  }
}