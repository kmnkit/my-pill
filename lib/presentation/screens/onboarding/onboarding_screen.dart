import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/presentation/screens/onboarding/widgets/onboarding_medication_style_step.dart';
import 'package:my_pill/presentation/screens/onboarding/widgets/onboarding_name_step.dart';
import 'package:my_pill/presentation/screens/onboarding/widgets/onboarding_notification_step.dart';
import 'package:my_pill/presentation/screens/onboarding/widgets/onboarding_progress_indicator.dart';
import 'package:my_pill/presentation/screens/onboarding/widgets/onboarding_role_step.dart';
import 'package:my_pill/presentation/screens/onboarding/widgets/onboarding_timezone_step.dart';
import 'package:my_pill/presentation/screens/onboarding/widgets/onboarding_welcome_step.dart';
import 'package:my_pill/presentation/shared/widgets/gradient_scaffold.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  static const int _totalSteps = 6;

  // Collected onboarding data
  String _selectedRole = 'patient';
  String _userName = '';
  String _selectedTimezone = tz.local.name;
  bool _isIppoka = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentStep = step;
    });
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _goToStep(_currentStep + 1);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _goToStep(_currentStep - 1);
    }
  }

  Future<void> _completeOnboarding() async {
    final notifier = ref.read(userSettingsProvider.notifier);

    // Save all collected data
    if (_userName.isNotEmpty) {
      await notifier.updateName(_userName);
    }
    await notifier.updateUserRole(_selectedRole);
    await notifier.updateHomeTimezone(_selectedTimezone);
    await notifier.updateDefaultIppoka(_isIppoka);
    await notifier.completeOnboarding();

    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: OnboardingProgressIndicator(
                currentStep: _currentStep,
                totalSteps: _totalSteps,
              ),
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: [
                  // Step 0: Welcome
                  OnboardingWelcomeStep(
                    onNext: _nextStep,
                  ),

                  // Step 1: Role
                  OnboardingRoleStep(
                    initialRole: _selectedRole,
                    onRoleChanged: (role) {
                      _selectedRole = role;
                    },
                    onNext: _nextStep,
                    onBack: _previousStep,
                  ),

                  // Step 2: Medication Style (一包化)
                  OnboardingMedicationStyleStep(
                    initialIsIppoka: _isIppoka,
                    onStyleSelected: (value) {
                      _isIppoka = value;
                    },
                    onNext: _nextStep,
                    onBack: _previousStep,
                  ),

                  // Step 3: Name
                  OnboardingNameStep(
                    initialName: _userName,
                    onNameChanged: (name) {
                      _userName = name;
                    },
                    onNext: _nextStep,
                    onBack: _previousStep,
                    onSkip: _nextStep,
                  ),

                  // Step 4: Timezone
                  OnboardingTimezoneStep(
                    initialTimezone: _selectedTimezone,
                    onTimezoneChanged: (timezone) {
                      _selectedTimezone = timezone;
                    },
                    onNext: _nextStep,
                    onBack: _previousStep,
                  ),

                  // Step 5: Notifications (final step)
                  OnboardingNotificationStep(
                    onNotificationChanged: (enabled) {
                      ref
                          .read(userSettingsProvider.notifier)
                          .updateNotificationsEnabled(enabled);
                    },
                    onFinish: _completeOnboarding,
                    onBack: _previousStep,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
