import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_alert_banner.dart';

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

        return KdAlertBanner(
          title: l10n.lowStockAlert(
            lowStockMed.name,
            lowStockMed.inventoryRemaining,
          ),
          icon: Icons.warning_amber_rounded,
          color: AppColors.warning,
          onTap: () {
            context.push('/medications/${lowStockMed.id}');
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}
