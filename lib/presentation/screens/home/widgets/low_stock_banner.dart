import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/data/providers/medication_provider.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_alert_banner.dart';

class LowStockBanner extends ConsumerWidget {
  const LowStockBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final medicationsAsync = ref.watch(medicationListProvider);

    return medicationsAsync.when(
      data: (medications) {
        // Find first low stock medication
        final lowStockMed = medications.where((med) {
          final threshold = med.lowStockThreshold;
          return med.inventoryRemaining <= threshold;
        }).firstOrNull;

        // Hide banner if no low stock
        if (lowStockMed == null) {
          return const SizedBox.shrink();
        }

        return MpAlertBanner(
          title: l10n.lowStockAlert(lowStockMed.name, lowStockMed.inventoryRemaining),
          icon: Icons.warning_amber_rounded,
          color: AppColors.warning,
          onTap: () {
            // Navigate to medication detail or stock management
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}
