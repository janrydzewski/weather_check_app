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
    context.read<WeatherBloc>().add(GetWeatherEvent("Chicago"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375.w,
      height: 812.h,
      child: Scaffold(
        backgroundColor: ColorProvider.mainBackground,
        body: SafeArea(
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoading || state.cityName == "") {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Column(
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
                            child: Icon(
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
                          DateTime.now(),
                        ),
                      ),
                    ),
                    Container(
                      width: 375.w,
                      height: 420.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 50.h,
                            child: reusableMainText("17"),
                          ),
                          Positioned(
                            top: 140.h,
                            child: Image.asset(
                              "assets/images/cloud.png",
                              scale: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 375.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              reusableSubText("Visibility", FontWeight.w500),
                              SizedBox(
                                height: 5.h,
                              ),
                              reusableSubText(
                                  "${((state.weatherModel.hourly!.visibility![DateTime.now().hour]) / 1000)} km",
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
                                  "${(state.weatherModel.hourly!.precipitationProbability![DateTime.now().hour])} %",
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
                                  "${(state.weatherModel.hourly!.windspeed10m![DateTime.now().hour])} km/h",
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
                                  "${(state.weatherModel.hourly!.pressureMsl![DateTime.now().hour])} hPa",
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
                        initialScrollOffset: 800.w,
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 45.w),
                        width: 3000.w,
                        height: 140.h,
                        child: CustomPaint(
                          painter: SmoothLinePainter(
                              state.weatherModel.hourly!.temperature2m!,
                              state.weatherModel.hourly!.time!),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
