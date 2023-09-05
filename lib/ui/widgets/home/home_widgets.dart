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

class SmoothLinePainter extends CustomPainter {
  final List<double> temperatureValues;
  final List<String> timeValues;
  final DateTime dateTime;

  SmoothLinePainter(this.temperatureValues, this.timeValues, this.dateTime);

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
    final yMax = temperatureValues.reduce(max) + 12.0;
    final yHeight = yMax - yMin + 16.0;
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
        style: const TextStyle(
          color: ColorProvider.mainText,
          fontSize: 12.0,
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
          style: const TextStyle(
              color: ColorProvider.mainText,
              fontSize: 18.0,
              fontWeight: FontWeight.w800));
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(xValue - textPainter.width / 2, size.height - 40.0),
      );

      final icon = Icons.favorite;
      final iconOffset = Offset(xValue - 10, 0);
      final iconCodePoint = icon.codePoint;
      final iconFontFamily = icon.fontFamily;

      final iconTextSpan = TextSpan(
        text: String.fromCharCode(iconCodePoint),
        style: TextStyle(
          fontFamily: iconFontFamily,
          fontSize: 20,
          color: ColorProvider.mainText,
        ),
      );

      final iconTextPainter = TextPainter(
        text: iconTextSpan,
        textDirection: TextDirection.ltr,
      );
      iconTextPainter.layout();
      iconTextPainter.paint(canvas, iconOffset);
      xValue += xAxisStep;
    }
    canvas.drawPath(path, paint);

    var paint1 = Paint()
      ..color = ColorProvider.mainText
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 14;

    var shadowPaint = Paint()
      ..color = ColorProvider.mainText
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 30
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

    canvas.drawPoints(PointMode.points, points, paint1);
    canvas.drawPoints(PointMode.points, points, shadowPaint);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 25.w, right: 25.w, top: 10.h, bottom: 5.h),
      child: AnimatedCrossFade(
        crossFadeState: !isSearching ? CrossFadeState.showFirst : CrossFadeState.showSecond,
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
                    context.read<WeatherBloc>().add(const GetUserLocationEvent());
                  }),
                  Container(
                    width: 215.w,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    child: reusableAppBarMainText(context.read<WeatherBloc>().state.cityName),
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
          ),
        ),
      ),
    );
  }
}
