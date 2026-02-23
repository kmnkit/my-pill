import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_pill/core/utils/photo_encryption.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/models/reminder.dart';
import 'package:my_pill/data/models/adherence_record.dart';
import 'package:my_pill/data/models/user_profile.dart';
import 'package:my_pill/data/models/caregiver_link.dart';

class StorageService {
  // Box names
  static const String _medicationsBox = 'medications';
  static const String _schedulesBox = 'schedules';
  static const String _remindersBox = 'reminders';
  static const String _adherenceBox = 'adherence_records';
  static const String _settingsBox = 'settings';
  static const String _caregiverLinksBox = 'caregiver_links';

  // Encryption key management
  static const String _encryptionKeyName = 'hive_encryption_key';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  HiveCipher? _cipher;
  Uint8List? _keyBytes;

  /// Raw encryption key bytes for photo encryption.
  /// Throws [StateError] if encryption has not been initialized.
  Uint8List get encryptionKeyBytes {
    if (_keyBytes == null) {
      throw StateError(
        'Encryption not initialized. Call initializeEncryption() first.',
      );
    }
    return _keyBytes!;
  }

  /// Initialize encryption - must be called before any storage operations
  Future<void> initializeEncryption() async {
    if (_cipher != null) return;

    try {
      String? encodedKey = await _secureStorage.read(key: _encryptionKeyName);

      if (encodedKey == null) {
        // Generate new encryption key
        final key = Hive.generateSecureKey();
        encodedKey = base64Encode(key);
        await _secureStorage.write(key: _encryptionKeyName, value: encodedKey);
      }

      final encryptionKey = base64Decode(encodedKey);
      _keyBytes = Uint8List.fromList(encryptionKey);
      _cipher = HiveAesCipher(_keyBytes!);
    } catch (e) {
      debugPrint('Encryption init failed: $e');
      // Re-throw - unencrypted storage is not acceptable for medical data
      throw StateError(
        'Failed to initialize secure storage. Please restart the app. '
        'If the problem persists, reinstall the app.',
      );
    }

    // Migrate unencrypted photos (best-effort, don't block app on failure)
    try {
      await migrateUnencryptedPhotos();
    } catch (e) {
      debugPrint('Photo migration failed (will retry on next restart): $e');
    }
  }

  /// Open an encrypted box
  Future<Box<String>> _openBox(String boxName) async {
    await initializeEncryption();
    if (_cipher != null) {
      return await Hive.openBox<String>(boxName, encryptionCipher: _cipher);
    }
    return await Hive.openBox<String>(boxName);
  }

  // --- Medications ---
  Future<void> saveMedication(Medication med) async {
    final box = await _openBox(_medicationsBox);
    await box.put(med.id, jsonEncode(med.toJson()));
  }

