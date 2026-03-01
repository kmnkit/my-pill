import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/caregiver_link.dart';

void main() {
  group('CaregiverLink', () {
    final linkedAt = DateTime.utc(2024, 1, 15);

    CaregiverLink buildFull() => CaregiverLink(
      id: 'link-001',
      patientId: 'patient-001',
      caregiverId: 'caregiver-001',
      caregiverName: 'Jane Doe',
      status: 'connected',
      linkedAt: linkedAt,
    );

    CaregiverLink buildWithPendingStatus() => CaregiverLink(
      id: 'link-002',
      patientId: 'patient-002',
      caregiverId: 'caregiver-002',
      caregiverName: 'John Smith',
      status: 'pending',
      linkedAt: linkedAt,
    );

    CaregiverLink buildMinimal() => CaregiverLink(
      id: 'link-003',
      patientId: 'patient-003',
      caregiverId: 'caregiver-003',
      caregiverName: 'Bob Lee',
      linkedAt: linkedAt,
    );

    group('fromJson/toJson', () {
      test('roundtrip preserves all fields', () {
        final original = buildFull();
        final json = original.toJson();
        final restored = CaregiverLink.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.patientId, original.patientId);
        expect(restored.caregiverId, original.caregiverId);
        expect(restored.caregiverName, original.caregiverName);
        expect(restored.status, original.status);
        expect(restored.linkedAt, original.linkedAt);
      });

      test('toJson encodes linkedAt as ISO8601 string', () {
        final link = buildFull();
        final json = link.toJson();

        expect(json['linkedAt'], linkedAt.toIso8601String());
      });

      test('roundtrip preserves pending status', () {
        final original = buildWithPendingStatus();
        final restored = CaregiverLink.fromJson(original.toJson());

        expect(restored.status, 'pending');
      });

      test('roundtrip preserves caregiverName with special characters', () {
        final original = buildFull().copyWith(caregiverName: "O'Brien, Dr.");
        final restored = CaregiverLink.fromJson(original.toJson());

        expect(restored.caregiverName, "O'Brien, Dr.");
      });

      test('toJson contains all expected keys', () {
        final json = buildFull().toJson();

        expect(json.containsKey('id'), isTrue);
        expect(json.containsKey('patientId'), isTrue);
        expect(json.containsKey('caregiverId'), isTrue);
        expect(json.containsKey('caregiverName'), isTrue);
        expect(json.containsKey('status'), isTrue);
        expect(json.containsKey('linkedAt'), isTrue);
      });
    });

    group('copyWith', () {
      test(
        'copies with modified caregiverName leaves other fields unchanged',
        () {
          final original = buildFull();
          final copied = original.copyWith(caregiverName: 'Alice Wong');

          expect(copied.caregiverName, 'Alice Wong');
          expect(copied.id, original.id);
          expect(copied.patientId, original.patientId);
          expect(copied.caregiverId, original.caregiverId);
          expect(copied.status, original.status);
          expect(copied.linkedAt, original.linkedAt);
        },
      );

      test('copies with modified status', () {
        final original = buildFull();
        final copied = original.copyWith(status: 'revoked');

        expect(copied.status, 'revoked');
        expect(copied.id, original.id);
      });

      test('copies with modified patientId', () {
        final original = buildFull();
        final copied = original.copyWith(patientId: 'patient-999');

        expect(copied.patientId, 'patient-999');
        expect(copied.caregiverId, original.caregiverId);
      });

      test('copies with modified caregiverId', () {
        final original = buildFull();
        final copied = original.copyWith(caregiverId: 'caregiver-999');

        expect(copied.caregiverId, 'caregiver-999');
        expect(copied.patientId, original.patientId);
      });

      test('copies with modified linkedAt', () {
        final original = buildFull();
        final newLinkedAt = DateTime.utc(2024, 6, 1);
        final copied = original.copyWith(linkedAt: newLinkedAt);

        expect(copied.linkedAt, newLinkedAt);
        expect(copied.id, original.id);
      });
    });

    group('equality', () {
      test('two instances with same fields are equal', () {
        final a = buildFull();
        final b = buildFull();

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('instances with different id are not equal', () {
        final a = buildFull();
        final b = a.copyWith(id: 'different-id');

        expect(a, isNot(equals(b)));
      });

      test('instances with different patientId are not equal', () {
        final a = buildFull();
        final b = a.copyWith(patientId: 'patient-999');

        expect(a, isNot(equals(b)));
      });

      test('instances with different caregiverName are not equal', () {
        final a = buildFull();
        final b = a.copyWith(caregiverName: 'Different Name');

        expect(a, isNot(equals(b)));
      });

      test('instances with different status are not equal', () {
        final a = buildFull();
        final b = a.copyWith(status: 'pending');

        expect(a, isNot(equals(b)));
      });

      test('instances with different linkedAt are not equal', () {
        final a = buildFull();
        final b = a.copyWith(linkedAt: DateTime.utc(2024, 12, 31));

        expect(a, isNot(equals(b)));
      });
    });

    group('defaults', () {
      test('status defaults to connected', () {
        expect(buildMinimal().status, 'connected');
      });

      test('required fields must be provided', () {
        expect(buildMinimal().id, 'link-003');
        expect(buildMinimal().patientId, 'patient-003');
        expect(buildMinimal().caregiverId, 'caregiver-003');
        expect(buildMinimal().caregiverName, 'Bob Lee');
        expect(buildMinimal().linkedAt, linkedAt);
      });
    });
  });
}
