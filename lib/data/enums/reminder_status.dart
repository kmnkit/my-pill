enum ReminderStatus {
  pending(label: 'Upcoming'),
  taken(label: 'Taken'),
  missed(label: 'Missed'),
  skipped(label: 'Skipped'),
  snoozed(label: 'Snoozed');

  const ReminderStatus({required this.label});
  final String label;
}
