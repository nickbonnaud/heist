import 'package:intl/intl.dart';

class DateFormatter {

  static DateTime toDateTime({required String date}) {
    return DateTime.parse(date);
  }

  static String toStringDateTime({required DateTime date}) {
    return DateFormat.yMMMd('en_us').add_jm().format(date);
  }

  static String toStringDate({required DateTime date}) {
    return DateFormat.yMMMd('en_us').format(date);
  }

  static String toStandardDate({required DateTime date}) {
    return DateFormat('E, MMM d').format(date);
  }
}