import 'package:uuid/uuid.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/services/storage_service.dart';
import 'package:my_pill/data/services/notification_service.dart';

class MedicationRepository {
  final StorageService _storage;
  static const _uuid = Uuid();

  MedicationRepository(this._storage);

  /// Create medication (generates UUID, sets timestamps)
  Future<Medication> createMedication(Medication medication) async {
    final now = DateTime.now();
    final newMedication = medication.copyWith(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
    );
    await _storage.saveMedication(newMedication);
    return newMedication;
  }

  /// Read all medications
  Future<List<Medication>> getAllMedications() async {
    return await _storage.getAllMedications();
  }

  /// Read single medication by ID
  Future<Medication?> getMedication(String id) async {
    return await _storage.getMedication(id);
  }

  /// Update medication details
  Future<void> updateMedication(Medication medication) async {
    final updated = medication.copyWith(updatedAt: DateTime.now());
    await _storage.saveMedication(updated);
  }

  /// Delete medication (cascade: also delete related schedules, reminders, adherence records)
  Future<void> deleteMedication(String id) async {
    // Delete related data
    await _storage.deleteRemindersForMedication(id);
    await _storage.deleteAdherenceRecordsForMedication(id);

    // Delete schedules for this medication
    final schedules = await _storage.getSchedulesForMedication(id);
    for (final schedule in schedules) {
      await _storage.deleteSchedule(schedule.id);
    }

    // Delete medication itself
    await _storage.deleteMedication(id);
  }

  /// Search medications by name (case-insensitive)
  Future<List<Medication>> searchMedications(String query) async {
    final allMedications = await getAllMedications();
    final lowerQuery = query.toLowerCase();
    return allMedications
        .where((med) => med.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Filter by stock status
  Future<List<Medication>> getLowStockMedications() async {
    final allMedications = await getAllMedications();
    return allMedications.where((med) {
      // Get schedules to calculate doses per day
      // For now, use a simple check based on threshold
      return isLowStock(med);
    }).toList();
  }

  /// Deduct from inventory (when "Take" action)
  Future<Medication> deductInventory(String medicationId) async {
    final medication = await getMedication(medicationId);
    if (medication == null) {
      throw Exception('Medication not found: $medicationId');
    }

    if (medication.inventoryRemaining <= 0) {
      throw Exception('No inventory remaining for medication: ${medication.name}');
    }

    final updated = medication.copyWith(
      inventoryRemaining: medication.inventoryRemaining - 1,
      updatedAt: DateTime.now(),
    );

    await _storage.saveMedication(updated);

    // Check if now low stock and trigger notification
    if (isLowStock(updated)) {
      try {
        await NotificationService().showLowStockNotification(
          updated.name,
          updated.inventoryRemaining,
        );
      } catch (e) {
        // Don't fail the deduction if notification fails
        // ignore: avoid_print
      }
    }

    return updated;
  }

  /// Manual inventory update (refill)
  Future<Medication> updateInventory(String medicationId, int newRemaining) async {
    final medication = await getMedication(medicationId);
    if (medication == null) {
      throw Exception('Medication not found: $medicationId');
    }

    final updated = medication.copyWith(
      inventoryRemaining: newRemaining,
      updatedAt: DateTime.now(),
    );

    await _storage.saveMedication(updated);
    return updated;
  }

  /// Check if medication is low stock (remaining <= lowStockThreshold or days remaining <= 3)
  bool isLowStock(Medication medication, {int dosesPerDay = 1}) {
    if (medication.inventoryRemaining <= medication.lowStockThreshold) {
      return true;
    }

    final days = daysRemaining(medication, dosesPerDay: dosesPerDay);
    return days <= 3;
  }

  /// Calculate days remaining
  int daysRemaining(Medication medication, {int dosesPerDay = 1}) {
    if (dosesPerDay <= 0) {
      return 0;
    }
    return (medication.inventoryRemaining / dosesPerDay).floor();
  }
}
