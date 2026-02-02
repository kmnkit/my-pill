import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'adherence_provider.g.dart';

@riverpod
Future<double> overallAdherence(Ref ref) async {
  // TODO: Implement adherence calculation based on reminder history
  // For now, return a placeholder value
  return 0.85; // 85% adherence
}

@riverpod
Future<double> medicationAdherence(Ref ref, String medicationId) async {
  // TODO: Implement medication-specific adherence calculation
  // For now, return a placeholder value
  return 0.90; // 90% adherence
}

@riverpod
Future<Map<String, double>> weeklyAdherence(Ref ref) async {
  // TODO: Implement weekly adherence calculation based on reminder history
  // For now, return placeholder data
  final Map<String, double> weeklyData = {};

  final now = DateTime.now();
  for (int i = 0; i < 7; i++) {
    final date = now.subtract(Duration(days: i));
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    // Generate mock adherence data for demo purposes
    weeklyData[dateKey] = 0.80 + (i % 3) * 0.05;
  }

  return weeklyData;
}

@riverpod
String adherenceRating(Ref ref, double percentage) {
  if (percentage >= 95) return 'Excellent';
  if (percentage >= 80) return 'Good';
  if (percentage >= 50) return 'Fair';
  return 'Poor';
}
