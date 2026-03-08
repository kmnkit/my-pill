import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:kusuridoki/data/models/reminder.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  static String _language = 'ja';
  static void setLanguage(String language) => _language = language;

  _NotificationL10n get _l10n => _NotificationL10n._(_language);

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Callback for notification actions
  static void Function(String reminderId, String action)? onNotificationAction;

  /// Initialize timezone data (call once at app startup)
  static Future<void> initializeTimezone() async {
    tz_data.initializeTimeZones();
  }

  Future<void> initialize() async {
    // Initialize timezone
    await initializeTimezone();

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // Create notification channels (Android)
    await _createChannels();

    // NOTE: Permission request removed from initialize()
    // Permission should be requested explicitly via UI (e.g., onboarding)
    // to ensure users see the system permission dialog

    // Initialize FCM
    await _initializeFCM();
  }

  Future<void> _createChannels() async {
    final android = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      // Standard medication reminder channel
      const channel1 = AndroidNotificationChannel(
        'medication_reminders',
        'Medication Reminders',
        description: 'Reminders to take your medication',
        importance: Importance.high,
      );
      await android.createNotificationChannel(channel1);

      // Critical alert channel (T5.3)
      const channel2 = AndroidNotificationChannel(
        'critical_medication',
        'Critical Medication Alerts',
        description: 'Critical medication alerts that bypass Do Not Disturb',
        importance: Importance.max,
      );
      await android.createNotificationChannel(channel2);
    }
  }

  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final iosPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final granted = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final granted = await androidPlugin?.requestNotificationsPermission();
      return granted ?? false;
    }
    return false;
  }

  /// Check current notification permission status without requesting.
  /// Useful for checking if permission was already granted (e.g., from previous install).
  Future<bool> checkPermissionStatus() async {
    if (Platform.isIOS) {
      final settings = await _fcm.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    }
    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final areEnabled = await androidPlugin?.areNotificationsEnabled();
      return areEnabled ?? false;
    }
    return false;
  }

  Future<void> _initializeFCM() async {
    try {
      // NOTE: FCM permission request removed from initialize()
      // Permission should be requested explicitly via UI (e.g., onboarding)
      // FCM will still work once permission is granted via local notifications

      final token = await _fcm.getToken();
      if (kDebugMode) {
        debugPrint('FCM Token: $token');
      }

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen(_handleFCMMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleFCMMessage);
    } catch (e) {
      debugPrint('FCM not configured: $e');
    }
  }

  void _handleFCMMessage(RemoteMessage message) {
    // Handle incoming FCM messages
    if (kDebugMode) {
      debugPrint('FCM message: ${message.data}');
    }
  }

  // Schedule a local notification for a reminder
  Future<void> scheduleReminder(
    Reminder reminder,
    String medicationName,
    String dosage, {
    String? dosageTimingLabel,
  }) async {
    final scheduledTime = reminder.scheduledTime;
    if (scheduledTime.isBefore(DateTime.now())) {
      return; // Don't schedule past notifications
    }

    // T5.2: Notification actions
    final l10n = _l10n;
    final takeAction = AndroidNotificationAction(
      'take',
      l10n.actionTake,
      showsUserInterface: true,
    );
    final snoozeAction = AndroidNotificationAction('snooze', l10n.actionSnooze);
    final skipAction = AndroidNotificationAction('skip', l10n.actionSkip);

    final androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Medication Reminders',
      channelDescription: 'Reminders to take your medication',
      importance: Importance.high,
      priority: Priority.high,
      actions: [takeAction, snoozeAction, skipAction],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'medication_reminder',
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Use deterministic hash for stable notification IDs across sessions
    final notificationId = _stableId(reminder.id);

    await _localNotifications.zonedSchedule(
      id: notificationId,
      title: l10n.reminderTitle(medicationName),
      body: l10n.reminderBody(dosage, timingLabel: dosageTimingLabel),
      scheduledDate: _convertToTZDateTime(scheduledTime),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: reminder.id,
    );
  }

  // T5.3: Schedule critical alert (iOS - bypasses DND)
  Future<void> scheduleCriticalReminder(
    Reminder reminder,
    String medicationName,
    String dosage, {
    String? dosageTimingLabel,
  }) async {
    final scheduledTime = reminder.scheduledTime;
    if (scheduledTime.isBefore(DateTime.now())) return;

    final l10n = _l10n;
    final androidDetails = AndroidNotificationDetails(
      'critical_medication',
      'Critical Medication Alerts',
      channelDescription: 'Critical medication alerts',
      importance: Importance.max,
      priority: Priority.max,
      actions: [
        AndroidNotificationAction('take', l10n.actionTake, showsUserInterface: true),
        AndroidNotificationAction('snooze', l10n.actionSnooze),
        AndroidNotificationAction('skip', l10n.actionSkip),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.zonedSchedule(
      id: _stableId(reminder.id),
      title: l10n.criticalTitle(medicationName),
      body: l10n.criticalBody(dosage, timingLabel: dosageTimingLabel),
      scheduledDate: _convertToTZDateTime(scheduledTime),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: reminder.id,
    );
  }

  // Cancel a scheduled notification
  Future<void> cancelReminder(String reminderId) async {
    await _localNotifications.cancel(id: _stableId(reminderId));
  }

  // Cancel all notifications
  Future<void> cancelAll() async {
    await _localNotifications.cancelAll();
  }

  // Schedule all reminders for today
  Future<void> scheduleTodayReminders(
    List<Reminder> reminders,
    Map<
      String,
      ({String name, String dosage, bool isCritical, String? dosageTimingLabel})
    >
    medicationInfo,
  ) async {
    for (final reminder in reminders) {
      final info = medicationInfo[reminder.medicationId];
      if (info == null) continue;

      try {
        if (info.isCritical) {
          await scheduleCriticalReminder(
            reminder,
            info.name,
            info.dosage,
            dosageTimingLabel: info.dosageTimingLabel,
          );
        } else {
          await scheduleReminder(
            reminder,
            info.name,
            info.dosage,
            dosageTimingLabel: info.dosageTimingLabel,
          );
        }
      } catch (e) {
        debugPrint('Failed to schedule reminder ${reminder.id}: $e');
      }
    }
  }

  /// Show immediate notification for low stock
  Future<void> showLowStockNotification(
    String medicationName,
    int remaining,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Medication Reminders',
      channelDescription: 'Reminders to take your medication',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Use a unique ID based on medication name to avoid duplicate notifications
    final notificationId = _stableId('low_stock_$medicationName');

    final l10n = _l10n;
    await _localNotifications.show(
      id: notificationId,
      title: l10n.lowStockTitle(medicationName),
      body: l10n.lowStockBody(remaining),
      notificationDetails: details,
    );
  }

  // Handle notification response (tap or action)
  static void _onNotificationResponse(NotificationResponse response) {
    final reminderId = response.payload;
    if (reminderId == null) return;

    final action = response.actionId ?? 'open';
    onNotificationAction?.call(reminderId, action);
  }

  // Background notification handler (must be top-level function)
  @pragma('vm:entry-point')
  static void _onBackgroundResponse(NotificationResponse response) {
    _onNotificationResponse(response);
  }

  // Helper to convert DateTime to TZDateTime
  static tz.TZDateTime _convertToTZDateTime(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, tz.local);
  }

  /// Deterministic, session-stable hash for notification IDs.
  /// Dart's String.hashCode can vary between VM sessions, so we use FNV-1a 32-bit.
  static int _stableId(String value) {
    final bytes = utf8.encode(value);
    var hash = 0x811c9dc5; // FNV offset basis
    for (final byte in bytes) {
      hash ^= byte;
      hash = (hash * 0x01000193) & 0xFFFFFFFF; // FNV prime, keep 32-bit
    }
    return hash & 0x7FFFFFFF; // ensure positive
  }
}