  Future<Medication?> getMedication(String id) async {
    final box = await _openBox(_medicationsBox);
    final json = box.get(id);
    if (json == null) return null;
    return Medication.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<List<Medication>> getAllMedications() async {
    final box = await _openBox(_medicationsBox);
    return box.values
        .map((json) =>
            Medication.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteMedication(String id) async {
    final box = await _openBox(_medicationsBox);
    await box.delete(id);
  }

  // --- Schedules ---
  Future<void> saveSchedule(Schedule schedule) async {
    final box = await _openBox(_schedulesBox);
    await box.put(schedule.id, jsonEncode(schedule.toJson()));
  }

  Future<Schedule?> getSchedule(String id) async {
    final box = await _openBox(_schedulesBox);
    final json = box.get(id);
    if (json == null) return null;
    return Schedule.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<List<Schedule>> getAllSchedules() async {
    final box = await _openBox(_schedulesBox);
    return box.values
        .map((json) =>
            Schedule.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  Future<List<Schedule>> getSchedulesForMedication(String medicationId) async {
    final box = await _openBox(_schedulesBox);
    return box.values
        .map((json) =>
            Schedule.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .where((schedule) => schedule.medicationId == medicationId)
        .toList();
  }

  Future<void> deleteSchedule(String id) async {
    final box = await _openBox(_schedulesBox);
    await box.delete(id);
  }

  // --- Reminders ---
  Future<void> saveReminder(Reminder reminder) async {
    final box = await _openBox(_remindersBox);
    await box.put(reminder.id, jsonEncode(reminder.toJson()));
  }

  Future<Reminder?> getReminder(String id) async {
    final box = await _openBox(_remindersBox);
    final json = box.get(id);
    if (json == null) return null;
    return Reminder.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<List<Reminder>> getAllReminders() async {
    final box = await _openBox(_remindersBox);
    return box.values
        .map((json) =>
            Reminder.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  Future<List<Reminder>> getRemindersForDate(DateTime date) async {
    final box = await _openBox(_remindersBox);
    return box.values
        .map((json) =>
            Reminder.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .where((reminder) {
      final scheduledTime = reminder.scheduledTime;
      return scheduledTime.year == date.year &&
          scheduledTime.month == date.month &&
          scheduledTime.day == date.day;
    }).toList();
  }

  Future<void> deleteReminder(String id) async {
    final box = await _openBox(_remindersBox);
    await box.delete(id);
  }

  Future<void> deleteRemindersForMedication(String medicationId) async {
    final box = await _openBox(_remindersBox);
    final toDelete = box.values
        .map((json) =>
            Reminder.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .where((reminder) => reminder.medicationId == medicationId)
        .map((reminder) => reminder.id)
        .toList();

    for (final id in toDelete) {
      await box.delete(id);
    }
  }

  // --- Adherence Records ---
  Future<void> saveAdherenceRecord(AdherenceRecord record) async {
    final box = await _openBox(_adherenceBox);
    await box.put(record.id, jsonEncode(record.toJson()));
  }

  Future<List<AdherenceRecord>> getAdherenceRecords({
    String? medicationId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final box = await _openBox(_adherenceBox);
    var records = box.values
        .map((json) =>
            AdherenceRecord.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();

    if (medicationId != null) {
      records = records
          .where((record) => record.medicationId == medicationId)
          .toList();
    }

    if (startDate != null) {
      records = records
          .where((record) => record.date.isAfter(startDate) ||
              record.date.isAtSameMomentAs(startDate))
          .toList();
    }

    if (endDate != null) {
      records = records
          .where((record) => record.date.isBefore(endDate) ||
              record.date.isAtSameMomentAs(endDate))
          .toList();
    }

    return records;
  }

  Future<void> deleteAdherenceRecordsForMedication(String medicationId) async {
    final box = await _openBox(_adherenceBox);
    final toDelete = box.values
        .map((json) =>
            AdherenceRecord.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .where((record) => record.medicationId == medicationId)
        .map((record) => record.id)
        .toList();

    for (final id in toDelete) {
      await box.delete(id);
    }
  }

  // --- User Settings ---
  Future<void> saveUserProfile(UserProfile profile) async {
    final box = await _openBox(_settingsBox);
    await box.put('user_profile', jsonEncode(profile.toJson()));
  }

  Future<UserProfile?> getUserProfile() async {
    final box = await _openBox(_settingsBox);
    final json = box.get('user_profile');
    if (json == null) return null;
    return UserProfile.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  // --- Caregiver Links ---
  Future<void> saveCaregiverLink(CaregiverLink link) async {
    final box = await _openBox(_caregiverLinksBox);
    await box.put(link.id, jsonEncode(link.toJson()));
  }

  Future<List<CaregiverLink>> getAllCaregiverLinks() async {
    final box = await _openBox(_caregiverLinksBox);
    return box.values
        .map((json) =>
            CaregiverLink.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteCaregiverLink(String id) async {
    final box = await _openBox(_caregiverLinksBox);
    await box.delete(id);
  }

  // --- Photo File Management ---

  /// Delete a photo file from the filesystem.
  /// Safe to call with null or non-existent paths.
  Future<void> deletePhotoFile(String? photoPath) async {
    if (photoPath == null) return;
    try {
      final file = File(photoPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Failed to delete photo file: $e');
    }
  }

  /// One-time migration of unencrypted photos to AES-256 encrypted .enc files.
  Future<void> migrateUnencryptedPhotos() async {
    final box = await _openBox(_settingsBox);
    if (box.get('photos_migrated') == 'true') return;

    final medications = await getAllMedications();
    for (final med in medications) {
      if (med.photoPath == null) continue;
      if (PhotoEncryption.isEncrypted(med.photoPath!)) continue;

      final file = File(med.photoPath!);
      if (!await file.exists()) continue;

      final plainBytes = await file.readAsBytes();
      final encPath = await PhotoEncryption.encryptAndSave(
        plainBytes,
        med.photoPath!,
        _keyBytes!,
      );

      final updated = med.copyWith(photoPath: encPath);
      await saveMedication(updated);
      await file.delete();
    }

    await box.put('photos_migrated', 'true');
  }

  // --- Utility ---

  /// Delete all medication photo files (best-effort).
  Future<void> _deleteAllPhotoFiles() async {
    try {
      final medications = await getAllMedications();
      for (final med in medications) {
        await deletePhotoFile(med.photoPath);
      }
    } catch (_) {
      // Best-effort: box might be corrupted or not yet opened
    }
  }

  /// Clear all data including app settings. Use for account deletion.
  Future<void> clearAll() async {
    await _deleteAllPhotoFiles();
    await Hive.deleteBoxFromDisk(_medicationsBox);
    await Hive.deleteBoxFromDisk(_schedulesBox);
    await Hive.deleteBoxFromDisk(_remindersBox);
    await Hive.deleteBoxFromDisk(_adherenceBox);
    await Hive.deleteBoxFromDisk(_settingsBox);
    await Hive.deleteBoxFromDisk(_caregiverLinksBox);
  }

  /// Clear user data only, preserving app settings (onboardingComplete, language).
  /// Use for sign-out to avoid redirecting back to onboarding.
  Future<void> clearUserData() async {
    await _deleteAllPhotoFiles();
    await Hive.deleteBoxFromDisk(_medicationsBox);
    await Hive.deleteBoxFromDisk(_schedulesBox);
    await Hive.deleteBoxFromDisk(_remindersBox);
    await Hive.deleteBoxFromDisk(_adherenceBox);
    await Hive.deleteBoxFromDisk(_caregiverLinksBox);

    // Reset personal info in settings but preserve app preferences
    final box = await _openBox(_settingsBox);
    final json = box.get('user_profile');
    if (json != null) {
      final profile = UserProfile.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );
      final cleaned = profile.copyWith(
        id: '',
        name: null,
        email: null,
        usesPrivateEmail: false,
        removeAds: false,
        travelModeEnabled: false,
        homeTimezone: null,
        userRole: 'patient',
        // Preserved: onboardingComplete, language, highContrast, textSize,
        // notificationsEnabled, criticalAlerts, snoozeDuration
      );
      await box.put('user_profile', jsonEncode(cleaned.toJson()));
    }
  }
}
