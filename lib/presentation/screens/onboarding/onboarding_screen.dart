import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/data/providers/auth_provider.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/presentation/screens/onboarding/widgets/onboarding_welcome_step.dart';
import 'package:my_pill/presentation/screens/onboarding/widgets/onboarding_name_step.dart';
import 'package:my_pill/presentation/screens/onboarding/widgets/onboarding_role_step.dart';
import 'package:my_pill/presentation/screens/onboarding/widgets/onboarding_timezone_step.dart';
import 'package:my_pill/presentation/screens/onboarding/widgets/onboarding_notification_step.dart';
import 'package:my_pill/presentation/screens/onboarding/widgets/onboarding_progress_indicator.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;
  int _currentStep = 0;
  bool _isCompleting = false;

  // Collected user data
  String _userName = '';
  String _userRole = 'patient';
  late String _timezone;
  bool _notificationsEnabled = false;

  static const int _totalSteps = 5;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timezone = tz.local.name;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    if (step >= 0 && step < _totalSteps) {
      _pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep = step;
      });
    }
  }

  void _nextStep() {
    _goToStep(_currentStep + 1);
  }

  void _previousStep() {
    _goToStep(_currentStep - 1);
  }

  Future<void> _completeOnboarding() async {
    if (_isCompleting) return;

    setState(() => _isCompleting = true);

    try {
      final settingsNotifier = ref.read(userSettingsProvider.notifier);
      final authService = ref.read(authServiceProvider);

      // Save all collected data
      if (_userName.isNotEmpty) {
        await settingsNotifier.updateName(_userName);
      }
      await settingsNotifier.updateUserRole(_userRole);
      await settingsNotifier.updateHomeTimezone(_timezone);
      await settingsNotifier.updateNotificationsEnabled(_notificationsEnabled);

      // Sign in anonymously
      await authService.signInAnonymously();

      // Mark onboarding as complete
      await settingsNotifier.completeOnboarding();

      if (mounted) {
        // Navigate based on role
        final destination =
            _userRole == 'caregiver' ? '/caregiver/patients' : '/home';
        context.go(destination);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete setup: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCompleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator (hidden on first step)
            if (_currentStep > 0)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: OnboardingProgressIndicator(
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                ),
              ),

            // Page content
            Expanded(
              child: _isCompleting
                  ? const Center(child: CircularProgressIndicator())
                  : PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          _currentStep = index;
                        });
                      },
                      children: [
                        // Step 1: Welcome
                        OnboardingWelcomeStep(
                          onNext: _nextStep,
                        ),

                        // Step 2: Name
                        OnboardingNameStep(
                          initialName: _userName,
                          onNameChanged: (name) {
                            _userName = name;
                          },
                          onNext: _nextStep,
                          onBack: _previousStep,
                          onSkip: _nextStep,
                        ),

                        // Step 3: Role
                        OnboardingRoleStep(
                          initialRole: _userRole,
                          onRoleChanged: (role) {
                            _userRole = role;
                          },
                          onNext: _nextStep,
                          onBack: _previousStep,
                        ),

                        // Step 4: Timezone
                        OnboardingTimezoneStep(
                          initialTimezone: _timezone,
                          onTimezoneChanged: (timezone) {
                            _timezone = timezone;
                          },
                          onNext: _nextStep,
                          onBack: _previousStep,
                        ),

                        // Step 5: Notifications
                        OnboardingNotificationStep(
                          onNotificationChanged: (enabled) {
                            _notificationsEnabled = enabled;
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
