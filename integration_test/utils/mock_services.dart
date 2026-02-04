/// Mock service implementations for E2E testing
library;

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/models/reminder.dart';
import 'package:my_pill/data/models/adherence_record.dart';
import 'package:my_pill/data/models/user_profile.dart';
import 'package:my_pill/data/models/caregiver_link.dart';
import 'package:my_pill/data/models/subscription_status.dart';
import 'package:my_pill/data/services/auth_service.dart';
import 'package:my_pill/data/services/storage_service.dart';

/// Mock implementation of AuthService for testing
class MockAuthService implements AuthService {
  final StreamController<User?> _authStateController =
      StreamController<User?>.broadcast();
  User? _currentUser;
  bool _shouldFailNextOperation = false;
  String? _failureMessage;

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  User? get currentUser => _currentUser;

  /// Configure the mock to fail the next operation
  void setNextOperationToFail([String? message]) {
    _shouldFailNextOperation = true;
    _failureMessage = message ?? 'Mock operation failed';
  }

  /// Set the current user state
  void setUser(User? user) {
    _currentUser = user;
    _authStateController.add(user);
  }

  void _checkFailure() {
    if (_shouldFailNextOperation) {
      _shouldFailNextOperation = false;
      throw FirebaseAuthException(
        code: 'mock-error',
        message: _failureMessage ?? 'Mock operation failed',
      );
    }
  }

  @override
  Future<UserCredential> signInAnonymously() async {
    _checkFailure();
    // Return a mock credential - we just update internal state
    _currentUser = _MockUser(uid: 'anonymous-${DateTime.now().millisecondsSinceEpoch}');
    _authStateController.add(_currentUser);
    return _MockUserCredential(_currentUser);
  }

  @override
  Future<UserCredential> registerWithEmail(String email, String password) async {
    _checkFailure();
    _currentUser = _MockUser(uid: 'email-user-1', email: email);
    _authStateController.add(_currentUser);
    return _MockUserCredential(_currentUser);
  }

  @override
  Future<UserCredential> signInWithEmail(String email, String password) async {
    _checkFailure();
    _currentUser = _MockUser(uid: 'email-user-1', email: email);
    _authStateController.add(_currentUser);
    return _MockUserCredential(_currentUser);
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    _checkFailure();
    _currentUser = _MockUser(
      uid: 'google-user-1',
      email: 'test@gmail.com',
      displayName: 'Google User',
    );
    _authStateController.add(_currentUser);
    return _MockUserCredential(_currentUser);
  }

  @override
  Future<UserCredential> signInWithApple() async {
    _checkFailure();
    _currentUser = _MockUser(
      uid: 'apple-user-1',
      email: 'test@privaterelay.appleid.com',
      displayName: 'Apple User',
    );
    _authStateController.add(_currentUser);
    return _MockUserCredential(_currentUser);
  }

  @override
  Future<UserCredential> linkWithEmail(String email, String password) async {
    _checkFailure();
    return _MockUserCredential(_currentUser);
  }

  @override
  Future<UserCredential> linkWithGoogle() async {
    _checkFailure();
    return _MockUserCredential(_currentUser);
  }

  @override
  Future<UserCredential> linkWithApple() async {
    _checkFailure();
    return _MockUserCredential(_currentUser);
  }

  @override
  Future<void> signOut() async {
    _checkFailure();
    _currentUser = null;
    _authStateController.add(null);
  }

  @override
  Future<void> deleteAccount() async {
    _checkFailure();
    _currentUser = null;
    _authStateController.add(null);
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    _checkFailure();
  }

  bool isPrivateRelayEmail(String? email) {
    return email?.contains('privaterelay.appleid.com') ?? false;
  }

  void dispose() {
    _authStateController.close();
  }
}

/// Firebase Auth exception for mock errors
class FirebaseAuthException implements Exception {
  final String code;
  final String message;

  FirebaseAuthException({required this.code, required this.message});

  @override
  String toString() => 'FirebaseAuthException: [$code] $message';
}

/// Mock User implementation
class _MockUser implements User {
  @override
  final String uid;

  @override
  final String? email;

  @override
  final String? displayName;

  _MockUser({
    required this.uid,
    this.email,
    this.displayName,
  });

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Mock UserCredential implementation
class _MockUserCredential implements UserCredential {
  @override
  final User? user;

  _MockUserCredential(this.user);

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// In-memory implementation of StorageService for testing
class MockStorageService implements StorageService {
  final Map<String, Medication> _medications = {};
  final Map<String, Schedule> _schedules = {};
  final Map<String, Reminder> _reminders = {};
  final Map<String, AdherenceRecord> _adherenceRecords = {};
  final Map<String, CaregiverLink> _caregiverLinks = {};
  UserProfile? _userProfile;

