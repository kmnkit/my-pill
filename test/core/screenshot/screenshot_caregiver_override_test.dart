import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/core/screenshot/screenshot_caregiver_override.dart';
import 'package:kusuridoki/data/providers/caregiver_monitoring_provider.dart';

void main() {
  test('caregiverPatientsOverride returns one demo patient', () async {
    final container = ProviderContainer(
      overrides: [caregiverPatientsOverride],
    );
    addTearDown(container.dispose);

    // Keep provider alive (auto-dispose would cancel it before stream emits)
    final sub = container.listen(caregiverPatientsProvider, (_, __) {});
    addTearDown(sub.close);

    final patients = await container.read(caregiverPatientsProvider.future);

    expect(patients.length, 1);
    expect(patients.first.patientId, 'demo-patient');
    expect(patients.first.patientName, 'さくら');
    expect(patients.first.linkedAt, isNull);
  });
}
