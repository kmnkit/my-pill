import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/caregiver_monitoring_provider.dart';
import 'package:my_pill/presentation/screens/caregivers/widgets/patient_data_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_empty_state.dart';

class CaregiverDashboardScreen extends ConsumerWidget {
  const CaregiverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientsAsync = ref.watch(caregiverPatientsProvider);

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
                child: patientsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text('Error: $error'),
                  ),
                  data: (patients) {
                    if (patients.isEmpty) {
                      return MpEmptyState(
                        icon: Icons.people_outline,
                        title: 'No patients linked',
                        description: 'Ask patients to share their invite code with you',
                      );
                    }

                    return ListView.builder(
                      itemCount: patients.length,
                      itemBuilder: (context, index) {
                        final patient = patients[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < patients.length - 1 ? AppSpacing.lg : 0,
                          ),
                          child: PatientDataCard(
                            patientId: patient.patientId,
                            patientName: patient.patientName,
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
