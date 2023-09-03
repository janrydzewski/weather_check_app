part of 'weather_bloc.dart';

class WeatherState extends Equatable{
  final WeatherModel weatherModel;
  final String cityName;
  final String weatherCode;

  WeatherState({WeatherModel? weatherModel, String? cityName, String? weatherCode})
      : weatherModel = weatherModel ?? WeatherModel(), cityName = cityName ?? "", weatherCode = weatherCode ?? "cloud";

  WeatherState copyWith({
    WeatherModel? weatherModel,
    String? cityName,
    String? weatherCode,
  }) {
    return WeatherState(
      weatherModel: weatherModel ?? this.weatherModel,
      cityName: cityName ?? this.cityName,
      weatherCode: weatherCode ?? this.weatherCode,
    );
  }

  @override
  List<Object> get props => [weatherModel, cityName, weatherCode];
}

class WeatherLoading extends WeatherState {}

class WeatherError extends WeatherState {
  final String message;

  WeatherError({
    WeatherModel? weatherModel,
    String? cityName,
    String? weatherCode,
    required this.message,
  }) : super(
    weatherModel: weatherModel,
    cityName: cityName,
    weatherCode: weatherCode,
  );
}