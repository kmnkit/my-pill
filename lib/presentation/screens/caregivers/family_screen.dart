import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/caregiver_provider.dart';
import 'package:my_pill/presentation/screens/caregivers/widgets/caregiver_list_tile.dart';
import 'package:my_pill/presentation/screens/caregivers/widgets/privacy_notice.dart';
import 'package:my_pill/presentation/screens/caregivers/widgets/qr_invite_section.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_empty_state.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';

class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caregiverLinksAsync = ref.watch(caregiverLinksProvider);

    return Scaffold(
      appBar: const MpAppBar(title: 'Family & Caregivers', showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MpSectionHeader(title: 'Linked Caregivers'),
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
                return const CaregiverListTile();
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
              error: (error, stack) => const CaregiverListTile(),
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
