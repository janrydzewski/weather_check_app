import 'dart:ui';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_check/bloc/bloc.dart';
import 'package:weather_check/resources/resources.dart';

import 'home.dart';

reusableAppBarMainText(String text) {
  return AutoSizeText(
    text,
    maxLines: 1,
    maxFontSize: 34,
    style: GoogleFonts.archivoBlack(
      color: ColorProvider.mainText,
      fontSize: 34,
    ),
  );
}

reusableAppBarSubText(String text) {
  return Text(
    text,
    style: GoogleFonts.archivo(
      fontWeight: FontWeight.w500,
      color: ColorProvider.mainText,
      fontSize: 16.sp,
    ),
  );
}

reusableMainText(String text) {
  return Text(
    "${text}°",
    style: GoogleFonts.rubik(
      fontWeight: FontWeight.w600,
      color: ColorProvider.mainText,
      fontSize: 128.sp,
    ),
  );
}

reusableSubText(String text, FontWeight fontWeight) {
  return Text(
    text,
    style: GoogleFonts.archivo(
      fontWeight: fontWeight,
      color: ColorProvider.mainText,
      fontSize: 14.sp,
    ),
  );
}

reusableErrorText(String text) {
  return Text(
    text,
    style: GoogleFonts.archivo(
      fontWeight: FontWeight.w500,
      color: ColorProvider.mainText,
      fontSize: 24.sp,
    ),
  );
}

class SmoothLinePainter extends CustomPainter {
  final List<double> temperatureValues;
  final List<String> timeValues;
  final List<int> weathercode;
  final DateTime dateTime;

  SmoothLinePainter(
      this.temperatureValues, this.timeValues, this.dateTime, this.weathercode);

