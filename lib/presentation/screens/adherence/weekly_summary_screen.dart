import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/data/providers/adherence_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/adherence/widgets/adherence_chart.dart';
import 'package:kusuridoki/presentation/screens/adherence/widgets/medication_breakdown.dart';
import 'package:kusuridoki/presentation/screens/adherence/widgets/overall_score.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_app_bar.dart';
import 'package:kusuridoki/presentation/shared/widgets/gradient_scaffold.dart';

class WeeklySummaryScreen extends ConsumerStatefulWidget {
  const WeeklySummaryScreen({super.key});

  @override
  ConsumerState<WeeklySummaryScreen> createState() =>
      _WeeklySummaryScreenState();
}

class _WeeklySummaryScreenState extends ConsumerState<WeeklySummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final overallAdherenceAsync = ref.watch(overallAdherenceProvider);
    final weeklyAdherenceAsync = ref.watch(weeklyAdherenceProvider);
    final l10n = AppLocalizations.of(context)!;

    return GradientScaffold(
      appBar: MpAppBar(title: l10n.weeklySummary, showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.navBarClearance,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            overallAdherenceAsync.when(
              data: (adherence) => OverallScore(
                percentage: adherence != null
                    ? (adherence * 100).round()
                    : null,
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
              error: (error, _) => const OverallScore(percentage: null),
            ),
            const SizedBox(height: AppSpacing.lg),
            weeklyAdherenceAsync.when(
              data: (weeklyData) => AdherenceChart(weeklyData: weeklyData),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
              error: (error, _) => AdherenceChart(weeklyData: const {}),
            ),
            const SizedBox(height: AppSpacing.lg),
            ref
                .watch(medicationBreakdownProvider)
                .when(
                  data: (medications) =>
                      MedicationBreakdown(medications: medications),
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                  error: (error, _) =>
                      MedicationBreakdown(medications: const []),
                ),
          ],
        ),
      ),
    );
  }
}
