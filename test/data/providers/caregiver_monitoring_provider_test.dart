import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/providers/caregiver_monitoring_provider.dart';
import 'package:kusuridoki/data/providers/subscription_provider.dart';

void main() {
  group('canAddPatientProvider', () {
    test('returns true when 0 patients and max=1 (free tier)', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverPatientsProvider.overrideWith((ref) => Stream.value([])),
          maxPatientsProvider.overrideWithValue(1),
        ],
      );
      addTearDown(container.dispose);

      // Listen before reading stream provider (CLAUDE.md gotcha)
      container.listen(caregiverPatientsProvider, (_, __) {});

      final canAdd = await container.read(canAddPatientProvider.future);
      expect(canAdd, isTrue);
    });

    test('returns false when 1 patient and max=1 (free tier limit reached)',
        () async {
      final container = ProviderContainer(
        overrides: [
          caregiverPatientsProvider.overrideWith(
            (ref) => Stream.value([
              (patientId: 'p1', patientName: 'Patient 1', linkedAt: null),
            ]),
          ),
          maxPatientsProvider.overrideWithValue(1),
        ],
      );
      addTearDown(container.dispose);

      container.listen(caregiverPatientsProvider, (_, __) {});

      final canAdd = await container.read(canAddPatientProvider.future);
      expect(canAdd, isFalse);
    });

    test('returns true when 1 patient and max=999 (premium)', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverPatientsProvider.overrideWith(
            (ref) => Stream.value([
              (patientId: 'p1', patientName: 'Patient 1', linkedAt: null),
            ]),
          ),
          maxPatientsProvider.overrideWithValue(999),
        ],
      );
      addTearDown(container.dispose);

      container.listen(caregiverPatientsProvider, (_, __) {});

      final canAdd = await container.read(canAddPatientProvider.future);
      expect(canAdd, isTrue);
    });

    test('returns true when kPremiumEnabled=false (default 999 max)', () async {
      // kPremiumEnabled = false → maxPatientsProvider returns 999
      // so canAddPatient is always true regardless of patient count
      final container = ProviderContainer(
        overrides: [
          caregiverPatientsProvider.overrideWith(
            (ref) => Stream.value([
              (patientId: 'p1', patientName: 'P1', linkedAt: null),
              (patientId: 'p2', patientName: 'P2', linkedAt: null),
            ]),
          ),
          // Use real maxPatientsProvider (kPremiumEnabled=false → 999)
        ],
      );
      addTearDown(container.dispose);

      container.listen(caregiverPatientsProvider, (_, __) {});

      final canAdd = await container.read(canAddPatientProvider.future);
      expect(canAdd, isTrue);
    });
  });
}
