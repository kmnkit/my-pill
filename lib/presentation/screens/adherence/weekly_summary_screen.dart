import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/adherence_provider.dart';
import 'package:my_pill/presentation/screens/adherence/widgets/adherence_chart.dart';
import 'package:my_pill/presentation/screens/adherence/widgets/medication_breakdown.dart';
import 'package:my_pill/presentation/screens/adherence/widgets/overall_score.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';

class WeeklySummaryScreen extends ConsumerWidget {
  const WeeklySummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overallAdherenceAsync = ref.watch(overallAdherenceProvider);
    final weeklyAdherenceAsync = ref.watch(weeklyAdherenceProvider);

    return Scaffold(
      appBar: const MpAppBar(
        title: 'Weekly Summary',
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            overallAdherenceAsync.when(
              data: (adherence) => OverallScore(
                percentage: (adherence * 100).round(),
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
              error: (error, _) => const OverallScore(percentage: 0),
            ),
            const SizedBox(height: AppSpacing.lg),
            weeklyAdherenceAsync.when(
              data: (weeklyData) => const AdherenceChart(),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
              error: (error, _) => const AdherenceChart(),
            ),
            const SizedBox(height: AppSpacing.lg),
            const MedicationBreakdown(),
          ],
        ),
      ),
    );
  }
}
