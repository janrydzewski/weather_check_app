import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_check/bloc/bloc.dart';
import 'package:weather_check/repositories/repositories.dart';
import 'package:weather_check/resources/common_use/common_use.dart';
import 'package:weather_check/ui/ui.dart';

import 'resources/resources.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cloud = await loadUiImage("assets/images/cloud.png");
  final night = await loadUiImage("assets/images/night.png");
  final rain = await loadUiImage("assets/images/rain.png");
  final storm = await loadUiImage("assets/images/storm.png");
  final sun = await loadUiImage("assets/images/sun.png");

  WeatherIconSingleton.instance.cloud = cloud;
  WeatherIconSingleton.instance.night = night;
  WeatherIconSingleton.instance.rain = rain;
  WeatherIconSingleton.instance.storm = storm;
  WeatherIconSingleton.instance.sun = sun;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => const WeatherRepository(),
        ),
        RepositoryProvider(
          create: (context) => const LocationRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WeatherBloc(
              weatherRepository:
                  RepositoryProvider.of<WeatherRepository>(context),
              locationRepository:
                  RepositoryProvider.of<LocationRepository>(context),
            ),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                return ScrollConfiguration(
                  behavior: DisableGlow(),
                  child: child!,
                );
              },
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
