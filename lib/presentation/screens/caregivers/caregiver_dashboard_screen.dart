import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/core/utils/error_handler.dart';
import 'package:kusuridoki/data/providers/caregiver_monitoring_provider.dart';
import 'package:kusuridoki/data/providers/invite_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/caregivers/widgets/patient_data_card.dart';
import 'package:kusuridoki/presentation/screens/caregivers/widgets/qr_scanner_screen.dart';
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
    final canAdd = ref.watch(canAddPatientProvider).maybeWhen(
      data: (v) => v,
      orElse: () => true,
    );

    return GradientScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    l10n.myPatients,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const Spacer(),
                  if (canAdd)
                    IconButton(
                      icon: const Icon(Icons.person_add),
                      tooltip: l10n.addPatient,
                      onPressed: _scanQrCode,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: patientsAsync.when(
                  skipLoadingOnReload: true,
                  skipLoadingOnRefresh: true,
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
                      return _CaregiverConnectGuide(onScanQr: _scanQrCode);
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

class _CaregiverConnectGuide extends StatelessWidget {
  const _CaregiverConnectGuide({required this.onScanQr});

  final VoidCallback onScanQr;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: context.appColors.textMuted,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.noPatientsLinked,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.howToConnectPatient,
              style: textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            _StepItem(step: 1, text: l10n.connectStep1),
            const SizedBox(height: AppSpacing.sm),
            _StepItem(step: 2, text: l10n.connectStep2),
            const SizedBox(height: AppSpacing.sm),
            _StepItem(step: 3, text: l10n.connectStep3),
            const SizedBox(height: AppSpacing.xxl),
            ElevatedButton.icon(
              onPressed: onScanQr,
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(l10n.scanQrCode),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () {
                final shareText =
                    '1. ${l10n.connectStep1}\n2. ${l10n.connectStep2}\n3. ${l10n.connectStep3}';
                SharePlus.instance.share(ShareParams(text: shareText));
              },
              icon: const Icon(Icons.share),
              label: Text(l10n.shareConnectGuide),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({required this.step, required this.text});

  final int step;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
