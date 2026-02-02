import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/presentation/screens/caregivers/widgets/patient_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_badge.dart';

class CaregiverDashboardScreen extends ConsumerWidget {
  const CaregiverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Wire to real caregiver data when Firebase is integrated in Phase 4
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
                child: ListView(
                  children: [
                    PatientCard(
                      name: 'Marco Tanaka',
                      initials: 'MT',
                      adherence: '2/3 taken',
                      medications: [
                        {
                          'name': 'Vitamin D',
                          'shape': PillShape.capsule,
                          'color': PillColor.blue,
                          'status': 'Taken',
                          'variant': MpBadgeVariant.taken,
                        },
                        {
                          'name': 'Omega-3',
                          'shape': PillShape.capsule,
                          'color': PillColor.yellow,
                          'status': 'Taken',
                          'variant': MpBadgeVariant.taken,
                        },
                        {
                          'name': 'Melatonin',
                          'shape': PillShape.round,
                          'color': PillColor.purple,
                          'status': 'Upcoming',
                          'variant': MpBadgeVariant.upcoming,
                        },
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    PatientCard(
                      name: 'Sato Keiko',
                      initials: 'SK',
                      adherence: '1/3 taken',
                      medications: [
                        {
                          'name': 'Aspirin',
                          'shape': PillShape.round,
                          'color': PillColor.white,
                          'status': 'Taken',
                          'variant': MpBadgeVariant.taken,
                        },
                        {
                          'name': 'Metformin',
                          'shape': PillShape.oval,
                          'color': PillColor.pink,
                          'status': 'Missed',
                          'variant': MpBadgeVariant.missed,
                        },
                        {
                          'name': 'Insulin',
                          'shape': PillShape.capsule,
                          'color': PillColor.orange,
                          'status': 'Low Stock',
                          'variant': MpBadgeVariant.lowStock,
                        },
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