/// Notification string lookup for supported languages.
/// Kept inline because this service runs without BuildContext.
class _NotificationL10n {
  const _NotificationL10n._(this._lang);
  final String _lang;

  bool get _isJa => _lang == 'ja';

  String reminderTitle(String name) =>
      _isJa ? '$nameの服薬時間です' : 'Time to take $name';

  String reminderBody(String dosage, {String? timingLabel}) {
    if (_isJa) {
      return timingLabel != null
          ? '$dosage（$timingLabel）- タップして記録'
          : '$dosage - タップして記録';
    }
    return timingLabel != null
        ? '$dosage ($timingLabel) - Tap to respond'
        : '$dosage - Tap to respond';
  }

  String criticalTitle(String name) =>
      _isJa ? '重要：$nameの服薬時間' : 'CRITICAL: Take $name';

  String criticalBody(String dosage, {String? timingLabel}) {
    if (_isJa) {
      return timingLabel != null
          ? '$dosage（$timingLabel）- 重要なお薬です'
          : '$dosage - 重要なお薬です';
    }
    return timingLabel != null
        ? '$dosage ($timingLabel) - This medication is marked as critical'
        : '$dosage - This medication is marked as critical';
  }

  String lowStockTitle(String name) =>
      _isJa ? '在庫不足：$name' : 'Low Stock Alert: $name';

  String lowStockBody(int remaining) => _isJa
      ? '残り$remaining回分です。補充をお忘れなく'
      : 'Only $remaining doses remaining. Time to refill!';

  String get actionTake => _isJa ? '飲んだ' : 'Take Now';
  String get actionSnooze => _isJa ? '15分後' : 'Snooze 15min';
  String get actionSkip => _isJa ? 'スキップ' : 'Skip';
}
