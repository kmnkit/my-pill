enum DosageTiming {
  beforeMeal(label: 'Before Meal'),
  afterMeal(label: 'After Meal'),
  betweenMeals(label: 'Between Meals'),
  atBedtime(label: 'At Bedtime'),
  onWaking(label: 'On Waking'),
  asNeeded(label: 'As Needed');

  const DosageTiming({required this.label});
  final String label;
}
