import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/data/providers/adherence_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_shimmer.dart';

class WeeklyAdherenceSummaryCard extends ConsumerWidget {
  const WeeklyAdherenceSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final adherenceAsync = ref.watch(overallAdherenceProvider);

    return adherenceAsync.when(
      loading: () => const KdShimmerBox(height: 56),
      error: (_, _) => const SizedBox.shrink(),
      data: (value) {
        final trailing = value != null
            ? l10n.adherenceRatePercent((value * 100).round())
            : '–';

        return Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                const Icon(Icons.bar_chart, color: AppColors.primary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.adherenceRate,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Text(
                  trailing,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
