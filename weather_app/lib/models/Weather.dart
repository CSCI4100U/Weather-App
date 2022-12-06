/// A class to store information fetched from the weather API
/// found at https://open-meteo.com/en/docs#api-documentation
class Weather{
  /// Identifying information for the fetch from the API
  double? latitude;
  double? longitude;
  double? generationtime_ms;
  int? utc_offset_seconds;
  String? timezone;
  String? timezone_abbreviation;
  double? elevation;

  /// Units for each category of weather information
  String? timeUnit;
  String? temperatureUnit;
  String? humidityUnit;
  String? dewpointUnit;
  String? apparentTemperatureUnit;
  String? precipitationUnit;
  String? rainUnit;
  String? snowfallUnit;
  String? snowDepthUnit;
  String? weatherCodeUnit;
  String? cloudCoverUnit;
  String? windSpeedUnit;
  String? windDirectionUnit;
  String? soilTemperatureUnit;
  String? soilMoistureUnit;
  String? dailyWeatherCodesUnit;
  String? temperatureMaxUnit;
  String? temperatureMinUnit;

  /// Lists of specific weather information
  List? times;
  List? temperatures;
  List? humidities;
  List? dewpoints;
  List? apparentTemperatures;
  List? precipitations;
  List? rain;
  List? snowfall;
  List? snowDepths;
  List? weatherCodes;
  List? cloudCovers;
  List? windSpeeds;
  List? windDirections;
  List? soilTemperatures;
  List? soilMoistures;
  List? dailyWeatherCodes;
  List? temperatureMaxs;
  List? temperatureMins;

  /// The time this information was fetched
  DateTime? whenCreated = DateTime.now();

  /// Initializer to store information
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
        this.timeUnit = "",    // Always included if anything is selected in hourly
        this.temperatureUnit = "",
        this.humidityUnit = "",
        this.dewpointUnit = "",
        this.apparentTemperatureUnit = "",
        this.precipitationUnit = "",
        this.rainUnit = "",
        this.snowfallUnit = "",
        this.snowDepthUnit = "",
        this.weatherCodeUnit = "",
        this.cloudCoverUnit = "",
        this.windSpeedUnit = "",
        this.windDirectionUnit = "",
        this.soilTemperatureUnit = "",
        this.soilMoistureUnit = "",
        this.dailyWeatherCodesUnit = "",
        this.temperatureMaxUnit = "",
        this.temperatureMinUnit = "",

        // List of Values
        // NOTE:  I set them all to default null to match fromMap
        //        in case you make an object without fromMap
        //        that way any checks for null will still behave the same
        //        if you make a Weather object without fromMap
        this.times = null,   // Always included if anything is selected in hourly
        this.temperatures = null,
        this.humidities = null,
        this.dewpoints = null,
        this.apparentTemperatures = null,
        this.precipitations = null,
        this.rain = null,
        this.snowfall = null,
        this.snowDepths = null,
        this.weatherCodes = null,
        this.cloudCovers = null,
        this.windSpeeds = null,
        this.windDirections = null,
        this.soilTemperatures = null,
        this.soilMoistures = null,
        this.dailyWeatherCodes = null,
        this.temperatureMaxs = null,
        this.temperatureMins = null,

