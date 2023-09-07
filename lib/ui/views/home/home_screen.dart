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
    super.initState();
    context.read<WeatherBloc>().add(const GetWeatherEvent("Chicago"));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375.w,
      height: 812.h,
      child: BlocConsumer<WeatherBloc, WeatherState>(
        listener: (context, state) {
          if (state is WeatherError) {
            context.read<WeatherBloc>().add(const GetWeatherEvent("Chicago"));
            mainError(context, state, state.message);
          }
        },
        builder: (context, state) {
          if (state is WeatherLoading || state.cityName == "") {
            return mainLoading();
          }
          return Scaffold(
            body: mainBackground(
              state,
              SafeArea(
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        mainRowWidget(),
                        mainTemperatureWidget(state),
                        specificInfoRow(state),
                        dividerWidget(),
                        mainSliderWidget(state),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
