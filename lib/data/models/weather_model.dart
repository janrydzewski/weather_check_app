class WeatherModel {
  double? latitude;
  double? longitude;
  double? generationtimeMs;
  int? utcOffsetSeconds;
  String? timezone;
  String? timezoneAbbreviation;
  double? elevation;
  HourlyUnits? hourlyUnits;
  Hourly? hourly;

  WeatherModel(
      {this.latitude,
      this.longitude,
      this.generationtimeMs,
      this.utcOffsetSeconds,
      this.timezone,
      this.timezoneAbbreviation,
      this.elevation,
      this.hourlyUnits,
      this.hourly});

  WeatherModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    generationtimeMs = json['generationtime_ms'];
    utcOffsetSeconds = json['utc_offset_seconds'];
    timezone = json['timezone'];
    timezoneAbbreviation = json['timezone_abbreviation'];
    elevation = json['elevation'];
    hourlyUnits = json['hourly_units'] != null
        ? HourlyUnits.fromJson(json['hourly_units'])
        : null;
    hourly = json['hourly'] != null ? Hourly.fromJson(json['hourly']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['generationtime_ms'] = generationtimeMs;
    data['utc_offset_seconds'] = utcOffsetSeconds;
    data['timezone'] = timezone;
    data['timezone_abbreviation'] = timezoneAbbreviation;
    data['elevation'] = elevation;
    if (hourlyUnits != null) {
      data['hourly_units'] = hourlyUnits!.toJson();
    }
    if (hourly != null) {
      data['hourly'] = hourly!.toJson();
    }
    return data;
  }
}

class HourlyUnits {
  String? time;
  String? temperature2m;
  String? precipitationProbability;
  String? weathercode;
  String? pressureMsl;
  String? relativehumidity2m;
  String? windspeed10m;

  HourlyUnits(
      {this.time,
      this.temperature2m,
      this.precipitationProbability,
      this.weathercode,
      this.pressureMsl,
      this.relativehumidity2m,
      this.windspeed10m});

  HourlyUnits.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    temperature2m = json['temperature_2m'];
    precipitationProbability = json['precipitation_probability'];
    weathercode = json['weathercode'];
    pressureMsl = json['pressure_msl'];
    relativehumidity2m = json['relativehumidity_2m'];
    windspeed10m = json['windspeed_10m'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['temperature_2m'] = temperature2m;
    data['precipitation_probability'] = precipitationProbability;
    data['weathercode'] = weathercode;
    data['pressure_msl'] = pressureMsl;
    data['relativehumidity_2m'] = relativehumidity2m;
    data['windspeed_10m'] = windspeed10m;
    return data;
  }
}

class Hourly {
  List<String>? time;
  List<double>? temperature2m;
  List<int>? precipitationProbability;
  List<int>? weathercode;
  List<double>? pressureMsl;
  List<int>? relativehumidity2m;
  List<double>? windspeed10m;

  Hourly(
      {this.time,
      this.temperature2m,
      this.precipitationProbability,
      this.weathercode,
      this.pressureMsl,
      this.relativehumidity2m,
      this.windspeed10m});

  Hourly.fromJson(Map<String, dynamic> json) {
    time = json['time'].cast<String>();
    temperature2m = json['temperature_2m'].cast<double>();
    precipitationProbability = json['precipitation_probability'].cast<int>();
    weathercode = json['weathercode'].cast<int>();
    pressureMsl = json['pressure_msl'].cast<double>();
    relativehumidity2m = json['relativehumidity_2m'].cast<int>();
    windspeed10m = json['windspeed_10m'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['temperature_2m'] = temperature2m;
    data['precipitation_probability'] = precipitationProbability;
    data['weathercode'] = weathercode;
    data['pressure_msl'] = pressureMsl;
    data['relativehumidity_2m'] = relativehumidity2m;
    data['windspeed_10m'] = windspeed10m;
    return data;
  }
}