  @override
  void paint(Canvas canvas, Size size) {
    final points = <Offset>[];

    final paint = Paint()
      ..color = ColorProvider.mainText
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final path = Path();

    final yMin = temperatureValues.reduce(min);
    final yMax = temperatureValues.reduce(max) + 4.0;
    final yHeight = yMax - yMin + 6.0;
    final xAxisStep = size.width / temperatureValues.length;
    var xValue = 0.0;

    for (var i = 0; i < temperatureValues.length; i++) {
      final temperatureValue = temperatureValues[i];
      final timeValue = timeValues[i].substring(11);
      final yValue = yHeight == 0
          ? (0.5 * size.height)
          : ((yMax - temperatureValue) / yHeight) * size.height;
      if (xValue == 0) {
        path.moveTo(xValue, yValue);
      } else {
        final previousValue = temperatureValues[i - 1];
        final xPrevious = xValue - xAxisStep;
        final yPrevious = yHeight == 0
            ? (0.5 * size.height)
            : ((yMax - previousValue) / yHeight) * size.height;
        final controlPointX = xPrevious + (xValue - xPrevious) / 2;
        path.cubicTo(
            controlPointX, yPrevious, controlPointX, yValue, xValue, yValue);
      }

      final currentTime = dateTimeFormatString('H', dateTime);
      final currentDate = dateTimeFormatString('yyyy-MM-dd', dateTime);

      final time = "(${timeValues[i].substring(11, 13)})";
      final date = "(${timeValues[i].substring(0, 10)})";

      if (currentTime == time && currentDate == date) {
        points.add(Offset(xValue, yValue));
      }

      textPainter.text = TextSpan(
        text: timeValue,
        style: GoogleFonts.archivo(
          color: ColorProvider.mainText,
          fontSize: 13.sp,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(xValue - textPainter.width / 2, size.height - 15.0),
      );

      final pointValue = temperatureValue.toStringAsFixed(2).substring(0, 4);

      textPainter.text = TextSpan(
        text: "${pointValue}°",
        style: GoogleFonts.archivo(
          fontWeight: FontWeight.w700,
          color: ColorProvider.mainText,
          fontSize: 18.sp,
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(xValue - textPainter.width / 2, size.height - 40.0),
      );

      final myImage = getWeatherCode(weathercode[i], i % 24) == "cloud"
          ? WeatherIconSingleton.instance.cloud
          : getWeatherCode(weathercode[i], i % 24) == "night"
              ? WeatherIconSingleton.instance.night
              : getWeatherCode(weathercode[i], i % 24) == "rain"
                  ? WeatherIconSingleton.instance.rain
                  : getWeatherCode(weathercode[i], i % 24) == "storm"
                      ? WeatherIconSingleton.instance.storm
                      : WeatherIconSingleton.instance.sun;

      final srcRect = Rect.fromPoints(
        const Offset(0, 0),
        Offset(myImage!.width.toDouble(), myImage.height.toDouble()),
      );

      final dstRect = Rect.fromPoints(
        Offset(xValue - 15, 0),
        Offset(xValue + 15, 30),
      );

      canvas.drawImageRect(myImage, srcRect, dstRect, Paint());

      xValue += xAxisStep;
    }

    canvas.drawPath(path, paint);

    var dotPainter = Paint()
      ..color = ColorProvider.mainText
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 14;

    var shadowDotPainter = Paint()
      ..color = ColorProvider.mainText
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 30
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

    canvas.drawPoints(PointMode.points, points, dotPainter);
    canvas.drawPoints(PointMode.points, points, shadowDotPainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

reusableSpecificInfo(String title, String mainText) {
  return Column(
    children: [
      reusableSubText(title, FontWeight.w500),
      SizedBox(
        height: 5.h,
      ),
      reusableSubText(mainText, FontWeight.w700),
    ],
  );
}

reusableMainIcon(IconData iconData, Function() func) {
  return GestureDetector(
    onTap: func,
    child: Icon(
      iconData,
      color: ColorProvider.mainText,
      size: 30.sp,
    ),
  );
}

class MainTopBar extends StatefulWidget {
  const MainTopBar({super.key});

  @override
  State<MainTopBar> createState() => _MainTopBarState();
}

class _MainTopBarState extends State<MainTopBar> {
  bool isSearching = false;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentColor =
        context.read<WeatherBloc>().state.weatherCode == "cloud"
            ? ColorProvider.darkCloud
            : context.read<WeatherBloc>().state.weatherCode == "night"
                ? ColorProvider.darkNight
                : context.read<WeatherBloc>().state.weatherCode == "rain"
                    ? ColorProvider.darkRain
                    : context.read<WeatherBloc>().state.weatherCode == "storm"
                        ? ColorProvider.darkStorm
                        : ColorProvider.darkSun;

    return Container(
      margin: EdgeInsets.only(left: 25.w, right: 25.w, top: 10.h, bottom: 5.h),
      child: AnimatedCrossFade(
        crossFadeState:
            !isSearching ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 400),
        firstChild: Column(
          children: [
            SizedBox(
              width: 375.w,
              height: 40.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  reusableMainIcon(Icons.location_on_outlined, () {
                    context
                        .read<WeatherBloc>()
                        .add(const GetUserLocationEvent());
                  }),
                  Container(
                    width: 215.w,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    child: reusableAppBarMainText(
                        context.read<WeatherBloc>().state.cityName),
                  ),
                  reusableMainIcon(Icons.search_outlined, () {
                    setState(() {
                      isSearching = true;
                    });
                  }),
                ],
              ),
            ),
            mainDateTimeWidget(context.read<WeatherBloc>().state),
          ],
        ),
        secondChild: SizedBox(
          width: 375.w,
          height: 60.h,
          child: TextField(
            controller: textEditingController,
            style: GoogleFonts.archivo(
              fontWeight: FontWeight.w500,
              color: ColorProvider.mainText,
              fontSize: 18.sp,
            ),
            decoration: InputDecoration(
                hoverColor: currentColor,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: currentColor,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: currentColor,
                  ),
                ),
                border: InputBorder.none,
                suffixIcon: GestureDetector(
                  onTap: () {
                    context.read<WeatherBloc>().add(
                        SearchUserLocationEvent(textEditingController.text));
                    setState(() {
                      isSearching = false;
                    });
                  },
                  child: Icon(
                    Icons.search_outlined,
                    color: currentColor,
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
