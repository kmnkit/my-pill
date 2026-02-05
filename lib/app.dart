import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/core/theme/app_theme.dart';
import 'package:my_pill/presentation/router/app_router_provider.dart';
import 'package:my_pill/data/services/notification_service.dart';
import 'package:my_pill/data/services/reminder_service.dart';
import 'package:my_pill/data/providers/storage_service_provider.dart';
import 'package:my_pill/data/providers/reminder_provider.dart';
import 'package:my_pill/data/providers/ad_provider.dart';
import 'package:my_pill/data/providers/interstitial_provider.dart';
import 'package:my_pill/data/providers/settings_provider.dart';

class MyPillApp extends ConsumerStatefulWidget {
  const MyPillApp({super.key});

  @override
  ConsumerState<MyPillApp> createState() => _MyPillAppState();
}

class _MyPillAppState extends ConsumerState<MyPillApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Set up notification action callback
    NotificationService.onNotificationAction = _handleNotificationAction;

    // Generate and schedule today's reminders on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateAndScheduleReminders();
      // Pre-load interstitial ad
      ref.read(adServiceProvider).loadInterstitial();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      ref.read(interstitialControllerProvider).onAppPaused();
    }

    if (state == AppLifecycleState.resumed) {
      _onAppResumed();
      ref.read(interstitialControllerProvider).onAppResumed();
    }
  }

  Future<void> _generateAndScheduleReminders() async {
    try {
      // Use the provider method to generate and schedule
      await ref.read(todayRemindersProvider.notifier).generateAndScheduleToday();
    } catch (e) {
      debugPrint('Failed to generate reminders on app start: $e');
    }
  }

  Future<void> _onAppResumed() async {
    try {
      final storage = ref.read(storageServiceProvider);
      final reminderService = ReminderService(storage);

      // Check and mark missed reminders
      await reminderService.checkAndMarkMissed();

      // Regenerate and reschedule today's reminders
      await ref.read(todayRemindersProvider.notifier).generateAndScheduleToday();
    } catch (e) {
      debugPrint('Failed to check missed reminders on resume: $e');
    }
  }

  void _handleNotificationAction(String reminderId, String action) {
    try {
      final notifier = ref.read(todayRemindersProvider.notifier);

      switch (action) {
        case 'take':
          notifier.markAsTaken(reminderId);
          break;
        case 'snooze':
          notifier.snooze(reminderId, const Duration(minutes: 15));
          break;
        case 'skip':
          notifier.markAsSkipped(reminderId);
          break;
        default:
          debugPrint('Unknown notification action: $action');
      }
    } catch (e) {
      debugPrint('Failed to handle notification action: $e');
    }
  }

  Locale _getLocaleFromLanguage(String language) {
    switch (language) {
      case 'ja':
        return const Locale('ja');
      case 'en':
      default:
        return const Locale('en');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(userSettingsProvider);
    final router = ref.watch(appRouterProvider);

    return settingsAsync.when(
      loading: () => MaterialApp.router(
        title: 'MyPill',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
      error: (error, stack) => MaterialApp.router(
        title: 'MyPill',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
      data: (settings) => MaterialApp.router(
        title: 'MyPill',
        debugShowCheckedModeBanner: false,
        locale: _getLocaleFromLanguage(settings.language),
        theme: AppTheme.resolve(
          highContrast: settings.highContrast,
          textSize: settings.textSize,
          brightness: Brightness.light,
        ),
        darkTheme: AppTheme.resolve(
          highContrast: settings.highContrast,
          textSize: settings.textSize,
          brightness: Brightness.dark,
        ),
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
