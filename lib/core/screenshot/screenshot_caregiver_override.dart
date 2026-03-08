import 'package:kusuridoki/data/providers/caregiver_monitoring_provider.dart';

/// Riverpod override for [caregiverPatientsProvider] used during screenshot
/// capture. Provides a single demo patient so the CaregiverDashboardScreen
/// renders populated content without a real Firestore connection.
// ignore: prefer_typing_uninitialized_variables
final caregiverPatientsOverride = caregiverPatientsProvider.overrideWith(
  (ref) => Stream.value([
    (patientId: 'demo-patient', patientName: 'さくら', linkedAt: null),
  ]),
);
