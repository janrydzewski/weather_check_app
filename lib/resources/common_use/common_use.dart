import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:flutter/services.dart';
import 'package:weather_check/resources/resources.dart';

String dateTimeFormatString(String format, DateTime dateTime) {
  return (
    DateFormat(format).format(
      dateTime,
    ),
  ).toString();
}

int getInitHour(DateTime dateTime) {
    final hour = int.parse(DateFormat('H').format(dateTime));
    return hour;
  }

String getWeatherCode(int code, int hour) {
  if (hour >= 22 || hour <= 6) {
    return "night";
  }
  switch (code) {
    case 0:
      return "sun";
    case 1:
    case 2:
    case 3:
    case 45:
    case 48:
      return "cloud";
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return "snow";
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
    case 61:
    case 63:
    case 65:
    case 66:
    case 67:
    case 80:
    case 81:
    case 82:
    case 95:
    case 96:
    case 99:
      return "rain";
    default:
      return "cloud";
  }
}

Future<UI.Image> loadUiImage(String imageAssetPath) async {
  final ByteData data = await rootBundle.load(imageAssetPath);
  final Completer<UI.Image> completer = Completer();
  UI.decodeImageFromList(Uint8List.view(data.buffer), (UI.Image img) {
    return completer.complete(img);
  });
  return completer.future;
}

class DisableGlow extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

getAllImages() async {

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

}