  /// Initialize with test data
  MockStorageService({
    List<Medication>? medications,
    List<Schedule>? schedules,
    List<Reminder>? reminders,
    List<AdherenceRecord>? adherenceRecords,
    List<CaregiverLink>? caregiverLinks,
    UserProfile? userProfile,
  }) {
    if (medications != null) {
      for (final med in medications) {
        _medications[med.id] = med;
      }
    }
    if (schedules != null) {
      for (final schedule in schedules) {
        _schedules[schedule.id] = schedule;
      }
    }
    if (reminders != null) {
      for (final reminder in reminders) {
        _reminders[reminder.id] = reminder;
      }
    }
    if (adherenceRecords != null) {
      for (final record in adherenceRecords) {
        _adherenceRecords[record.id] = record;
      }
    }
    if (caregiverLinks != null) {
      for (final link in caregiverLinks) {
        _caregiverLinks[link.id] = link;
      }
    }
    _userProfile = userProfile;
  }

  @override
  Future<void> initializeEncryption() async {
    // No-op for testing
  }

  // --- Medications ---
  @override
  Future<void> saveMedication(Medication med) async {
    _medications[med.id] = med;
  }

  @override
  Future<Medication?> getMedication(String id) async {
    return _medications[id];
  }

  @override
  Future<List<Medication>> getAllMedications() async {
    return _medications.values.toList();
  }

  @override
  Future<void> deleteMedication(String id) async {
    _medications.remove(id);
  }

  // --- Schedules ---
  @override
  Future<void> saveSchedule(Schedule schedule) async {
    _schedules[schedule.id] = schedule;
  }

  @override
  Future<Schedule?> getSchedule(String id) async {
    return _schedules[id];
  }

  @override
  Future<List<Schedule>> getAllSchedules() async {
    return _schedules.values.toList();
  }

  @override
  Future<List<Schedule>> getSchedulesForMedication(String medicationId) async {
    return _schedules.values
        .where((s) => s.medicationId == medicationId)
        .toList();
  }

  @override
  Future<void> deleteSchedule(String id) async {
    _schedules.remove(id);
  }

  // --- Reminders ---
  @override
  Future<void> saveReminder(Reminder reminder) async {
    _reminders[reminder.id] = reminder;
  }

  @override
  Future<Reminder?> getReminder(String id) async {
    return _reminders[id];
  }

  @override
  Future<List<Reminder>> getAllReminders() async {
    return _reminders.values.toList();
  }

  @override
  Future<List<Reminder>> getRemindersForDate(DateTime date) async {
    return _reminders.values.where((r) {
      final scheduledTime = r.scheduledTime;
      return scheduledTime.year == date.year &&
          scheduledTime.month == date.month &&
          scheduledTime.day == date.day;
    }).toList();
  }

  @override
  Future<void> deleteReminder(String id) async {
    _reminders.remove(id);
  }

  @override
  Future<void> deleteRemindersForMedication(String medicationId) async {
    _reminders.removeWhere((_, r) => r.medicationId == medicationId);
  }

  // --- Adherence Records ---
  @override
  Future<void> saveAdherenceRecord(AdherenceRecord record) async {
    _adherenceRecords[record.id] = record;
  }

  @override
  Future<List<AdherenceRecord>> getAdherenceRecords({
    String? medicationId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var records = _adherenceRecords.values.toList();

    if (medicationId != null) {
      records = records.where((r) => r.medicationId == medicationId).toList();
    }
    if (startDate != null) {
      records = records
          .where((r) =>
              r.date.isAfter(startDate) || r.date.isAtSameMomentAs(startDate))
          .toList();
    }
    if (endDate != null) {
      records = records
          .where((r) =>
              r.date.isBefore(endDate) || r.date.isAtSameMomentAs(endDate))
          .toList();
    }

    return records;
  }

  @override
  Future<void> deleteAdherenceRecordsForMedication(String medicationId) async {
    _adherenceRecords.removeWhere((_, r) => r.medicationId == medicationId);
  }

  // --- User Settings ---
  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    _userProfile = profile;
  }

  @override
  Future<UserProfile?> getUserProfile() async {
    return _userProfile;
  }

  // --- Caregiver Links ---
  @override
  Future<void> saveCaregiverLink(CaregiverLink link) async {
    _caregiverLinks[link.id] = link;
  }

  @override
  Future<List<CaregiverLink>> getAllCaregiverLinks() async {
    return _caregiverLinks.values.toList();
  }

