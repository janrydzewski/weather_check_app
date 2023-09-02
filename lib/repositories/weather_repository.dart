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
        "https://api.open-meteo.com/v1/forecast?latitude=${cityModel?.latitude}&longitude=${cityModel?.longitude}&hourly=temperature_2m,precipitation_probability,weathercode,pressure_msl,visibility,windspeed_10m&timezone=Europe%2FBerlin&forecast_days=2");
    final weatherModel = WeatherModel.fromJson(weatherResponse.data);
    print(weatherResponse);
    return weatherModel;
  }
}
