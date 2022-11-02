class Weather{
  double? latitude;
  double? longitude;
  double? generationtime_ms;
  int? utc_offset_seconds;
  String? timezone;
  String? timezone_abbreviation;
  double? elevation;

  // NOTE: We could just add every hourly and daily weather
  //       variable but only provide what is asked, it would
  //       simplify things

  // Everything under Hourly Weather Variables, may provide more
  // fields depending on what you request, I only added Temperature (2m)
  String? time;
  String? temperature;

  // Everything under Daily Weather Variables
  // NOTE: I did not include any in the link I hard coded

  List? times;
  List? temperatures;

  Weather(
      {
        this.latitude,
        this.longitude,
        this.generationtime_ms,
        this.utc_offset_seconds,
        this.timezone,
        this.timezone_abbreviation,
        this.elevation,

        this.time,
        this.temperature,

        this.times,
        this.temperatures
      }
  );

  factory Weather.fromMap(Map map){
    print(map);
    return Weather(
        latitude: map["latitude"],
        longitude: map["longitude"],
        generationtime_ms: map["generationtime_ms"],
        utc_offset_seconds: map["utc_offset_seconds"],
        timezone: map["timezone"],
        timezone_abbreviation: map["timezone_abbreviation"],
        elevation: map["elevation"],

        time: map["hourly_units"]["time"],
        temperature: map["hourly_units"]["temperature_2m"],

        times: map["hourly"]["time"],
        temperatures: map["hourly"]["temperature_2m"]
    );
  }
}