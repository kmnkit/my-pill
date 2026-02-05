import 'package:flutter/material.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';
import 'package:my_pill/presentation/shared/widgets/mp_radio_option.dart';

enum UserRole { patient, caregiver }

class OnboardingRoleStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final ValueChanged<String> onRoleChanged;
  final String initialRole;

  const OnboardingRoleStep({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.onRoleChanged,
    this.initialRole = 'patient',
  });

  @override
  State<OnboardingRoleStep> createState() => _OnboardingRoleStepState();
}

class _OnboardingRoleStepState extends State<OnboardingRoleStep> {
  late UserRole _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole == 'caregiver'
        ? UserRole.caregiver
        : UserRole.patient;
  }

  void _onRoleSelected(UserRole role) {
    setState(() {
      _selectedRole = role;
    });
    widget.onRoleChanged(role == UserRole.caregiver ? 'caregiver' : 'patient');
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
                Icons.people_outline,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                l10n.onboardingRoleTitle,
                style: textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),

              // Subtitle
              Text(
                l10n.onboardingRoleSubtitle,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // Role options
              MpRadioOption<UserRole>(
                value: UserRole.patient,
                groupValue: _selectedRole,
                onChanged: _onRoleSelected,
                icon: Icons.person,
                label: l10n.onboardingRolePatient,
                description: l10n.onboardingRolePatientDesc,
              ),
              const SizedBox(height: AppSpacing.md),
              MpRadioOption<UserRole>(
                value: UserRole.caregiver,
                groupValue: _selectedRole,
                onChanged: _onRoleSelected,
                icon: Icons.favorite,
                label: l10n.onboardingRoleCaregiver,
                description: l10n.onboardingRoleCaregiverDesc,
              ),
            ],
          ),

          const Spacer(),

          // Next button
          MpButton(
            label: l10n.onboardingNext,
            onPressed: widget.onNext,
            variant: MpButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
