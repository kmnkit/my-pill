import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
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

  // --- Medications ---
  Future<void> saveMedication(Medication med) async {
    final box = await Hive.openBox<String>(_medicationsBox);
    await box.put(med.id, jsonEncode(med.toJson()));
  }

  Future<Medication?> getMedication(String id) async {
    final box = await Hive.openBox<String>(_medicationsBox);
    final json = box.get(id);
    if (json == null) return null;
    return Medication.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<List<Medication>> getAllMedications() async {
    final box = await Hive.openBox<String>(_medicationsBox);
    return box.values
        .map((json) =>
            Medication.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteMedication(String id) async {
    final box = await Hive.openBox<String>(_medicationsBox);
    await box.delete(id);
  }

  // --- Schedules ---
  Future<void> saveSchedule(Schedule schedule) async {
    final box = await Hive.openBox<String>(_schedulesBox);
    await box.put(schedule.id, jsonEncode(schedule.toJson()));
  }

  Future<Schedule?> getSchedule(String id) async {
    final box = await Hive.openBox<String>(_schedulesBox);
    final json = box.get(id);
    if (json == null) return null;
    return Schedule.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<List<Schedule>> getAllSchedules() async {
    final box = await Hive.openBox<String>(_schedulesBox);
    return box.values
        .map((json) =>
            Schedule.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  Future<List<Schedule>> getSchedulesForMedication(String medicationId) async {
    final box = await Hive.openBox<String>(_schedulesBox);
    return box.values
        .map((json) =>
            Schedule.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .where((schedule) => schedule.medicationId == medicationId)
        .toList();
  }

  Future<void> deleteSchedule(String id) async {
    final box = await Hive.openBox<String>(_schedulesBox);
    await box.delete(id);
  }

  // --- Reminders ---
  Future<void> saveReminder(Reminder reminder) async {
    final box = await Hive.openBox<String>(_remindersBox);
    await box.put(reminder.id, jsonEncode(reminder.toJson()));
  }

  Future<Reminder?> getReminder(String id) async {
    final box = await Hive.openBox<String>(_remindersBox);
    final json = box.get(id);
    if (json == null) return null;
    return Reminder.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<List<Reminder>> getAllReminders() async {
    final box = await Hive.openBox<String>(_remindersBox);
    return box.values
        .map((json) =>
            Reminder.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  Future<List<Reminder>> getRemindersForDate(DateTime date) async {
    final box = await Hive.openBox<String>(_remindersBox);
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
    final box = await Hive.openBox<String>(_remindersBox);
    await box.delete(id);
  }

  Future<void> deleteRemindersForMedication(String medicationId) async {
    final box = await Hive.openBox<String>(_remindersBox);
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
    final box = await Hive.openBox<String>(_adherenceBox);
    await box.put(record.id, jsonEncode(record.toJson()));
  }

  Future<List<AdherenceRecord>> getAdherenceRecords({
    String? medicationId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final box = await Hive.openBox<String>(_adherenceBox);
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
    final box = await Hive.openBox<String>(_adherenceBox);
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
    final box = await Hive.openBox<String>(_settingsBox);
    await box.put('user_profile', jsonEncode(profile.toJson()));
  }

  Future<UserProfile?> getUserProfile() async {
    final box = await Hive.openBox<String>(_settingsBox);
    final json = box.get('user_profile');
    if (json == null) return null;
    return UserProfile.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  // --- Caregiver Links ---
  Future<void> saveCaregiverLink(CaregiverLink link) async {
    final box = await Hive.openBox<String>(_caregiverLinksBox);
    await box.put(link.id, jsonEncode(link.toJson()));
  }

  Future<List<CaregiverLink>> getAllCaregiverLinks() async {
    final box = await Hive.openBox<String>(_caregiverLinksBox);
    return box.values
        .map((json) =>
            CaregiverLink.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteCaregiverLink(String id) async {
    final box = await Hive.openBox<String>(_caregiverLinksBox);
    await box.delete(id);
  }

  // --- Utility ---
  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(_medicationsBox);
    await Hive.deleteBoxFromDisk(_schedulesBox);
    await Hive.deleteBoxFromDisk(_remindersBox);
    await Hive.deleteBoxFromDisk(_adherenceBox);
    await Hive.deleteBoxFromDisk(_settingsBox);
    await Hive.deleteBoxFromDisk(_caregiverLinksBox);
  }
}
