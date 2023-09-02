import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_check/data/models/models.dart';
import 'package:weather_check/repositories/repositories.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherBloc({required this.weatherRepository}) : super(WeatherState()) {
    on<GetWeatherEvent>(_onGetWeatherEvent);
  }

  _onGetWeatherEvent(GetWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try{
      final weatherModel = await weatherRepository.getWeather(event.city);
      emit(state.copyWith(weatherModel: weatherModel));
    }
    catch(e){
      emit(WeatherError(message: "Error fetching data"));
    }
  }
}
