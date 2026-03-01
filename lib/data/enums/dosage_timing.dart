import 'package:flutter/material.dart';

enum DosageTiming {
  morning(
    label: 'Morning',
    defaultHour: 8,
    defaultMinute: 0,
    minHour: 5,
    maxHour: 10,
  ),
  noon(
    label: 'Noon',
    defaultHour: 12,
    defaultMinute: 0,
    minHour: 11,
    maxHour: 14,
  ),
  evening(
    label: 'Evening',
    defaultHour: 18,
    defaultMinute: 0,
    minHour: 15,
    maxHour: 20,
  ),
  bedtime(
    label: 'Bedtime',
    defaultHour: 22,
    defaultMinute: 0,
    minHour: 21,
    maxHour: 1,
  );

  const DosageTiming({
    required this.label,
    required this.defaultHour,
    required this.defaultMinute,
    required this.minHour,
    required this.maxHour,
  });

  final String label;
  final int defaultHour;
  final int defaultMinute;
  final int minHour;
  final int maxHour;

  TimeOfDay get defaultTimeOfDay =>
      TimeOfDay(hour: defaultHour, minute: defaultMinute);

  /// Returns true if the given [hour]:[minute] falls within this timing's range.
  ///
  /// Handles midnight wrap-around for bedtime (e.g., 21:00 ~ 01:59).
  bool isTimeInRange(int hour, int minute) {
    if (minHour <= maxHour) {
      // Normal range (no midnight wrap-around)
      return hour >= minHour && (hour < maxHour || (hour == maxHour && minute <= 59));
    }
    // Wrap-around range (e.g., 21:00 ~ 01:59)
    // In range if: hour >= minHour (21, 22, 23) OR hour <= maxHour (0, 1)
    return hour >= minHour || (hour < maxHour || (hour == maxHour && minute <= 59));
  }
}
