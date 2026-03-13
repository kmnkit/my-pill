import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/core/theme/app_theme.dart';
import 'package:kusuridoki/presentation/router/app_router_provider.dart';
import 'package:kusuridoki/data/services/notification_service.dart';
import 'package:kusuridoki/data/services/reminder_service.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/deep_link_provider.dart';
import 'package:kusuridoki/data/providers/storage_service_provider.dart';
import 'package:kusuridoki/data/providers/reminder_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/data/providers/timezone_provider.dart';

class KusuridokiApp extends ConsumerStatefulWidget {
  const KusuridokiApp({super.key});

  @override
  ConsumerState<KusuridokiApp> createState() => _KusuridokiAppState();
}

class _KusuridokiAppState extends ConsumerState<KusuridokiApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Eagerly initialize DeepLinkService so getInitialLink() is called
    // before SplashScreen navigates away, preventing cold-start link loss.
    ref.read(deepLinkServiceProvider);

    // Set up notification action callback
    NotificationService.onNotificationAction = _handleNotificationAction;

    // Generate and schedule today's reminders on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateAndScheduleReminders();
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

    Sentry.addBreadcrumb(Breadcrumb(
      message: 'App lifecycle: ${state.name}',
      category: 'lifecycle',
      data: {'state': state.name},
    ));

    if (state == AppLifecycleState.resumed) {
      _onAppResumed();
    }
  }

  Future<void> _generateAndScheduleReminders() async {
    try {
      // Clean up old reminders before generating today's
      final storage = ref.read(storageServiceProvider);
      await storage.deleteRemindersBeforeDate(DateTime.now());

      // Sync notification language with user preference before scheduling
      final profile = await storage.getUserProfile();
      NotificationService.setLanguage(profile?.language ?? 'ja');

      // Use the provider method to generate and schedule
      await ref
          .read(todayRemindersProvider.notifier)
          .generateAndScheduleToday();
    } catch (e) {
      debugPrint('Failed to generate reminders on app start: $e');
    }
  }

  Future<void> _onAppResumed() async {
    try {
      final storage = ref.read(storageServiceProvider);
      final reminderService = ReminderService(storage);

      // Re-detect device timezone (may have changed while app was backgrounded).
      // If timezone changed, timezoneSettingsProvider updates → ref.listen in
      // TodayReminders.build() triggers _rescheduleAll() automatically.
      await ref.read(timezoneSettingsProvider.notifier).refreshDeviceTimezone();

      // Sync notification language on resume (handles mid-session language changes)
      final profile = await storage.getUserProfile();
      NotificationService.setLanguage(profile?.language ?? 'ja');

      // Clean up old reminders before processing today's
      await storage.deleteRemindersBeforeDate(DateTime.now());

      // Check and mark missed reminders
      await reminderService.checkAndMarkMissed();

      // Regenerate and reschedule today's reminders
      await ref
          .read(todayRemindersProvider.notifier)
          .generateAndScheduleToday();
    } catch (e) {
      debugPrint('Failed to check missed reminders on resume: $e');
    }
  }

  void _handleNotificationAction(String reminderId, String action) {
    Sentry.addBreadcrumb(Breadcrumb(
      message: 'Notification action: $action',
      category: 'notification',
      data: {'action': action},
    ));

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

    // Set Sentry user context on auth state changes
    ref.listen(authStateProvider, (previous, next) {
      next.whenData((user) {
        Sentry.configureScope((scope) {
          scope.setUser(user != null ? SentryUser(id: user.uid) : null);
        });
      });
    });

    return settingsAsync.when(
      loading: () => MaterialApp.router(
        title: 'Kusuridoki',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
      error: (_, _) => MaterialApp.router(
        title: 'Kusuridoki',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
      data: (settings) => MaterialApp.router(
        title: 'Kusuridoki',
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