        this.whenCreated,
      }
  );

  /// Creates a weather object from a Map
  /// @param map A Map to generate a weather object from
  /// @return returns a Weather object generated from the provided Map
  factory Weather.fromMap(Map map){
    // IMPORTANT NOTE: If there is no specified value in the map
    //                 for the property you select it will save null
    //
    //                 e.g. I call dewpoints: map["hourly"]["dewpoint_2m"],
    //                      here but there is no dewpoint_2m in the provided
    //                      json file, it will set dewpoints = null

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
        weatherCodeUnit: map["hourly_units"]["weathercode"],
        cloudCoverUnit: map["hourly_units"]["cloudcover"],
        windSpeedUnit: map["hourly_units"]["windspeed_10m"],
        windDirectionUnit: map["hourly_units"]["winddirection_10m"],
        soilTemperatureUnit: map["hourly_units"]["soil_temperature_0cm"],
        soilMoistureUnit: map["hourly_units"]["soil_moisture_0_1cm"],
        dailyWeatherCodesUnit: map["daily_units"]["weathercode"],
        temperatureMaxUnit: map["daily_units"]["temperature_2m_max"],
        temperatureMinUnit: map["daily_units"]["temperature_2m_min"],

        times: map["hourly"]["time"],
        temperatures: map["hourly"]["temperature_2m"],
        humidities: map["hourly"]["relativehumidity_2m"],
        dewpoints: map["hourly"]["dewpoint_2m"],
        apparentTemperatures: map["hourly"]["apparent_temperature"],
        precipitations: map["hourly"]["precipitation"],
        rain: map["hourly"]["rain"],
        snowfall: map["hourly"]["snowfall"],
        snowDepths: map["hourly"]["snow_depth"],
        weatherCodes: map["hourly"]["weathercode"],
        cloudCovers: map["hourly"]["cloudcover"],
        windSpeeds: map["hourly"]["windspeed_10m"],
        windDirections: map["hourly"]["winddirection_10m"],
        soilTemperatures: map["hourly"]["soil_temperature_0cm"],
        soilMoistures: map["hourly"]["soil_moisture_0_1cm"],
        dailyWeatherCodes: map["daily"]["weathercode"],
        temperatureMaxs: map["daily"]["temperature_2m_max"],
        temperatureMins: map["daily"]["temperature_2m_min"],

        // Store when the object was created for updating purposes
        whenCreated: DateTime.now(),
    );
  }

  /// Provides you with the List of the specified weather information
  /// @param index The index of the weather information you would like the List for
  /// @return returns the list of specified weather information
  List getWeatherDetails(int index) {
    List outIfNull = [for (int i=0; i<168; i++) "??"];
    switch (index) {
      case 0:  return temperatures ?? outIfNull;
      case 1:  return humidities ?? outIfNull;
      case 2:  return dewpoints ?? outIfNull;
      case 3:  return apparentTemperatures ?? outIfNull;
      case 4:  return precipitations ?? outIfNull;
      case 5:  return rain ?? outIfNull;
      case 6:  return snowfall ?? outIfNull;
      case 7:  return snowDepths ?? outIfNull;
      case 8:  return cloudCovers ?? outIfNull;
      case 9:  return windSpeeds ?? outIfNull;
      case 10: return windDirections ?? outIfNull;
      case 11: return soilTemperatures ?? outIfNull;
      case 12: return soilMoistures ?? outIfNull;
      default: throw RangeError(
          "Invalid index: $index, valid values range from [0,12]"
      );
    }
  }

  /// Provides the unit of the specified weather information
  /// @param index The index of the weather information you would like the List for
  /// @return returns the unit of the weather information as a String
  String getWeatherUnit(int index) {
    String outIfNull = "";
    switch (index) {
      case 0:  return temperatureUnit ?? outIfNull;
      case 1:  return humidityUnit ?? outIfNull;
      case 2:  return dewpointUnit ?? outIfNull;
      case 3:  return apparentTemperatureUnit ?? outIfNull;
      case 4:  return precipitationUnit ?? outIfNull;
      case 5:  return rainUnit ?? outIfNull;
      case 6:  return snowfallUnit ?? outIfNull;
      case 7:  return snowDepthUnit ?? outIfNull;
      case 8:  return cloudCoverUnit ?? outIfNull;
      case 9:  return windSpeedUnit ?? outIfNull;
      case 10: return windDirectionUnit ?? outIfNull;
      case 11: return soilTemperatureUnit ?? outIfNull;
      case 12: return soilMoistureUnit ?? outIfNull;
      default: throw RangeError(
          "Invalid index: $index, valid values range from [0,12]"
      );
    }
  }
}