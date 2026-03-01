import 'package:flutter/material.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_button.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_text_field.dart';

class OnboardingNameStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback? onSkip;
  final ValueChanged<String> onNameChanged;
  final String initialName;
  final bool isRequired;

  const OnboardingNameStep({
    super.key,
    required this.onNext,
    required this.onBack,
    this.onSkip,
    required this.onNameChanged,
    this.initialName = '',
    this.isRequired = false,
  });

  @override
  State<OnboardingNameStep> createState() => _OnboardingNameStepState();
}

class _OnboardingNameStepState extends State<OnboardingNameStep> {
  late final TextEditingController _nameController;
  bool _hasName = false;
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _hasName = _isNameValid(widget.initialName.trim());
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    super.dispose();
  }

  bool _isNameValid(String name) {
    return widget.isRequired ? name.length >= 2 : name.isNotEmpty;
  }

  void _onNameChanged() {
    final name = _nameController.text.trim();
    final newHasName = _isNameValid(name);
    final newHasInteracted = _hasInteracted || name.isNotEmpty;
    if (newHasName != _hasName || newHasInteracted != _hasInteracted) {
      setState(() {
        _hasName = newHasName;
        _hasInteracted = newHasInteracted;
      });
    }
    widget.onNameChanged(name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final showError = widget.isRequired && _hasInteracted && !_hasName;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
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

            // Scrollable center content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xxxl),

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
                      widget.isRequired
                          ? l10n.onboardingNameRequired
                          : l10n.onboardingNameSubtitle,
                      style: textTheme.bodyLarge?.copyWith(
                        color: context.appColors.textMuted,
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

                    // Validation error message
                    if (showError) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.onboardingNameMinLength,
                          style: textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Skip button (only shown when not required)
            if (widget.onSkip != null) ...[
              TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  widget.onSkip!();
                },
                child: Text(
                  l10n.onboardingNameSkip,
                  style: textTheme.bodyLarge?.copyWith(
                    color: context.appColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Next button
            MpButton(
              label: l10n.onboardingNext,
              onPressed: _hasName
                  ? () {
                      FocusScope.of(context).unfocus();
                      widget.onNext();
                    }
                  : null,
              variant: MpButtonVariant.primary,
            ),
          ],
        ),
      ),
    );
  }
}
