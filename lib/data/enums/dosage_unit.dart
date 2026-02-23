enum DosageUnit {
  mg(label: 'mg'),
  ml(label: 'ml'),
  pills(label: 'pills'),
  units(label: 'units'),
  packs(label: 'packs');

  const DosageUnit({required this.label});
  final String label;
}
