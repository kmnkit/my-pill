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

    expect(patients.length, 2);
    expect(patients[0].patientId, 'demo-patient-sakura');
    expect(patients[0].patientName, 'さくら');
    expect(patients[0].linkedAt, isNull);
    expect(patients[1].patientId, 'demo-patient-haruki');
    expect(patients[1].patientName, 'はるき');
    expect(patients[1].linkedAt, isNull);
  });
}
