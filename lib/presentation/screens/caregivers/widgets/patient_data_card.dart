import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/data/providers/caregiver_monitoring_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/caregivers/widgets/patient_card.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_shimmer.dart';

class PatientDataCard extends ConsumerWidget {
  const PatientDataCard({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  final String patientId;
  final String patientName;

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts[0].isEmpty ? '?' : parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final adherenceAsync = ref.watch(patientDailyAdherenceProvider(patientId));
    final medicationsAsync = ref.watch(
      patientMedicationStatusProvider(patientId),
    );

    final adherenceText = adherenceAsync.when(
      loading: () => l10n.loading,
      error: (_, _) => 'N/A',
      data: (value) => value == null ? '--' : '${value.toStringAsFixed(0)}%',
    );

    final medications = medicationsAsync.when(
      loading: () => <Map<String, dynamic>>[],
      error: (_, _) => <Map<String, dynamic>>[],
      data: (meds) => meds,
    );

    // Show skeleton/loading state if both are still loading
    if (adherenceAsync.isLoading && medicationsAsync.isLoading) {
      return _buildLoadingCard(context, l10n);
    }

    return PatientCard(
      name: patientName,
      initials: _getInitials(patientName),
      adherence: adherenceText,
      medications: medications,
    );
  }

  Widget _buildLoadingCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  _getInitials(patientName),
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.loadingAdherence,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.appColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const KdShimmerBox(height: 24),
        ],
      ),
    );
  }
}
