import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather_check/bloc/bloc.dart';
import 'package:weather_check/resources/resources.dart';
import 'package:weather_check/ui/ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<WeatherBloc>().add(const GetWeatherEvent("Berlin"));
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
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    state.weatherCode == "cloud"
                        ? ColorProvider.lightCloud
                        : state.weatherCode == "night"
                            ? ColorProvider.lightNight
                            : state.weatherCode == "rain"
                                ? ColorProvider.lightRain
                                : state.weatherCode == "storm"
                                    ? ColorProvider.lightStorm
                                    : ColorProvider.lightSun,
                    state.weatherCode == "cloud"
                        ? ColorProvider.darkCloud
                        : state.weatherCode == "night"
                            ? ColorProvider.darkNight
                            : state.weatherCode == "rain"
                                ? ColorProvider.darkRain
                                : state.weatherCode == "storm"
                                    ? ColorProvider.darkStorm
                                    : ColorProvider.darkSun,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 25.w, right: 25.w, top: 10.h, bottom: 5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: const Icon(
                              Icons.menu_outlined,
                              color: ColorProvider.mainText,
                              size: 30,
                            ),
                          ),
                          Container(
                            child: reusableAppBarMainText(state.cityName),
                          ),
                          Container(
                            child: const Icon(
                              Icons.location_on_outlined,
                              color: ColorProvider.mainText,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: reusableAppBarSubText(
                        DateFormat('EEEE, dd MMMM').format(
                          DateTime.now().toUtc().add(
                                Duration(
                                    seconds:
                                        state.weatherModel.utcOffsetSeconds!),
                              ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 375.w,
                      height: 420.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 50.h,
                            child: reusableMainText(
                                "${state.weatherModel.hourly!.temperature2m![DateTime.now().toUtc().add(
                                      Duration(
                                          seconds: state
                                              .weatherModel.utcOffsetSeconds!),
                                    ).hour].round()}"),
                          ),
                          Positioned(
                            top: 140.h,
                            child: Image.asset(
                              "assets/images/${state.weatherCode}.png",
                              scale: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 375.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              reusableSubText("Humidity", FontWeight.w500),
                              SizedBox(
                                height: 5.h,
                              ),
                              reusableSubText(
                                  "${(state.weatherModel.hourly!.relativehumidity2m![DateTime.now().toUtc().add(
                                        Duration(
                                            seconds: state.weatherModel
                                                .utcOffsetSeconds!),
                                      ).hour])} %",
                                  FontWeight.w700),
                            ],
                          ),
                          Column(
                            children: [
                              reusableSubText("Precipitation", FontWeight.w500),
                              SizedBox(
                                height: 5.h,
                              ),
                              reusableSubText(
                                  "${(state.weatherModel.hourly!.precipitationProbability![DateTime.now().toUtc().add(
                                        Duration(
                                            seconds: state.weatherModel
                                                .utcOffsetSeconds!),
                                      ).hour])} %",
                                  FontWeight.w700),
                            ],
                          ),
                          Column(
                            children: [
                              reusableSubText("Wind", FontWeight.w500),
                              SizedBox(
                                height: 5.h,
                              ),
                              reusableSubText(
                                  "${(state.weatherModel.hourly!.windspeed10m![DateTime.now().toUtc().add(
                                        Duration(
                                            seconds: state.weatherModel
                                                .utcOffsetSeconds!),
                                      ).hour])} km/h",
                                  FontWeight.w700),
                            ],
                          ),
                          Column(
                            children: [
                              reusableSubText("Pressure", FontWeight.w600),
                              SizedBox(
                                height: 5.h,
                              ),
                              reusableSubText(
                                  "${(state.weatherModel.hourly!.pressureMsl![DateTime.now().toUtc().add(
                                        Duration(
                                            seconds: state.weatherModel
                                                .utcOffsetSeconds!),
                                      ).hour])} hPa",
                                  FontWeight.w700),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 35.w, vertical: 15.h),
                      child: const Divider(
                        color: ColorProvider.mainText,
                        thickness: 2,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: ScrollController(
                        initialScrollOffset: (1500 /
                                24 *
                                getInitHour(
                                  DateTime.now().toUtc().add(
                                        Duration(
                                            seconds: state.weatherModel
                                                .utcOffsetSeconds!),
                                      ),
                                ))
                            .w,
                      ),
                      child: Container(
                        margin: EdgeInsets.only(left: 40.w),
                        width: 3000.w,
                        height: 140.h,
                        child: CustomPaint(
                          painter: SmoothLinePainter(
                              state.weatherModel.hourly!.temperature2m!,
                              state.weatherModel.hourly!.time!,
                              DateTime.now().toUtc().add(Duration(
                                  seconds:
                                      state.weatherModel.utcOffsetSeconds!))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  int getInitHour(DateTime dateTime) {
    final hour = int.parse(DateFormat('H').format(dateTime));
    return hour;
  }
}
