import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather_check/bloc/bloc.dart';
import 'package:weather_check/resources/resources.dart';
import 'package:weather_check/ui/ui.dart';

mainLoading() {
  return Container(
    color: ColorProvider.darkCloud,
    child: const Center(
      child: CircularProgressIndicator(
        backgroundColor: ColorProvider.lightSun,
      ),
    ),
  );
}

mainBackground(WeatherState state, Widget child) {
  return Container(
    height: 812.h,
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
    child: child,
  );
}

mainRowWidget() {
  return const MainTopBar();
}

mainDateTimeWidget(WeatherState state) {
  return SizedBox(
    height: 20.h,
    child: reusableAppBarSubText(
      DateFormat('EEEE, dd MMMM').format(
        DateTime.now().toUtc().add(
              Duration(seconds: state.weatherModel.utcOffsetSeconds!),
            ),
      ),
    ),
  );
}

mainTemperatureWidget(WeatherState state) {
  return SizedBox(
    width: 375.w,
    height: 450.h,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 50.h,
          child: reusableMainText(
              "${state.weatherModel.hourly!.temperature2m![DateTime.now().toUtc().add(
                    Duration(seconds: state.weatherModel.utcOffsetSeconds!),
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
  );
}

specificInfoRow(WeatherState state) {
  return SizedBox(
    width: 375.w,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        reusableSpecificInfo(
          "Humidity",
          "${(state.weatherModel.hourly!.relativehumidity2m![DateTime.now().toUtc().add(
                Duration(seconds: state.weatherModel.utcOffsetSeconds!),
              ).hour])} %",
        ),
        reusableSpecificInfo(
          "Precipitation",
          "${(state.weatherModel.hourly!.precipitationProbability![DateTime.now().toUtc().add(
                Duration(seconds: state.weatherModel.utcOffsetSeconds!),
              ).hour])} %",
        ),
        reusableSpecificInfo(
          "Wind",
          "${(state.weatherModel.hourly!.windspeed10m![DateTime.now().toUtc().add(
                Duration(seconds: state.weatherModel.utcOffsetSeconds!),
              ).hour])} km/h",
        ),
        reusableSpecificInfo(
          "Pressure",
          "${(state.weatherModel.hourly!.pressureMsl![DateTime.now().toUtc().add(
                Duration(seconds: state.weatherModel.utcOffsetSeconds!),
              ).hour])} hPa",
        ),
      ],
    ),
  );
}

dividerWidget() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 35.w, vertical: 15.h),
    child: const Divider(
      color: ColorProvider.mainText,
      thickness: 2,
    ),
  );
}

mainSliderWidget(WeatherState state) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    controller: ScrollController(
      initialScrollOffset: (1500 /
              24 *
              getInitHour(
                DateTime.now().toUtc().add(
                      Duration(seconds: state.weatherModel.utcOffsetSeconds!),
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
          DateTime.now().toUtc().add(
                Duration(seconds: state.weatherModel.utcOffsetSeconds!),
              ),
          state.weatherModel.hourly!.weathercode!,
        ),
      ),
    ),
  );
}

mainError(BuildContext context, WeatherState state, String message) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => Scaffold(
        body: mainBackground(
          state,
          SafeArea(
            child: Column(
              children: [
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 30.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300.w,
                        child: Image.asset("assets/images/storm.png"),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 50.h),
                        alignment: Alignment.center,
                        width: 375.w,
                        child: reusableErrorText(message),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
