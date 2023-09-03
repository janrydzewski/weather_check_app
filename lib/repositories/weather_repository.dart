import 'package:dio/dio.dart';
import 'package:weather_check/data/models/models.dart';

class WeatherRepository {
  const WeatherRepository();

  Future<WeatherModel> getWeather(String city) async {
    final dio = Dio();

    final responseCity = await dio.get(
        "https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1");
    final cityModel = CityModel.fromJson(responseCity.data).results?.first;
    final weatherResponse = await dio.get(
        "https://api.open-meteo.com/v1/forecast?latitude=${cityModel?.latitude}&longitude=${cityModel?.longitude}&hourly=temperature_2m,precipitation_probability,weathercode,pressure_msl,relativehumidity_2m,windspeed_10m&timezone=auto&forecast_days=2");
    final weatherModel = WeatherModel.fromJson(weatherResponse.data);

    return weatherModel;
  }

  String getWeatherCode(int code, DateTime dateTime) {
    if(dateTime.hour >= 22 || dateTime.hour <=6){
      return "night";
    }
    switch (code) {
      case 0:
        return "sun";
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
        return "cloud";
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return "snow";
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
      case 96:
      case 99:
        return "rain";
      default:
        return "cloud";
    }
  }
}
