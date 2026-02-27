import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:kusuridoki/data/models/caregiver_link.dart';
import 'package:kusuridoki/data/providers/caregiver_provider.dart';
import 'package:kusuridoki/data/providers/storage_service_provider.dart';
import 'package:kusuridoki/data/providers/subscription_provider.dart';

import 'settings_provider_test.mocks.dart';

void main() {
  CaregiverLink makeLink(String id) => CaregiverLink(
    id: id,
    patientId: 'patient-1',
    caregiverId: 'caregiver-$id',
    caregiverName: 'Caregiver $id',
    status: 'connected',
    linkedAt: DateTime(2024, 1, 1),
  );

  group('CaregiverLinks notifier', () {
    late MockStorageService mockStorage;

    setUp(() {
      mockStorage = MockStorageService();
    });

    test('build() returns list from storage', () async {
      final links = [makeLink('1'), makeLink('2')];
      when(mockStorage.getAllCaregiverLinks()).thenAnswer((_) async => links);

      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(mockStorage)],
      );
      addTearDown(container.dispose);

      final result = await container.read(caregiverLinksProvider.future);
      expect(result, hasLength(2));
      expect(result[0].id, '1');
      expect(result[1].id, '2');
      verify(mockStorage.getAllCaregiverLinks()).called(1);
    });

    test('build() returns empty list when storage is empty', () async {
      when(mockStorage.getAllCaregiverLinks()).thenAnswer((_) async => []);

      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(mockStorage)],
      );
      addTearDown(container.dispose);

      final result = await container.read(caregiverLinksProvider.future);
      expect(result, isEmpty);
    });

    test('addLink saves to storage and invalidates', () async {
      final link = makeLink('new');
      when(mockStorage.getAllCaregiverLinks()).thenAnswer((_) async => []);
      when(mockStorage.saveCaregiverLink(any)).thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(mockStorage)],
      );
      addTearDown(container.dispose);

      // Initial build
      await container.read(caregiverLinksProvider.future);

      // After addLink, storage should return the new link
      when(mockStorage.getAllCaregiverLinks()).thenAnswer((_) async => [link]);

      await container.read(caregiverLinksProvider.notifier).addLink(link);

      verify(mockStorage.saveCaregiverLink(link)).called(1);

      // After invalidation, should re-fetch
      final result = await container.read(caregiverLinksProvider.future);
      expect(result, hasLength(1));
      expect(result[0].id, 'new');
    });

    test('removeLink deletes from storage and invalidates', () async {
      final link = makeLink('1');
      when(mockStorage.getAllCaregiverLinks()).thenAnswer((_) async => [link]);
      when(mockStorage.deleteCaregiverLink(any)).thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(mockStorage)],
      );
      addTearDown(container.dispose);

      // Initial build
      await container.read(caregiverLinksProvider.future);

      // After removeLink, storage should return empty
      when(mockStorage.getAllCaregiverLinks()).thenAnswer((_) async => []);

      await container.read(caregiverLinksProvider.notifier).removeLink('1');

      verify(mockStorage.deleteCaregiverLink('1')).called(1);

      // After invalidation, should re-fetch
      final result = await container.read(caregiverLinksProvider.future);
      expect(result, isEmpty);
    });
  });

  group('canAddCaregiver', () {
    test('returns true when no caregivers and max is 1', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverLinksProvider.overrideWith(() => _FakeCaregiverLinks([])),
          maxCaregiversProvider.overrideWithValue(1),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(canAddCaregiverProvider.future);
      expect(result, isTrue);
    });

    test('returns false when at max capacity', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverLinksProvider.overrideWith(
            () => _FakeCaregiverLinks([makeLink('1')]),
          ),
          maxCaregiversProvider.overrideWithValue(1),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(canAddCaregiverProvider.future);
      expect(result, isFalse);
    });

    test('returns true when under max capacity with premium', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverLinksProvider.overrideWith(
            () => _FakeCaregiverLinks([makeLink('1'), makeLink('2')]),
          ),
          maxCaregiversProvider.overrideWithValue(999),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(canAddCaregiverProvider.future);
      expect(result, isTrue);
    });
  });

  group('remainingCaregiverSlots', () {
    test('returns max when no caregivers', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverLinksProvider.overrideWith(() => _FakeCaregiverLinks([])),
          maxCaregiversProvider.overrideWithValue(5),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        remainingCaregiverSlotsProvider.future,
      );
      expect(result, 5);
    });

    test('returns 0 when at capacity', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverLinksProvider.overrideWith(
            () => _FakeCaregiverLinks([makeLink('1')]),
          ),
          maxCaregiversProvider.overrideWithValue(1),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        remainingCaregiverSlotsProvider.future,
      );
      expect(result, 0);
    });

    test('clamps to 0 (never negative)', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverLinksProvider.overrideWith(
            () => _FakeCaregiverLinks([makeLink('1'), makeLink('2')]),
          ),
          maxCaregiversProvider.overrideWithValue(1),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        remainingCaregiverSlotsProvider.future,
      );
      expect(result, 0);
    });

    test('returns correct remaining with partial use', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverLinksProvider.overrideWith(
            () => _FakeCaregiverLinks([makeLink('1'), makeLink('2')]),
          ),
          maxCaregiversProvider.overrideWithValue(5),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        remainingCaregiverSlotsProvider.future,
      );
      expect(result, 3);
    });
  });
}

class _FakeCaregiverLinks extends CaregiverLinks {
  final List<CaregiverLink> _links;
  _FakeCaregiverLinks(this._links);

  @override
  Future<List<CaregiverLink>> build() async => _links;
}
