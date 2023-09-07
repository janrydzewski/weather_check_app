part of 'weather_bloc.dart';

class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class GetWeatherEvent extends WeatherEvent {
  final String city;

  const GetWeatherEvent(this.city);

  @override
  List<Object> get props => [city];
}

class GetUserLocationEvent extends WeatherEvent {
  const GetUserLocationEvent();

  @override
  List<Object> get props => [];
}

class SearchUserLocationEvent extends WeatherEvent {
  final String address;
  const SearchUserLocationEvent(this.address);

  @override
  List<Object> get props => [address];
}