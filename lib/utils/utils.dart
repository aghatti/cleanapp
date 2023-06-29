import 'package:intl/intl.dart';

class Utils {
  static String getTimeFromDate(DateTime dt)  {
    return DateFormat('HH:mm').format(dt);
  }
}