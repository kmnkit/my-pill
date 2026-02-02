import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:my_pill/data/enums/timezone_mode.dart';

class TimezoneService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (!_initialized) {
      tz_data.initializeTimeZones();
      _initialized = true;
    }
  }

  // Get current device timezone
  tz.Location get currentLocation => tz.local;

  // Get location by name
  tz.Location getLocation(String name) => tz.getLocation(name);

  // Calculate time difference between two timezones in hours
  int getTimeDifference(String homeTimezone, String currentTimezone) {
    final home = tz.getLocation(homeTimezone);
    final current = tz.getLocation(currentTimezone);
    final now = tz.TZDateTime.now(tz.UTC);
    final homeOffset = home.timeZone(now.millisecondsSinceEpoch).offset;
    final currentOffset = current.timeZone(now.millisecondsSinceEpoch).offset;
    return ((currentOffset - homeOffset) / 3600000).round();
  }

  // Convert a time from one timezone to another
  DateTime convertTime(DateTime time, String fromTimezone, String toTimezone) {
    final from = tz.getLocation(fromTimezone);
    final to = tz.getLocation(toTimezone);
    final tzTime = tz.TZDateTime.from(time, from);
    return tz.TZDateTime.from(tzTime.toUtc(), to);
  }

  // Adjust medication time based on timezone mode
  DateTime adjustMedicationTime(DateTime originalTime, String homeTimezone, String currentTimezone, TimezoneMode mode) {
    switch (mode) {
      case TimezoneMode.fixedInterval:
        // Keep absolute time - same UTC instant, display in current TZ
        return convertTime(originalTime, homeTimezone, currentTimezone);
      case TimezoneMode.localTime:
        // Keep wall-clock time - same hour:minute in new timezone
        final current = tz.getLocation(currentTimezone);
        return tz.TZDateTime(current, originalTime.year, originalTime.month, originalTime.day, originalTime.hour, originalTime.minute);
    }
  }

  // Format timezone display string e.g. "JST +9"
  String formatTimezone(String timezoneName) {
    final location = tz.getLocation(timezoneName);
    final now = tz.TZDateTime.now(location);
    final offset = now.timeZoneOffset;
    final hours = offset.inHours;
    final sign = hours >= 0 ? '+' : '';
    final abbr = now.timeZoneName;
    return '$abbr $sign$hours';
  }

  // Get list of affected medication times with dual display
  List<({DateTime homeTime, DateTime localTime, String homeLabel, String localLabel})> getAffectedTimes(
    List<DateTime> originalTimes,
    String homeTimezone,
    String currentTimezone,
    TimezoneMode mode,
  ) {
    final homeLabel = formatTimezone(homeTimezone);
    final localLabel = formatTimezone(currentTimezone);

    return originalTimes.map((time) {
      final adjusted = adjustMedicationTime(time, homeTimezone, currentTimezone, mode);
      return (homeTime: time, localTime: adjusted, homeLabel: homeLabel, localLabel: localLabel);
    }).toList();
  }
}
