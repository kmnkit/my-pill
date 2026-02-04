import 'package:flutter/material.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/services/notification_service.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';

class OnboardingNotificationStep extends StatefulWidget {
  final VoidCallback onFinish;
  final VoidCallback onBack;
  final ValueChanged<bool> onNotificationChanged;

  const OnboardingNotificationStep({
    super.key,
    required this.onFinish,
    required this.onBack,
    required this.onNotificationChanged,
  });

  @override
  State<OnboardingNotificationStep> createState() =>
      _OnboardingNotificationStepState();
}

class _OnboardingNotificationStepState
    extends State<OnboardingNotificationStep> {
  bool _isRequesting = false;
  bool? _permissionGranted;

  @override
  void initState() {
    super.initState();
    _checkExistingPermission();
  }

  /// Check if permission was already granted (e.g., from previous install).
  Future<void> _checkExistingPermission() async {
    final status = await NotificationService().checkPermissionStatus();
    if (status && mounted) {
      setState(() {
        _permissionGranted = true;
      });
      widget.onNotificationChanged(true);
    }
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isRequesting = true;
    });

    try {
      final granted = await NotificationService().requestPermissions();
      setState(() {
        _permissionGranted = granted;
        _isRequesting = false;
      });
      widget.onNotificationChanged(granted);
    } catch (e) {
      setState(() {
        _permissionGranted = false;
        _isRequesting = false;
      });
      widget.onNotificationChanged(false);
    }
  }

  void _skip() {
    widget.onNotificationChanged(false);
    widget.onFinish();
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
              // Icon with status indicator
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: 80,
                    color: _permissionGranted == true
                        ? AppColors.success
                        : AppColors.primary,
                  ),
                  if (_permissionGranted == true)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                l10n.onboardingNotificationTitle,
                style: textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),

              // Subtitle
              Text(
                l10n.onboardingNotificationSubtitle,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // Permission status
              if (_permissionGranted != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: _permissionGranted!
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _permissionGranted!
                            ? Icons.check_circle
                            : Icons.info_outline,
                        color: _permissionGranted!
                            ? AppColors.success
                            : AppColors.warning,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        _permissionGranted!
                            ? l10n.onboardingNotificationEnabled
                            : l10n.onboardingNotificationDenied,
                        style: textTheme.bodyMedium?.copyWith(
                          color: _permissionGranted!
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],

              // Enable notifications button (only show if not yet granted)
              if (_permissionGranted != true)
                _isRequesting
                    ? const SizedBox(
                        height: 48,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : MpButton(
                        label: l10n.onboardingNotificationEnable,
                        onPressed: _requestPermission,
                        variant: MpButtonVariant.primary,
                      ),
            ],
          ),

          const Spacer(),

          // Skip button (only show if not yet granted)
          if (_permissionGranted != true)
            TextButton(
              onPressed: _skip,
              child: Text(
                l10n.onboardingNotificationSkip,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),

          // Finish button
          MpButton(
            label: l10n.onboardingFinish,
            onPressed: widget.onFinish,
            variant: MpButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
