
import 'package:intl/intl.dart';

class DateTimeUtils {
  static final dateFormate = DateFormat.yMMMEd();
  static String getFormatedMilliS(int miliSeconds) {
    var date = DateTime.fromMillisecondsSinceEpoch(miliSeconds);
    return getFormateDateTime(date);
  }

  static String getFormateDateTime(DateTime dateTime) {
    var formatedDate = dateFormate.format(dateTime);
    return formatedDate;
  }
}
