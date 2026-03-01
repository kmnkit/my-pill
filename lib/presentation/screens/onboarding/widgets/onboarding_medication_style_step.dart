import 'package:flutter/material.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_button.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_radio_option.dart';

class OnboardingMedicationStyleStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final ValueChanged<bool> onStyleSelected;
  final bool initialIsIppoka;

  const OnboardingMedicationStyleStep({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.onStyleSelected,
    this.initialIsIppoka = false,
  });

  @override
  State<OnboardingMedicationStyleStep> createState() =>
      _OnboardingMedicationStyleStepState();
}

class _OnboardingMedicationStyleStepState
    extends State<OnboardingMedicationStyleStep> {
  late bool _isIppoka;

  @override
  void initState() {
    super.initState();
    _isIppoka = widget.initialIsIppoka;
  }

  void _onSelected(bool value) {
    setState(() {
      _isIppoka = value;
    });
    widget.onStyleSelected(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Back button
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: widget.onBack,
              icon: const Icon(Icons.arrow_back),
              label: Text(l10n.onboardingBack),
            ),
          ),

          const Spacer(),

          // Center content
          Column(
            children: [
              // Icon
              Icon(
                Icons.medical_services_outlined,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                l10n.onboardingMedStyleTitle,
                style: textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),

              // Subtitle
              Text(
                l10n.onboardingMedStyleSubtitle,
                style: textTheme.bodyLarge?.copyWith(
                  color: context.appColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // Options
              KdRadioOption<bool>(
                value: false,
                groupValue: _isIppoka,
                onChanged: _onSelected,
                icon: Icons.medication_outlined,
                label: l10n.onboardingIndividualPills,
                description: l10n.onboardingIndividualPillsDesc,
              ),
              const SizedBox(height: AppSpacing.md),
              KdRadioOption<bool>(
                value: true,
                groupValue: _isIppoka,
                onChanged: _onSelected,
                icon: Icons.inventory_2_outlined,
                label: l10n.onboardingDosePack,
                description: l10n.onboardingDosePackDesc,
              ),
            ],
          ),

          const Spacer(),

          // Next button
          KdButton(
            label: l10n.onboardingNext,
            onPressed: widget.onNext,
            variant: MpButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
