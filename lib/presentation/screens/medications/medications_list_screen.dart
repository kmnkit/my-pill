import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/medication_provider.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_badge.dart';
import 'package:my_pill/presentation/shared/widgets/mp_empty_state.dart';
import 'package:my_pill/presentation/shared/widgets/mp_pill_icon.dart';
import 'package:my_pill/presentation/shared/widgets/mp_text_field.dart';

class MedicationsListScreen extends ConsumerStatefulWidget {
  const MedicationsListScreen({super.key});

  @override
  ConsumerState<MedicationsListScreen> createState() => _MedicationsListScreenState();
}

class _MedicationsListScreenState extends ConsumerState<MedicationsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final medicationsAsync = ref.watch(medicationListProvider);

    return Scaffold(
      appBar: MpAppBar(
        title: 'My Medications',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: AppSpacing.iconMd,
            onPressed: () => context.go('/medications/add'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: MpTextField(
              controller: _searchController,
              hint: 'Search medications...',
              prefixIcon: Icons.search,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: medicationsAsync.when(
              data: (medications) {
                final filteredMedications = _searchQuery.isEmpty
                    ? medications
                    : medications
                        .where((med) =>
                            med.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                        .toList();

                if (filteredMedications.isEmpty) {
                  return MpEmptyState(
                    icon: Icons.medication,
                    title: _searchQuery.isEmpty
                        ? 'No medications added yet'
                        : 'No medications found',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  itemCount: filteredMedications.length,
                  itemBuilder: (context, index) {
                    final med = filteredMedications[index];
                    final isLowStock = med.inventoryRemaining <= med.lowStockThreshold;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: GestureDetector(
                        onTap: () => context.go('/medications/${med.id}'),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardDark : AppColors.cardLight,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: Row(
                            children: [
                              MpPillIcon(shape: med.shape, color: med.color),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      med.name,
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      '${med.dosage}${med.dosageUnit.label}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppColors.textMuted,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${med.inventoryRemaining}/${med.inventoryTotal}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  MpBadge(
                                    label: isLowStock ? 'Low' : 'OK',
                                    variant: isLowStock
                                        ? MpBadgeVariant.lowStock
                                        : MpBadgeVariant.connected,
                                  ),
                                ],
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              const Icon(
                                Icons.chevron_right,
                                color: AppColors.textMuted,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error loading medications'),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: () => ref.invalidate(medicationListProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
