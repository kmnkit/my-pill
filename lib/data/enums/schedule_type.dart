enum ScheduleType {
  daily(label: 'Daily'),
  specificDays(label: 'Specific Days'),
  interval(label: 'Interval');

  const ScheduleType({required this.label});
  final String label;
}
