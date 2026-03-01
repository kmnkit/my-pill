import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/utils/error_handler.dart';
import 'package:kusuridoki/data/providers/caregiver_monitoring_provider.dart';
import 'package:kusuridoki/data/providers/invite_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/caregivers/widgets/patient_data_card.dart';
import 'package:kusuridoki/presentation/screens/caregivers/widgets/qr_scanner_screen.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_empty_state.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_error_view.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_shimmer.dart';
import 'package:kusuridoki/presentation/shared/widgets/gradient_scaffold.dart';

class CaregiverDashboardScreen extends ConsumerStatefulWidget {
  const CaregiverDashboardScreen({super.key});

  @override
  ConsumerState<CaregiverDashboardScreen> createState() =>
      _CaregiverDashboardScreenState();
}

class _CaregiverDashboardScreenState
    extends ConsumerState<CaregiverDashboardScreen> {
  Future<void> _scanQrCode() async {
    final code = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const QrScannerScreen()),
    );

    if (code != null && mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.processingInvite),
          duration: const Duration(seconds: 2),
        ),
      );

      try {
        final cfService = ref.read(cloudFunctionsServiceProvider);
        await cfService.acceptInvite(code);

        ref.invalidate(caregiverPatientsProvider);

        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.inviteAccepted),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } catch (e, st) {
        ErrorHandler.debugLog(e, st, 'acceptInviteQr');
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.failedToAcceptInvite),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final patientsAsync = ref.watch(caregiverPatientsProvider);

    return GradientScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.myPatients,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: patientsAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: KdListShimmer(itemCount: 3),
                  ),
                  error: (error, stack) => KdErrorView(
                    error: error,
                    onRetry: () => ref.invalidate(caregiverPatientsProvider),
                  ),
                  data: (patients) {
                    if (patients.isEmpty) {
                      return KdEmptyState(
                        icon: Icons.people_outline,
                        title: l10n.noPatientsLinked,
                        description: l10n.noPatientsLinkedDesc,
                        actionLabel: l10n.scanQrCode,
                        onAction: _scanQrCode,
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(
                        bottom: AppSpacing.navBarClearance,
                      ),
                      itemCount: patients.length,
                      itemBuilder: (context, index) {
                        final patient = patients[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < patients.length - 1
                                ? AppSpacing.lg
                                : 0,
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
