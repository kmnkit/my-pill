import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/data/providers/settings_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  static const _splashBackgroundColor = Color(0xFFFFF5F0);
  static const _splashDuration = Duration(seconds: 2);
  static const _fadeInDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: _fadeInDuration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();

    Future.delayed(_splashDuration, _navigateToNextScreen);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    final settingsAsync = ref.read(userSettingsProvider);

    settingsAsync.when(
      data: (settings) {
        if (!mounted) return;

        if (!settings.onboardingComplete) {
          context.go('/onboarding');
        } else if (settings.userRole == 'caregiver') {
          context.go('/caregiver/patients');
        } else {
          context.go('/home');
        }
      },
      loading: () {
        if (!mounted) return;
        context.go('/onboarding');
      },
      error: (error, stackTrace) {
        if (!mounted) return;
        context.go('/onboarding');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _splashBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'assets/icons/icon.png',
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
