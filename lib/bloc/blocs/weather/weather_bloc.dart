import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_check/data/models/models.dart';
import 'package:weather_check/repositories/repositories.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  final LocationRepository locationRepository;

  WeatherBloc(
      {required this.weatherRepository, required this.locationRepository})
      : super(WeatherState()) {
    on<GetWeatherEvent>(_onGetWeatherEvent);
    on<GetUserLocationEvent>(_onGetUserLocationEvent);
    on<SearchUserLocationEvent>(_onSearchUserLocationEvent);
  }

  _onGetWeatherEvent(GetWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final weatherModel = await weatherRepository.getWeather(event.city);
      final dateTime = DateTime.now().toUtc().add(
            Duration(seconds: weatherModel.utcOffsetSeconds!),
          );
      final weatherCode = weatherRepository.getWeatherCode(
          weatherModel.hourly!.weathercode![dateTime.hour], dateTime);

      emit(state.copyWith(
          weatherModel: weatherModel,
          cityName: event.city,
          weatherCode: weatherCode));
    } catch (e) {
      emit(WeatherError(message: "Error fetching data"));
    }
  }

  _onGetUserLocationEvent(
      GetUserLocationEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final userPosition = await locationRepository.getCurrentPosition();
      final address = await placemarkFromCoordinates(
          userPosition!.latitude, userPosition.longitude);
      final weatherModel =
          await weatherRepository.getWeather(address[0].locality!);
      final dateTime = DateTime.now().toUtc().add(
            Duration(seconds: weatherModel.utcOffsetSeconds!),
          );
      final weatherCode = weatherRepository.getWeatherCode(
          weatherModel.hourly!.weathercode![dateTime.hour], dateTime);

      emit(state.copyWith(
          weatherModel: weatherModel,
          cityName: address[0].locality!,
          weatherCode: weatherCode));
    } catch (e) {
      emit(WeatherError(message: "Error getting user location"));
    }
  }

  _onSearchUserLocationEvent(
      SearchUserLocationEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final inputLocation =
          await locationRepository.getSearchingLocation(event.address);
      final address = await placemarkFromCoordinates(
          inputLocation!.latitude, inputLocation.longitude);
      final weatherModel =
          await weatherRepository.getWeather(address[0].locality!);
      final dateTime = DateTime.now().toUtc().add(
            Duration(seconds: weatherModel.utcOffsetSeconds!),
          );
      final weatherCode = weatherRepository.getWeatherCode(
          weatherModel.hourly!.weathercode![dateTime.hour], dateTime);

      emit(state.copyWith(
          weatherModel: weatherModel,
          cityName: address[0].locality,
          weatherCode: weatherCode));
    } catch (e) {
      emit(WeatherError(message: "Error fetching data"));
    }
  }
}
