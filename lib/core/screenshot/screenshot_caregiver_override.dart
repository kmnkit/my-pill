import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/providers/caregiver_monitoring_provider.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_badge.dart';

const _patientSakura = 'demo-patient-sakura';
const _patientHaruki = 'demo-patient-haruki';

/// Two demo patients for the caregiver dashboard screenshot.
final caregiverPatientsOverride = caregiverPatientsProvider.overrideWith(
  (ref) => Stream.value([
    (patientId: _patientSakura, patientName: 'さくら', linkedAt: null),
    (patientId: _patientHaruki, patientName: 'はるき', linkedAt: null),
  ]),
);

// --- さくら: 92%, 3 meds ---
final caregiverAdherenceOverride = patientDailyAdherenceProvider(
  _patientSakura,
).overrideWith((_) async => 92.0);

final caregiverMedicationStatusOverride = patientMedicationStatusProvider(
  _patientSakura,
).overrideWith(
  (_) async => [
    {
      'shape': PillShape.round,
      'color': PillColor.white,
      'name': 'アムロジピン錠',
      'status': '服用済み',
      'variant': MpBadgeVariant.taken,
    },
    {
      'shape': PillShape.oval,
      'color': PillColor.white,
      'name': 'メトホルミン錠',
      'status': '服用済み',
      'variant': MpBadgeVariant.taken,
    },
    {
      'shape': PillShape.capsule,
      'color': PillColor.yellow,
      'name': 'ビタミンD3',
      'status': '次回',
      'variant': MpBadgeVariant.upcoming,
    },
  ],
);

// --- はるき: 78%, 2 meds ---
final caregiverAdherenceOverride2 = patientDailyAdherenceProvider(
  _patientHaruki,
).overrideWith((_) async => 78.0);

final caregiverMedicationStatusOverride2 = patientMedicationStatusProvider(
  _patientHaruki,
).overrideWith(
  (_) async => [
    {
      'shape': PillShape.capsule,
      'color': PillColor.purple,
      'name': 'オメプラゾール',
      'status': '服用済み',
      'variant': MpBadgeVariant.taken,
    },
    {
      'shape': PillShape.oval,
      'color': PillColor.blue,
      'name': 'セチリジン錠',
      'status': '次回',
      'variant': MpBadgeVariant.upcoming,
    },
  ],
);
