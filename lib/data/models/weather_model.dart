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
        ? new HourlyUnits.fromJson(json['hourly_units'])
        : null;
    hourly =
        json['hourly'] != null ? new Hourly.fromJson(json['hourly']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['generationtime_ms'] = this.generationtimeMs;
    data['utc_offset_seconds'] = this.utcOffsetSeconds;
    data['timezone'] = this.timezone;
    data['timezone_abbreviation'] = this.timezoneAbbreviation;
    data['elevation'] = this.elevation;
    if (this.hourlyUnits != null) {
      data['hourly_units'] = this.hourlyUnits!.toJson();
    }
    if (this.hourly != null) {
      data['hourly'] = this.hourly!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['temperature_2m'] = this.temperature2m;
    data['precipitation_probability'] = this.precipitationProbability;
    data['weathercode'] = this.weathercode;
    data['pressure_msl'] = this.pressureMsl;
    data['relativehumidity_2m'] = this.relativehumidity2m;
    data['windspeed_10m'] = this.windspeed10m;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['temperature_2m'] = this.temperature2m;
    data['precipitation_probability'] = this.precipitationProbability;
    data['weathercode'] = this.weathercode;
    data['pressure_msl'] = this.pressureMsl;
    data['relativehumidity_2m'] = this.relativehumidity2m;
    data['windspeed_10m'] = this.windspeed10m;
    return data;
  }
}
