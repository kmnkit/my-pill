import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_app_bar.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_empty_state.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_card.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_section_header.dart';
import 'package:kusuridoki/presentation/shared/widgets/gradient_scaffold.dart';

class CaregiverAlertsScreen extends ConsumerWidget {
  const CaregiverAlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return GradientScaffold(
      appBar: KdAppBar(title: l10n.alerts),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.navBarClearance,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KdEmptyState(
                icon: Icons.warning_amber,
                title: l10n.alerts,
                description: l10n.alertsWillAppear,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              KdSectionHeader(title: l10n.alertTypes),
              const SizedBox(height: AppSpacing.md),
              KdCard(
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
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: context.appColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              KdCard(
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
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: context.appColors.textMuted),
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
