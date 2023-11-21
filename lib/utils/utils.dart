import 'package:intl/intl.dart';
//import 'dart:collection';

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

  static bool areStringListsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }

}