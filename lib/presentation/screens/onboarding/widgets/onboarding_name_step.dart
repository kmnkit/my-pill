import 'package:flutter/material.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';
import 'package:my_pill/presentation/shared/widgets/mp_text_field.dart';

class OnboardingNameStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onSkip;
  final ValueChanged<String> onNameChanged;
  final String initialName;

  const OnboardingNameStep({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.onSkip,
    required this.onNameChanged,
    this.initialName = '',
  });

  @override
  State<OnboardingNameStep> createState() => _OnboardingNameStepState();
}

class _OnboardingNameStepState extends State<OnboardingNameStep> {
  late final TextEditingController _nameController;
  bool _hasName = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _hasName = widget.initialName.trim().isNotEmpty;
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    final name = _nameController.text.trim();
    final hasName = name.isNotEmpty;
    if (hasName != _hasName) {
      setState(() {
        _hasName = hasName;
      });
    }
    widget.onNameChanged(name);
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
                Icons.person_outline,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                l10n.onboardingNameTitle,
                style: textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),

              // Subtitle
              Text(
                l10n.onboardingNameSubtitle,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // Name input field
              MpTextField(
                controller: _nameController,
                hint: l10n.onboardingNameHint,
                prefixIcon: Icons.person,
                keyboardType: TextInputType.name,
              ),
            ],
          ),

          const Spacer(),

          // Skip button
          TextButton(
            onPressed: widget.onSkip,
            child: Text(
              l10n.onboardingNameSkip,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Next button
          MpButton(
            label: l10n.onboardingNext,
            onPressed: _hasName ? widget.onNext : null,
            variant: MpButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
