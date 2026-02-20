import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatDate(String isoDateTime) {
    DateTime dateTime = DateTime.parse(isoDateTime).toLocal();
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "Today";
    } else {
      return DateFormat('d MMMM y').format(dateTime);
    }
  }

  static String formatTime(String isoDateTime) {
    DateTime dateTime = DateTime.parse(isoDateTime).toLocal();
    return DateFormat('h:mm a').format(dateTime);
  }



  static String formatDateTime(String ?isoDateTime) {
    if (isoDateTime!=null && isoDateTime.isNotEmpty) {
      DateTime dateTime = DateTime.parse(isoDateTime).toLocal();
      return DateFormat('dd MMM yyyy, h:mm a').format(dateTime);
    }else{
      return '';
    }
  }



}
