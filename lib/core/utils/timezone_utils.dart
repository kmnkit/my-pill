import 'package:intl/intl.dart';

abstract final class TimezoneUtils {
  // Format time for display: "8:00 AM"
  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  // Format dual timezone display: "10:00 PM JST / 8:00 AM EST"
  static String formatDualTime(DateTime homeTime, DateTime localTime, String homeLabel, String localLabel) {
    final homeFmt = DateFormat('h:mm a').format(homeTime);
    final localFmt = DateFormat('h:mm a').format(localTime);
    return '$localFmt $localLabel / $homeFmt $homeLabel';
  }

  // Format timezone offset: "+14 hours"
  static String formatOffset(int hours) {
    final sign = hours >= 0 ? '+' : '';
    return '$sign$hours hours';
  }
}
