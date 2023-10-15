import 'package:intl/intl.dart';

class Utils {
  static String getTimeFromDate(DateTime dt)  {
    return DateFormat('HH:mm').format(dt);
  }
  static String getDateFormat(DateTime dt, String format) {
    return DateFormat(format).format(dt);
  }
  static bool isNotCurrentDay(DateTime dt) {
    DateTime now = DateTime.now();
    return dt.year != now.year ||
        dt.month != now.month ||
        dt.day != now.day;
  }
}