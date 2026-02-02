import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/models/reminder.dart';
import 'package:my_pill/data/models/adherence_record.dart';
import 'package:my_pill/data/models/user_profile.dart';
import 'package:my_pill/data/models/caregiver_link.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  DocumentReference get _userDoc => _db.collection('users').doc(_userId);

  // --- Medications ---
  CollectionReference get _medicationsCol => _userDoc.collection('medications');

  Future<void> saveMedication(Medication med) async {
    await _medicationsCol.doc(med.id).set(med.toJson());
  }

  Future<List<Medication>> getAllMedications() async {
    final snapshot = await _medicationsCol.get();
    return snapshot.docs
        .map((doc) => Medication.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteMedication(String id) async {
    await _medicationsCol.doc(id).delete();
  }

  // Real-time stream for medications
  Stream<List<Medication>> watchMedications() {
    return _medicationsCol.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Medication.fromJson(doc.data() as Map<String, dynamic>)).toList());
  }

  // --- Schedules ---
  CollectionReference get _schedulesCol => _userDoc.collection('schedules');

  Future<void> saveSchedule(Schedule schedule) async {
    await _schedulesCol.doc(schedule.id).set(schedule.toJson());
  }

  Future<List<Schedule>> getAllSchedules() async {
    final snapshot = await _schedulesCol.get();
    return snapshot.docs
        .map((doc) => Schedule.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteSchedule(String id) async {
    await _schedulesCol.doc(id).delete();
  }

  Stream<List<Schedule>> watchSchedules() {
    return _schedulesCol.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Schedule.fromJson(doc.data() as Map<String, dynamic>)).toList());
  }

  // --- Reminders ---
  CollectionReference get _remindersCol => _userDoc.collection('reminders');

  Future<void> saveReminder(Reminder reminder) async {
    await _remindersCol.doc(reminder.id).set(reminder.toJson());
  }

  Future<List<Reminder>> getRemindersForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final snapshot = await _remindersCol
        .where('scheduledTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('scheduledTime', isLessThan: Timestamp.fromDate(endOfDay))
        .get();

    return snapshot.docs
        .map((doc) => Reminder.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteReminder(String id) async {
    await _remindersCol.doc(id).delete();
  }

  // --- Adherence Records ---
  CollectionReference get _adherenceCol => _userDoc.collection('adherenceRecords');

  Future<void> saveAdherenceRecord(AdherenceRecord record) async {
    await _adherenceCol.doc(record.id).set(record.toJson());
  }

  Future<List<AdherenceRecord>> getAdherenceRecords({DateTime? startDate, DateTime? endDate}) async {
    Query query = _adherenceCol;

    if (startDate != null) {
      query = query.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }

    if (endDate != null) {
      query = query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => AdherenceRecord.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // --- User Profile ---
  Future<void> saveUserProfile(UserProfile profile) async {
    await _userDoc.set({'profile': profile.toJson()}, SetOptions(merge: true));
  }

  Future<UserProfile?> getUserProfile() async {
    final doc = await _userDoc.get();
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null || data['profile'] == null) return null;
    return UserProfile.fromJson(data['profile'] as Map<String, dynamic>);
  }

  // --- Caregiver Links ---
  CollectionReference get _caregiverLinksCol => _userDoc.collection('caregiverLinks');

  Future<void> saveCaregiverLink(CaregiverLink link) async {
    await _caregiverLinksCol.doc(link.id).set(link.toJson());
  }

  Future<List<CaregiverLink>> getCaregiverLinks() async {
    final snapshot = await _caregiverLinksCol.get();
    return snapshot.docs
        .map((doc) => CaregiverLink.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteCaregiverLink(String id) async {
    await _caregiverLinksCol.doc(id).delete();
  }

  // --- Sync Logic ---
  // Sync local Hive data to Firestore (upload)
  Future<void> syncToCloud(List<Medication> medications, List<Schedule> schedules) async {
    final batch = _db.batch();
    for (final med in medications) {
      batch.set(_medicationsCol.doc(med.id), med.toJson());
    }
    for (final schedule in schedules) {
      batch.set(_schedulesCol.doc(schedule.id), schedule.toJson());
    }
    await batch.commit();
  }

  // --- Caregiver Dashboard (read-only access to linked patients) ---
  Stream<List<Medication>> watchPatientMedications(String patientId) {
    return _db.collection('users').doc(patientId).collection('medications')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Medication.fromJson(doc.data()))
            .toList());
  }

  Stream<List<Reminder>> watchPatientReminders(String patientId) {
    return _db.collection('users').doc(patientId).collection('reminders')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Reminder.fromJson(doc.data()))
            .toList());
  }
}
