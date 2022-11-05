import 'Weather.dart';

Weather weatherFromUrl(String url){
  // TODO
  // Make A Weather Object From An URL
  String url = "https://api.open-meteo.com/v1/forecast?"
      "latitude=43.90"
      "&longitude=-78.86"
      "&hourly=temperature_2m,"
      "relativehumidity_2m,"
      "dewpoint_2m,"
      "apparent_temperature,"
      "precipitation,"
      "rain,"
      "snowfall,"
      "snow_depth,"
      "cloudcover,"
      "windspeed_10m,"
      "winddirection_10m,"
      "soil_temperature_0cm,"
      "soil_moisture_0_1cm"
      "&timezone=auto";

  return Weather();
}