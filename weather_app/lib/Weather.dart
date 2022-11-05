class Weather{
  double? latitude;
  double? longitude;
  double? generationtime_ms;
  int? utc_offset_seconds;
  String? timezone;
  String? timezone_abbreviation;
  double? elevation;

  String? time;
  String? temperature;

  List? times;
  List? temperatures;

  Weather(
      {
        // Information on Location, Time, etc
        this.latitude,
        this.longitude,
        this.generationtime_ms,
        this.utc_offset_seconds,
        this.timezone,
        this.timezone_abbreviation,
        this.elevation,

        // Units of Values
        this.time,        // iso...
        this.temperature, // Unit of Temperature

        // List of Values
        this.times,       // List of Times and Dates
        this.temperatures // Temperatures
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