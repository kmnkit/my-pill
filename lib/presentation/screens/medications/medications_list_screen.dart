import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/core/extensions/enum_l10n_extensions.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/services/ad_service.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_app_bar.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_badge.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_card.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_empty_state.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_pill_icon.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_shimmer.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_text_field.dart';
import 'package:kusuridoki/presentation/shared/widgets/gradient_scaffold.dart';

class MedicationsListScreen extends ConsumerStatefulWidget {
  const MedicationsListScreen({super.key});

  @override
  ConsumerState<MedicationsListScreen> createState() =>
      _MedicationsListScreenState();
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
      appBar: KdAppBar(
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
                    .where(
                      (med) => med.name.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      ),
                    )
                    .toList();

          return Column(
            children: [
              // Only show search when there are medications
              if (medications.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: KdTextField(
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
                    ? KdEmptyState(
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
                          bottom:
                              AppSpacing.navBarClearance +
                              (_bannerAd != null
                                  ? _bannerAd!.size.height.toDouble() +
                                        AppSpacing.lg
                                  : 0),
                        ),
                        itemCount: filteredMedications.length,
                        itemBuilder: (context, index) {
                          final med = filteredMedications[index];
                          final isLowStock =
                              med.inventoryRemaining <= med.lowStockThreshold;

                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: KdCard(
                              onTap: () =>
                                  context.push('/medications/${med.id}'),
                              child: Row(
                                children: [
                                  KdPillIcon(
                                    shape: med.shape,
                                    color: med.color,
                                  ),
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
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.titleSmall,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (med.isCritical) ...[
                                              const SizedBox(
                                                width: AppSpacing.xs,
                                              ),
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
                                                color:
                                                    context.appColors.textMuted,
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
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      KdBadge(
                                        label: isLowStock
                                            ? l10n.lowStock
                                            : 'OK',
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
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: KdListShimmer(),
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
