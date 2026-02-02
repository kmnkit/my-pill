// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caregiver_monitoring_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firestoreService)
final firestoreServiceProvider = FirestoreServiceProvider._();

final class FirestoreServiceProvider
    extends
        $FunctionalProvider<
          FirestoreService,
          FirestoreService,
          FirestoreService
        >
    with $Provider<FirestoreService> {
  FirestoreServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firestoreServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firestoreServiceHash();

  @$internal
  @override
  $ProviderElement<FirestoreService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirestoreService create(Ref ref) {
    return firestoreService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirestoreService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirestoreService>(value),
    );
  }
}

String _$firestoreServiceHash() => r'ab6a4068fcce40bd3123cf65d2f4d942f392e605';

@ProviderFor(patientMedications)
final patientMedicationsProvider = PatientMedicationsFamily._();

final class PatientMedicationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Medication>>,
          List<Medication>,
          Stream<List<Medication>>
        >
    with $FutureModifier<List<Medication>>, $StreamProvider<List<Medication>> {
  PatientMedicationsProvider._({
    required PatientMedicationsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'patientMedicationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$patientMedicationsHash();

  @override
  String toString() {
    return r'patientMedicationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Medication>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Medication>> create(Ref ref) {
    final argument = this.argument as String;
    return patientMedications(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PatientMedicationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$patientMedicationsHash() =>
    r'f04e76f0cf4e29aefe1e332b512bf79836603436';

final class PatientMedicationsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Medication>>, String> {
  PatientMedicationsFamily._()
    : super(
        retry: null,
        name: r'patientMedicationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PatientMedicationsProvider call(String patientId) =>
      PatientMedicationsProvider._(argument: patientId, from: this);

  @override
  String toString() => r'patientMedicationsProvider';
}

@ProviderFor(patientReminders)
final patientRemindersProvider = PatientRemindersFamily._();

final class PatientRemindersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Reminder>>,
          List<Reminder>,
          Stream<List<Reminder>>
        >
    with $FutureModifier<List<Reminder>>, $StreamProvider<List<Reminder>> {
  PatientRemindersProvider._({
    required PatientRemindersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'patientRemindersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$patientRemindersHash();

  @override
  String toString() {
    return r'patientRemindersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Reminder>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Reminder>> create(Ref ref) {
    final argument = this.argument as String;
    return patientReminders(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PatientRemindersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$patientRemindersHash() => r'285a6f03da05ec2dff4d8d6781312daefaef8531';

final class PatientRemindersFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Reminder>>, String> {
  PatientRemindersFamily._()
    : super(
        retry: null,
        name: r'patientRemindersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PatientRemindersProvider call(String patientId) =>
      PatientRemindersProvider._(argument: patientId, from: this);

  @override
  String toString() => r'patientRemindersProvider';
}

@ProviderFor(patientDailyAdherence)
final patientDailyAdherenceProvider = PatientDailyAdherenceFamily._();

final class PatientDailyAdherenceProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  PatientDailyAdherenceProvider._({
    required PatientDailyAdherenceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'patientDailyAdherenceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$patientDailyAdherenceHash();

  @override
  String toString() {
    return r'patientDailyAdherenceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as String;
    return patientDailyAdherence(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PatientDailyAdherenceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$patientDailyAdherenceHash() =>
    r'f271c0fa782921d4e11da7ac37d138d556a3ed4e';

final class PatientDailyAdherenceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<double>, String> {
  PatientDailyAdherenceFamily._()
    : super(
        retry: null,
        name: r'patientDailyAdherenceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PatientDailyAdherenceProvider call(String patientId) =>
      PatientDailyAdherenceProvider._(argument: patientId, from: this);

  @override
  String toString() => r'patientDailyAdherenceProvider';
}

@ProviderFor(caregiverPatients)
final caregiverPatientsProvider = CaregiverPatientsProvider._();

final class CaregiverPatientsProvider
    extends
        $FunctionalProvider<
          AsyncValue<
            List<({DateTime? linkedAt, String patientId, String patientName})>
          >,
          List<({DateTime? linkedAt, String patientId, String patientName})>,
          Stream<
            List<({DateTime? linkedAt, String patientId, String patientName})>
          >
        >
    with
        $FutureModifier<
          List<({DateTime? linkedAt, String patientId, String patientName})>
        >,
        $StreamProvider<
          List<({DateTime? linkedAt, String patientId, String patientName})>
        > {
  CaregiverPatientsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'caregiverPatientsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$caregiverPatientsHash();

  @$internal
  @override
  $StreamProviderElement<
    List<({DateTime? linkedAt, String patientId, String patientName})>
  >
  $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<({DateTime? linkedAt, String patientId, String patientName})>>
  create(Ref ref) {
    return caregiverPatients(ref);
  }
}

String _$caregiverPatientsHash() => r'82fb5277076dd524051f9894719c55b72b7fb539';

@ProviderFor(patientMedicationStatus)
final patientMedicationStatusProvider = PatientMedicationStatusFamily._();

final class PatientMedicationStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  PatientMedicationStatusProvider._({
    required PatientMedicationStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'patientMedicationStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$patientMedicationStatusHash();

  @override
  String toString() {
    return r'patientMedicationStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    final argument = this.argument as String;
    return patientMedicationStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PatientMedicationStatusProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$patientMedicationStatusHash() =>
    r'692aecd0afeca3403529fe52fba56df97bba4920';

final class PatientMedicationStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Map<String, dynamic>>>,
          String
        > {
  PatientMedicationStatusFamily._()
    : super(
        retry: null,
        name: r'patientMedicationStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PatientMedicationStatusProvider call(String patientId) =>
      PatientMedicationStatusProvider._(argument: patientId, from: this);

  @override
  String toString() => r'patientMedicationStatusProvider';
}
