
import 'package:intl/intl.dart';

String dateTimeFormatString(String format, DateTime dateTime){
  return (
        DateFormat(format).format(
          dateTime,
        ),
      ).toString();
}