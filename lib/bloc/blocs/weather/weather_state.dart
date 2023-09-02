part of 'weather_bloc.dart';

class WeatherState extends Equatable{
  final WeatherModel weatherModel;
  final String cityName;

  WeatherState({WeatherModel? weatherModel, String? cityName})
      : weatherModel = weatherModel ?? WeatherModel(), cityName = cityName ?? "";

  WeatherState copyWith({
    WeatherModel? weatherModel,
    String? cityName,
  }) {
    return WeatherState(
      weatherModel: weatherModel ?? this.weatherModel,
      cityName: cityName ?? this.cityName,
    );
  }

  @override
  List<Object> get props => [weatherModel, cityName];
}

class WeatherLoading extends WeatherState {}

class WeatherError extends WeatherState {
  final String message;

  WeatherError({
    WeatherModel? weatherModel,
    String? cityName,
    required this.message,
  }) : super(
    weatherModel: weatherModel,
    cityName: cityName,
  );
}