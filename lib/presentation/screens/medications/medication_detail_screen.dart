import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/medication_provider.dart';
import 'package:my_pill/data/providers/adherence_provider.dart';
import 'package:my_pill/presentation/screens/medications/widgets/adherence_badge.dart';
import 'package:my_pill/presentation/shared/dialogs/mp_confirm_dialog.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_badge.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_pill_icon.dart';
import 'package:my_pill/presentation/shared/widgets/mp_progress_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';
import 'package:my_pill/presentation/router/route_names.dart';

class MedicationDetailScreen extends ConsumerWidget {
  final String medicationId;

  const MedicationDetailScreen({
    super.key,
    required this.medicationId,
  });

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await MpConfirmDialog.show(
      context,
      title: 'Delete Medication',
      message: 'Are you sure you want to delete this medication? This action cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      await ref.read(medicationListProvider.notifier).deleteMedication(medicationId);
      if (context.mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationAsync = ref.watch(medicationProvider(medicationId));
    final adherenceAsync = ref.watch(medicationAdherenceProvider(medicationId));

    return Scaffold(
      appBar: MpAppBar(
        title: 'MyPill',
        showBack: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.pushNamed(
                RouteNames.editMedication,
                pathParameters: {'id': medicationId},
              );
            },
            iconSize: AppSpacing.iconMd,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _handleDelete(context, ref),
            iconSize: AppSpacing.iconMd,
          ),
        ],
      ),
      body: medicationAsync.when(
        data: (medication) {
          if (medication == null) {
            return const Center(
              child: Text('Medication not found'),
            );
          }

          final isLowStock = medication.inventoryRemaining <= medication.lowStockThreshold;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hero section
                Center(
                  child: Column(
                    children: [
                      MpPillIcon(
                        shape: medication.shape,
                        color: medication.color,
                        size: 64,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        medication.name,
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '${medication.dosage}${medication.dosageUnit.label}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Inventory card
                MpCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Inventory',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (isLowStock)
                            const MpBadge(
                              label: 'Low Stock',
                              variant: MpBadgeVariant.lowStock,
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      MpProgressBar(
                        current: medication.inventoryRemaining,
                        total: medication.inventoryTotal,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      MpButton(
                        label: 'Update Inventory',
                        variant: MpButtonVariant.secondary,
                        onPressed: () {
                          // TODO: Show inventory update dialog
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Schedule info card
                MpCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Schedule',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _InfoRow(
                        label: 'Added',
                        value: DateFormat('MMM d, yyyy').format(medication.createdAt),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Recent history (TODO: Wire to actual history when available)
                const MpSectionHeader(title: 'Recent History'),
                const SizedBox(height: AppSpacing.md),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: Text(
                      'History coming soon',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Adherence badge
                adherenceAsync.when(
                  data: (adherence) => AdherenceBadge(
                    percentage: (adherence * 100).round(),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (error, stack) => const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading medication: $error'),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => ref.invalidate(medicationProvider(medicationId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
