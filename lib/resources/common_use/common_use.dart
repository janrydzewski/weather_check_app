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