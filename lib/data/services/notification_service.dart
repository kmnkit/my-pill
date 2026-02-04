import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:my_pill/data/models/reminder.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
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
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestCriticalPermission: true, // T5.3: Critical alerts
    );

    await _localNotifications.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
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
    final android = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
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
      final iosPlugin = _localNotifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      final granted = await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true, critical: true);
      return granted ?? false;
    }
    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
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
      final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
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
      debugPrint('FCM Token: $token');

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen(_handleFCMMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleFCMMessage);
    } catch (e) {
      debugPrint('FCM not configured: $e');
    }
  }

  void _handleFCMMessage(RemoteMessage message) {
    // Handle incoming FCM messages
    debugPrint('FCM message: ${message.data}');
  }

  // Schedule a local notification for a reminder
  Future<void> scheduleReminder(Reminder reminder, String medicationName, String dosage) async {
    final scheduledTime = reminder.scheduledTime;
    if (scheduledTime.isBefore(DateTime.now())) return; // Don't schedule past notifications

    // T5.2: Notification actions
    const takeAction = AndroidNotificationAction('take', 'Take Now', showsUserInterface: true);
    const snoozeAction = AndroidNotificationAction('snooze', 'Snooze 15min');
    const skipAction = AndroidNotificationAction('skip', 'Skip');

    final androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Medication Reminders',
      channelDescription: 'Reminders to take your medication',
      importance: Importance.high,
      priority: Priority.high,
      actions: const [takeAction, snoozeAction, skipAction],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'medication_reminder',
    );

    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    // Use reminder ID hashCode as notification ID
    final notificationId = reminder.id.hashCode;

    await _localNotifications.zonedSchedule(
      id: notificationId,
      title: 'Time to take $medicationName',
      body: '$dosage - Tap to respond',
      scheduledDate: _convertToTZDateTime(scheduledTime),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: reminder.id,
    );
  }

  // T5.3: Schedule critical alert (iOS - bypasses DND)
  Future<void> scheduleCriticalReminder(Reminder reminder, String medicationName, String dosage) async {
    final scheduledTime = reminder.scheduledTime;
    if (scheduledTime.isBefore(DateTime.now())) return;

    final androidDetails = AndroidNotificationDetails(
      'critical_medication',
      'Critical Medication Alerts',
      channelDescription: 'Critical medication alerts',
      importance: Importance.max,
      priority: Priority.max,
      actions: const [
        AndroidNotificationAction('take', 'Take Now', showsUserInterface: true),
        AndroidNotificationAction('snooze', 'Snooze 15min'),
        AndroidNotificationAction('skip', 'Skip'),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.critical,
    );

    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotifications.zonedSchedule(
      id: reminder.id.hashCode,
      title: 'CRITICAL: Take $medicationName',
      body: '$dosage - This medication is marked as critical',
      scheduledDate: _convertToTZDateTime(scheduledTime),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: reminder.id,
    );
  }

  // Cancel a scheduled notification
  Future<void> cancelReminder(String reminderId) async {
    await _localNotifications.cancel(id: reminderId.hashCode);
  }

  // Cancel all notifications
  Future<void> cancelAll() async {
    await _localNotifications.cancelAll();
  }

  // Schedule all reminders for today
  Future<void> scheduleTodayReminders(
    List<Reminder> reminders,
    Map<String, ({String name, String dosage, bool isCritical})> medicationInfo,
  ) async {
    for (final reminder in reminders) {
      final info = medicationInfo[reminder.medicationId];
      if (info == null) continue;

      if (info.isCritical) {
        await scheduleCriticalReminder(reminder, info.name, info.dosage);
      } else {
        await scheduleReminder(reminder, info.name, info.dosage);
      }
    }
  }

  /// Show immediate notification for low stock
  Future<void> showLowStockNotification(String medicationName, int remaining) async {
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

    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    // Use a unique ID based on medication name to avoid duplicate notifications
    final notificationId = 'low_stock_$medicationName'.hashCode;

    await _localNotifications.show(
      id: notificationId,
      title: 'Low Stock Alert: $medicationName',
      body: 'Only $remaining doses remaining. Time to refill!',
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
}
