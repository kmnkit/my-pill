import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/caregiver_provider.dart';
import 'package:my_pill/presentation/screens/caregivers/widgets/patient_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_empty_state.dart';

class CaregiverDashboardScreen extends ConsumerWidget {
  const CaregiverDashboardScreen({super.key});

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caregiverLinksAsync = ref.watch(caregiverLinksProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Patients',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: caregiverLinksAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text('Error: $error'),
                  ),
                  data: (links) {
                    if (links.isEmpty) {
                      return MpEmptyState(
                        icon: Icons.people_outline,
                        title: 'No patients linked',
                        description: 'Ask patients to share their invite code with you',
                      );
                    }

                    return ListView.builder(
                      itemCount: links.length,
                      itemBuilder: (context, index) {
                        final link = links[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < links.length - 1 ? AppSpacing.lg : 0,
                          ),
                          child: PatientCard(
                            name: link.caregiverName,
                            initials: _getInitials(link.caregiverName),
                            adherence: 'Loading...',
                            medications: const [],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
