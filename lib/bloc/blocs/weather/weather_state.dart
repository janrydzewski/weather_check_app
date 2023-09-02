part of 'weather_bloc.dart';

class WeatherState extends Equatable{
  final WeatherModel weatherModel;

  WeatherState({WeatherModel? weatherModel})
      : weatherModel = weatherModel ?? WeatherModel();

  WeatherState copyWith({
    WeatherModel? weatherModel,
  }) {
    return WeatherState(
      weatherModel: weatherModel ?? this.weatherModel,
    );
  }

  @override
  List<Object> get props => [weatherModel];
}

class WeatherLoading extends WeatherState {}

class WeatherError extends WeatherState {
  final String message;

  WeatherError({
    WeatherModel? weatherModel,
    required this.message,
  }) : super(
    weatherModel: weatherModel,
  );
}