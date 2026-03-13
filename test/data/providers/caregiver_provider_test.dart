import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/caregiver_link.dart';
import 'package:kusuridoki/data/providers/caregiver_provider.dart';
import 'package:kusuridoki/data/providers/subscription_provider.dart';

void main() {
  CaregiverLink makeLink(String id) => CaregiverLink(
    id: id,
    patientId: 'patient-1',
    caregiverId: 'caregiver-$id',
    caregiverName: 'Caregiver $id',
    status: 'connected',
    linkedAt: DateTime(2024, 1, 1),
  );

  /// Creates a stream that stays open (unlike Stream.value which closes
  /// immediately and causes "disposed during loading state" errors).
  Stream<List<CaregiverLink>> openStream(List<CaregiverLink> links) {
    final controller = StreamController<List<CaregiverLink>>();
    controller.add(links);
    // Don't close — keeps the stream alive for Riverpod StreamProvider
    return controller.stream;
  }

  group('caregiverLinks stream provider', () {
    test('emits list from overridden stream', () async {
      final links = [makeLink('1'), makeLink('2')];
      final container = ProviderContainer(
        overrides: [
          caregiverLinksProvider.overrideWith(
            (ref) => openStream(links),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Keep provider alive with a persistent listener before reading future
      container.listen(caregiverLinksProvider, (prev, next) {});

      final result = await container.read(caregiverLinksProvider.future);
      expect(result, hasLength(2));
      expect(result[0].id, '1');
      expect(result[1].id, '2');
    });

    test('emits empty list when no links', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverLinksProvider.overrideWith(
            (ref) => openStream(<CaregiverLink>[]),
          ),
        ],
      );
      addTearDown(container.dispose);

      container.listen(caregiverLinksProvider, (prev, next) {});

      final result = await container.read(caregiverLinksProvider.future);
      expect(result, isEmpty);
    });
  });

  group('canAddCaregiver', () {
    test('returns true when no caregivers and max is 1', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverLinksProvider.overrideWith(
            (ref) => openStream(<CaregiverLink>[]),
          ),
          maxCaregiversProvider.overrideWithValue(1),
        ],
      );
      addTearDown(container.dispose);

      container.listen(canAddCaregiverProvider, (prev, next) {});

      final result = await container.read(canAddCaregiverProvider.future);
      expect(result, isTrue);
    });

    test('returns false when at max capacity', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverLinksProvider.overrideWith(
            (ref) => openStream([makeLink('1')]),
          ),
          maxCaregiversProvider.overrideWithValue(1),
        ],
      );
      addTearDown(container.dispose);

      container.listen(canAddCaregiverProvider, (prev, next) {});

      final result = await container.read(canAddCaregiverProvider.future);
      expect(result, isFalse);
    });

    test('returns true when under max capacity with premium', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverLinksProvider.overrideWith(
            (ref) => openStream([makeLink('1'), makeLink('2')]),
          ),
          maxCaregiversProvider.overrideWithValue(999),
        ],
      );
      addTearDown(container.dispose);

      container.listen(canAddCaregiverProvider, (prev, next) {});

      final result = await container.read(canAddCaregiverProvider.future);
      expect(result, isTrue);
    });
  });

  group('remainingCaregiverSlots', () {
    test('returns max when no caregivers', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverLinksProvider.overrideWith(
            (ref) => openStream(<CaregiverLink>[]),
          ),
          maxCaregiversProvider.overrideWithValue(5),
        ],
      );
      addTearDown(container.dispose);

      container.listen(remainingCaregiverSlotsProvider, (prev, next) {});

      final result = await container.read(
        remainingCaregiverSlotsProvider.future,
      );
      expect(result, 5);
    });

    test('returns 0 when at capacity', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverLinksProvider.overrideWith(
            (ref) => openStream([makeLink('1')]),
          ),
          maxCaregiversProvider.overrideWithValue(1),
        ],
      );
      addTearDown(container.dispose);

      container.listen(remainingCaregiverSlotsProvider, (prev, next) {});

      final result = await container.read(
        remainingCaregiverSlotsProvider.future,
      );
      expect(result, 0);
    });

    test('clamps to 0 (never negative)', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverLinksProvider.overrideWith(
            (ref) => openStream([makeLink('1'), makeLink('2')]),
          ),
          maxCaregiversProvider.overrideWithValue(1),
        ],
      );
      addTearDown(container.dispose);

      container.listen(remainingCaregiverSlotsProvider, (prev, next) {});

      final result = await container.read(
        remainingCaregiverSlotsProvider.future,
      );
      expect(result, 0);
    });

    test('returns correct remaining with partial use', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverLinksProvider.overrideWith(
            (ref) => openStream([makeLink('1'), makeLink('2')]),
          ),
          maxCaregiversProvider.overrideWithValue(5),
        ],
      );
      addTearDown(container.dispose);

      container.listen(remainingCaregiverSlotsProvider, (prev, next) {});

      final result = await container.read(
        remainingCaregiverSlotsProvider.future,
      );
      expect(result, 3);
    });
  });
}
