import 'package:intl/intl.dart';

class DateTimeUtils {
  // Day Wise Filter
  static final dateFormate = DateFormat.yMMMEd();
  static String getFormateDateTime(DateTime day) {
    var formatedDate = dateFormate.format(day);
    return formatedDate;
  }

  static String getFormatedDateMilliS(int miliSeconds) {
    var day = DateTime.fromMillisecondsSinceEpoch(miliSeconds);
    return getFormateDateTime(day);
  }

  // Month Wise Filter
  static final monthFormate = DateFormat.yM();
  static String getFormatedMonthFromDateTime(DateTime month) {
    var formatedMonth = monthFormate.format(month);
    return formatedMonth;
  }

  static String getFormatedMonthFromMilli(int miliSeconds) {
    var month = DateTime.fromMillisecondsSinceEpoch(miliSeconds);
    return getFormatedMonthFromDateTime(month);
  }

  // Year Wise Filter
  static final yearFormate = DateFormat.y();
  static String getFormatedYearFromDateTime(DateTime year) {
    var formatedYear = yearFormate.format(year);
    return formatedYear;
  }

  static String getFromatedYearFromMilliSeconds(int miliseconds) {
    var year = DateTime.fromMillisecondsSinceEpoch(miliseconds);
    return getFormatedYearFromDateTime(year);
  }
}
