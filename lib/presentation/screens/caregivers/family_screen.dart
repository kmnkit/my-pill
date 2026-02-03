import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/caregiver_provider.dart';
import 'package:my_pill/data/providers/invite_provider.dart';
import 'package:my_pill/data/providers/subscription_provider.dart';
import 'package:my_pill/presentation/screens/caregivers/widgets/caregiver_list_tile.dart';
import 'package:my_pill/presentation/screens/caregivers/widgets/privacy_notice.dart';
import 'package:my_pill/presentation/screens/caregivers/widgets/qr_invite_section.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_empty_state.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';
import 'package:my_pill/presentation/shared/widgets/premium_badge.dart';
import 'package:my_pill/l10n/app_localizations.dart';

class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final caregiverLinksAsync = ref.watch(caregiverLinksProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final maxCaregivers = ref.watch(maxCaregiversProvider);

    return Scaffold(
      appBar: MpAppBar(title: l10n.familyCaregivers, showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linked caregivers section with count
            Row(
              children: [
                Expanded(
                  child: MpSectionHeader(title: l10n.linkedCaregivers),
                ),
                caregiverLinksAsync.maybeWhen(
                  data: (links) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${links.length}/$maxCaregivers',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!isPremium) ...[
                          const SizedBox(width: AppSpacing.xs),
                          const PremiumBadge.iconOnly(),
                        ],
                      ],
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
            caregiverLinksAsync.when(
              data: (links) {
                if (links.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: MpEmptyState(
                      icon: Icons.people_outline,
                      title: 'No caregivers linked yet',
                    ),
                  );
                }
                return Column(
                  children: links.map((link) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: CaregiverListTile(
                        link: link,
                        onRevoke: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Revoke Access'),
                              content: Text(
                                'Are you sure you want to revoke access for ${link.caregiverName}?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Revoke'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            try {
                              // Call Cloud Function to revoke server-side
                              final cfService = ref.read(cloudFunctionsServiceProvider);
                              await cfService.revokeAccess(
                                caregiverId: link.caregiverId,
                                linkId: link.id,
                              );
                              // Remove local record
                              await ref.read(caregiverLinksProvider.notifier).removeLink(link.id);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Access revoked successfully'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to revoke access: $e'),
                                  ),
                                );
                              }
                            }
                          }
                        },
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text('Error loading caregivers: $error'),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const QrInviteSection(),
            const SizedBox(height: AppSpacing.xl),
            const PrivacyNotice(),
          ],
        ),
      ),
    );
  }
}
