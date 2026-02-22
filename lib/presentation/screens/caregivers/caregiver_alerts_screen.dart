import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_empty_state.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';

class CaregiverAlertsScreen extends ConsumerWidget {
  const CaregiverAlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MpAppBar(title: l10n.alerts),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MpEmptyState(
                icon: Icons.warning_amber,
                title: l10n.alerts,
                description: l10n.alertsWillAppear,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              MpSectionHeader(title: l10n.alertTypes),
              const SizedBox(height: AppSpacing.md),
              MpCard(
                child: Row(
                  children: [
                    Icon(
                      Icons.notification_important,
                      size: AppSpacing.iconLg,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.missedDose,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            l10n.missedDoseDesc,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textMuted,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              MpCard(
                child: Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: AppSpacing.iconLg,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.lowStockLabel,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            l10n.lowStockDesc,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textMuted,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
