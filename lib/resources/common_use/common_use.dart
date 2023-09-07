import 'package:intl/intl.dart';

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