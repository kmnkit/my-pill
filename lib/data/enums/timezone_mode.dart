enum TimezoneMode {
  fixedInterval(label: 'Fixed Interval (Home Time)'),
  localTime(label: 'Local Time Adaptation');

  const TimezoneMode({required this.label});
  final String label;
}
