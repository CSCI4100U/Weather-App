class Weather{
  double? latitude;
  double? longitude;
  double? generationtime_ms;
  int? utc_offset_seconds;
  String? timezone;
  String? timezone_abbreviation;
  double? elevation;

  String? timeUnit;
  String? temperatureUnit;
  String? humidityUnit;
  String? dewpointUnit;
  String? apparentTemperatureUnit;
  String? precipitationUnit;
  String? rainUnit;
  String? snowfallUnit;
  String? snowDepthUnit;
  String? cloudCoverUnit;
  String? windSpeedUnit;
  String? windDirectionUnit;
  String? soilTemperatureUnit;
  String? soilMoistureUnit;

  List? times;
  List? temperatures;
  List? humidities;
  List? dewpoints;
  List? apparentTemperatures;
  List? precipitations;
  List? rain;
  List? snowfall;
  List? snowDepths;
  List? cloudCovers;
  List? windSpeeds;
  List? windDirections;
  List? soilTemperatures;
  List? soilMoistures;

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
        this.timeUnit,    // Always included if anything is selected in hourly
        this.temperatureUnit = "",
        this.humidityUnit = "",
        this.dewpointUnit = "",
        this.apparentTemperatureUnit = "",
        this.precipitationUnit = "",
        this.rainUnit = "",
        this.snowfallUnit = "",
        this.snowDepthUnit = "",
        this.cloudCoverUnit = "",
        this.windSpeedUnit = "",
        this.windDirectionUnit = "",
        this.soilTemperatureUnit = "",
        this.soilMoistureUnit = "",

        // List of Values
        // NOTE:  I set them all to default null to match fromMap
        //        in case you make an object without fromMap
        //        that way any checks for null will still behave the same
        //        if you make a Weather object without fromMap
        this.times,   // Always included if anything is selected in hourly
        this.temperatures = null,
        this.humidities = null,
        this.dewpoints = null,
        this.apparentTemperatures = null,
        this.precipitations = null,
        this.rain = null,
        this.snowfall = null,
        this.snowDepths = null,
        this.cloudCovers = null,
        this.windSpeeds = null,
        this.windDirections = null,
        this.soilTemperatures = null,
        this.soilMoistures = null
      }
  );

  factory Weather.fromMap(Map map){
    // IMPORTANT NOTE: If there is no specified value in the map
    //                 for the property you select it will save null
    //
    //                 e.g. I call dewpoints: map["hourly"]["dewpoint_2m"],
    //                      here but there is no dewpoint_2m in the provided
    //                      json file, it will set dewpoints = null

    print(map);
    return Weather(
        latitude: map["latitude"],
        longitude: map["longitude"],
        generationtime_ms: map["generationtime_ms"],
        utc_offset_seconds: map["utc_offset_seconds"],
        timezone: map["timezone"],
        timezone_abbreviation: map["timezone_abbreviation"],
        elevation: map["elevation"],

        timeUnit: map["hourly_units"]["time"],
        temperatureUnit: map["hourly_units"]["temperature_2m"],
        humidityUnit: map["hourly_units"]["relativehumidity_2m"],
        dewpointUnit: map["hourly_units"]["dewpoint_2m"],
        apparentTemperatureUnit: map["hourly_units"]["apparent_temperature"],
        precipitationUnit: map["hourly_units"]["precipitation"],
        rainUnit: map["hourly_units"]["rain"],
        snowfallUnit: map["hourly_units"]["snowfall"],
        snowDepthUnit: map["hourly_units"]["snow_depth"],
        cloudCoverUnit: map["hourly_units"]["cloudcover"],
        windSpeedUnit: map["hourly_units"]["windspeed_10m"],
        windDirectionUnit: map["hourly_units"]["winddirection_10m"],
        soilTemperatureUnit: map["hourly_units"]["soil_temperature_0cm"],
        soilMoistureUnit: map["hourly_units"]["soil_moisture_0_1cm"],

        times: map["hourly"]["time"],
        temperatures: map["hourly"]["temperature_2m"],
        humidities: map["hourly"]["relative_humidity_2m"],
        dewpoints: map["hourly"]["dewpoint_2m"],
        apparentTemperatures: map["hourly"]["apparent_temperature"],
        precipitations: map["hourly"]["precipitation"],
        rain: map["hourly"]["rain"],
        snowfall: map["hourly"]["snowfall"],
        snowDepths: map["hourly"]["snow_depth"],
        cloudCovers: map["hourly"]["cloudcover"],
        windSpeeds: map["hourly"]["windspeed_10m"],
        windDirections: map["hourly"]["winddirection_10m"],
        soilTemperatures: map["hourly"]["soil_temperature_0cm"],
        soilMoistures: map["hourly"]["soil_moisture_0_1cm"]
    );
  }
}