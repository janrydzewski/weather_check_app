import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_check/bloc/bloc.dart';
import 'package:weather_check/ui/ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<WeatherBloc>().add(const GetWeatherEvent("Warsaw"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375.w,
      height: 812.h,
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading || state.cityName == "") {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            body: mainBackground(
              state,
              SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    mainRowWidget(state),
                    mainDateTimeWidget(state),
                    mainTemperatureWidget(state),
                    specificInfoRow(state),
                    dividerWidget(),
                    mainSliderWidget(state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
