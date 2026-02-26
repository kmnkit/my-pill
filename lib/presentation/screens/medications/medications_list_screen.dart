import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/theme/app_colors_extension.dart';
import 'package:my_pill/core/extensions/enum_l10n_extensions.dart';
import 'package:my_pill/data/providers/medication_provider.dart';
import 'package:my_pill/data/services/ad_service.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_badge.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_empty_state.dart';
import 'package:my_pill/presentation/shared/widgets/mp_pill_icon.dart';
import 'package:my_pill/presentation/shared/widgets/mp_text_field.dart';
import 'package:my_pill/presentation/shared/widgets/gradient_scaffold.dart';

class MedicationsListScreen extends ConsumerStatefulWidget {
  const MedicationsListScreen({super.key});

  @override
  ConsumerState<MedicationsListScreen> createState() => _MedicationsListScreenState();
}

class _MedicationsListScreenState extends ConsumerState<MedicationsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    try {
      _bannerAd = AdService().getMedicationsBannerAd();
      if (_bannerAd != null) {
        setState(() {});
      }
    } catch (e) {
      // Graceful failure - app continues without ads
      debugPrint('Failed to load medications banner ad: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final medicationsAsync = ref.watch(medicationListProvider);

    return GradientScaffold(
      appBar: MpAppBar(
        title: l10n.myMedications,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: AppSpacing.iconMd,
            onPressed: () => context.push('/medications/add'),
          ),
        ],
      ),
      body: medicationsAsync.when(
        data: (medications) {
          final filteredMedications = _searchQuery.isEmpty
              ? medications
              : medications
                  .where((med) =>
                      med.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                  .toList();

          return Column(
            children: [
              // Only show search when there are medications
              if (medications.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: MpTextField(
                    controller: _searchController,
                    hint: l10n.searchMedicationsHint,
                    prefixIcon: Icons.search,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              Expanded(
                child: filteredMedications.isEmpty
                    ? MpEmptyState(
                        icon: Icons.medication,
                        title: _searchQuery.isEmpty
                            ? l10n.noMedications
                            : l10n.noMedicationsFound,
                        actionLabel: _searchQuery.isEmpty
                            ? l10n.addMedication
                            : null,
                        onAction: _searchQuery.isEmpty
                            ? () => context.push('/medications/add')
                            : null,
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(
                          left: AppSpacing.lg,
                          right: AppSpacing.lg,
                          bottom: AppSpacing.navBarClearance +
                              (_bannerAd != null
                                  ? _bannerAd!.size.height.toDouble() + AppSpacing.lg
                                  : 0),
                        ),
                        itemCount: filteredMedications.length,
                        itemBuilder: (context, index) {
                          final med = filteredMedications[index];
                          final isLowStock =
                              med.inventoryRemaining <= med.lowStockThreshold;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: MpCard(
                              onTap: () =>
                                  context.push('/medications/${med.id}'),
                              child: Row(
                                children: [
                                  MpPillIcon(
                                      shape: med.shape, color: med.color),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                med.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (med.isCritical) ...[
                                              const SizedBox(width: AppSpacing.xs),
                                              Icon(
                                                Icons.priority_high,
                                                size: 16,
                                                color: AppColors.warning,
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(
                                          '${med.dosage}${med.dosageUnit.localizedName(l10n)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: context
                                                    .appColors.textMuted,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      MpBadge(
                                        label:
                                            isLowStock ? l10n.lowStock : 'OK',
                                        variant: isLowStock
                                            ? MpBadgeVariant.lowStock
                                            : MpBadgeVariant.connected,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Icon(
                                    Icons.chevron_right,
                                    color: context.appColors.textMuted,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (_bannerAd != null)
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: SizedBox(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.errorLoadingMedications),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => ref.invalidate(medicationListProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
