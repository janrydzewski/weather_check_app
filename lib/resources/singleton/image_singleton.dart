import 'dart:ui';

class WeatherIconSingleton {
  static WeatherIconSingleton? _instance;
  Image? cloud;
  Image? night;
  Image? rain;
  Image? storm;
  Image? sun;

  WeatherIconSingleton._();

  static WeatherIconSingleton get instance {
    _instance ??= WeatherIconSingleton._();
    return _instance!;
  }
}