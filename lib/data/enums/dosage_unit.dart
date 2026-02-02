enum DosageUnit {
  mg(label: 'mg'),
  ml(label: 'ml'),
  pills(label: 'pills'),
  units(label: 'units');

  const DosageUnit({required this.label});
  final String label;
}
