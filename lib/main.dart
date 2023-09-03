import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_check/bloc/bloc.dart';
import 'package:weather_check/repositories/repositories.dart';
import 'package:weather_check/ui/ui.dart';

void main() async {
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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WeatherBloc(
                weatherRepository:
                    RepositoryProvider.of<WeatherRepository>(context)),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, state) {
            return const MaterialApp(
              home: HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
