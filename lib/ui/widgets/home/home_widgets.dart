import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_check/resources/resources.dart';

reusableAppBarMainText(String text) {
  return Text(
    text,
    style: GoogleFonts.archivoBlack(
      color: ColorProvider.mainText,
      fontSize: 34.sp,
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

  SmoothLinePainter(this.temperatureValues, this.timeValues);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorProvider.mainText
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final path = Path();

    final yMin = temperatureValues.reduce(min);
    final yMax = temperatureValues.reduce(max) + 8.0;
    final yHeight = yMax - yMin + 8.0;
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
      xValue += xAxisStep;

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

      final pointValue = temperatureValue.toStringAsFixed(2).substring(0, 2);

      textPainter.text = TextSpan(
          text: pointValue,
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
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