  @override
  Future<void> deleteCaregiverLink(String id) async {
    _caregiverLinks.remove(id);
  }

  // --- Utility ---
  @override
  Future<void> clearAll() async {
    _medications.clear();
    _schedules.clear();
    _reminders.clear();
    _adherenceRecords.clear();
    _caregiverLinks.clear();
    _userProfile = null;
  }

  /// Get current state for assertions
  Map<String, Medication> get medications => Map.unmodifiable(_medications);
  Map<String, Schedule> get schedules => Map.unmodifiable(_schedules);
  Map<String, Reminder> get reminders => Map.unmodifiable(_reminders);
  Map<String, AdherenceRecord> get adherenceRecords =>
      Map.unmodifiable(_adherenceRecords);
  UserProfile? get userProfile => _userProfile;
}

/// Mock implementation of NotificationService for testing
class MockNotificationService {
  final List<ScheduledNotification> _scheduledNotifications = [];
  final List<String> _cancelledNotifications = [];
  bool _permissionGranted = true;

  /// Set whether permission requests should succeed
  void setPermissionGranted(bool granted) {
    _permissionGranted = granted;
  }

  Future<void> initialize() async {
    // No-op for testing
  }

  Future<bool> requestPermissions() async {
    return _permissionGranted;
  }

  Future<bool> checkPermissionStatus() async {
    return _permissionGranted;
  }

  Future<void> scheduleReminder({
    required String id,
    required String medicationName,
    required String dosage,
    required DateTime scheduledTime,
  }) async {
    _scheduledNotifications.add(ScheduledNotification(
      id: id,
      medicationName: medicationName,
      dosage: dosage,
      scheduledTime: scheduledTime,
      isCritical: false,
    ));
  }

  Future<void> scheduleCriticalReminder({
    required String id,
    required String medicationName,
    required String dosage,
    required DateTime scheduledTime,
  }) async {
    _scheduledNotifications.add(ScheduledNotification(
      id: id,
      medicationName: medicationName,
      dosage: dosage,
      scheduledTime: scheduledTime,
      isCritical: true,
    ));
  }

  Future<void> cancelReminder(String id) async {
    _scheduledNotifications.removeWhere((n) => n.id == id);
    _cancelledNotifications.add(id);
  }

  Future<void> cancelAll() async {
    _scheduledNotifications.clear();
  }

  /// Get scheduled notifications for assertions
  List<ScheduledNotification> get scheduledNotifications =>
      List.unmodifiable(_scheduledNotifications);

  /// Get cancelled notification IDs for assertions
  List<String> get cancelledNotifications =>
      List.unmodifiable(_cancelledNotifications);

  /// Check if a notification was scheduled
  bool wasScheduled(String id) {
    return _scheduledNotifications.any((n) => n.id == id);
  }

  /// Check if a notification was cancelled
  bool wasCancelled(String id) {
    return _cancelledNotifications.contains(id);
  }
}

class ScheduledNotification {
  final String id;
  final String medicationName;
  final String dosage;
  final DateTime scheduledTime;
  final bool isCritical;

  ScheduledNotification({
    required this.id,
    required this.medicationName,
    required this.dosage,
    required this.scheduledTime,
    required this.isCritical,
  });
}

/// Mock implementation of SubscriptionService for testing
class MockSubscriptionService {
  final StreamController<SubscriptionStatus> _statusController =
      StreamController<SubscriptionStatus>.broadcast();
  SubscriptionStatus _status = const SubscriptionStatus(
    isPremium: false,
    expiresAt: null,
    productId: null,
  );

  Stream<SubscriptionStatus> get statusStream => _statusController.stream;
  SubscriptionStatus get status => _status;
  bool get isPremium => _status.isPremium;
  int get maxCaregivers => _status.isPremium ? 10 : 1;

  /// Set premium status for testing
  void setPremium(bool isPremium, {DateTime? expiresAt}) {
    _status = SubscriptionStatus(
      isPremium: isPremium,
      expiresAt: expiresAt,
      productId: isPremium ? 'premium_monthly' : null,
    );
    _statusController.add(_status);
  }

  Future<void> initialize() async {
    // No-op for testing
  }

  Future<bool> purchaseMonthly() async {
    setPremium(true,
        expiresAt: DateTime.now().add(const Duration(days: 30)));
    return true;
  }

  Future<bool> purchaseYearly() async {
    setPremium(true,
        expiresAt: DateTime.now().add(const Duration(days: 365)));
    return true;
  }

  Future<void> restorePurchases() async {
    // No-op - premium status remains unchanged
  }

  void dispose() {
    _statusController.close();
  }
}
