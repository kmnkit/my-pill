// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adherence_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(overallAdherence)
final overallAdherenceProvider = OverallAdherenceProvider._();

final class OverallAdherenceProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  OverallAdherenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overallAdherenceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overallAdherenceHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return overallAdherence(ref);
  }
}

String _$overallAdherenceHash() => r'42a563d9faf060c9c989d798f9cd4cecb45fc2bc';

@ProviderFor(medicationAdherence)
final medicationAdherenceProvider = MedicationAdherenceFamily._();

final class MedicationAdherenceProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  MedicationAdherenceProvider._({
    required MedicationAdherenceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'medicationAdherenceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$medicationAdherenceHash();

  @override
  String toString() {
    return r'medicationAdherenceProvider'
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
    return medicationAdherence(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MedicationAdherenceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$medicationAdherenceHash() =>
    r'90d563858543895985cecf4c33e483711892a3b2';

final class MedicationAdherenceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<double>, String> {
  MedicationAdherenceFamily._()
    : super(
        retry: null,
        name: r'medicationAdherenceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MedicationAdherenceProvider call(String medicationId) =>
      MedicationAdherenceProvider._(argument: medicationId, from: this);

  @override
  String toString() => r'medicationAdherenceProvider';
}

@ProviderFor(weeklyAdherence)
final weeklyAdherenceProvider = WeeklyAdherenceProvider._();

final class WeeklyAdherenceProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, double>>,
          Map<String, double>,
          FutureOr<Map<String, double>>
        >
    with
        $FutureModifier<Map<String, double>>,
        $FutureProvider<Map<String, double>> {
  WeeklyAdherenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyAdherenceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyAdherenceHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, double>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, double>> create(Ref ref) {
    return weeklyAdherence(ref);
  }
}

String _$weeklyAdherenceHash() => r'88cd3c583d1a1547dbe3bcfe089f66ae757f84e5';

@ProviderFor(medicationBreakdown)
final medicationBreakdownProvider = MedicationBreakdownProvider._();

final class MedicationBreakdownProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<({String id, String name, double percentage})>>,
          List<({String id, String name, double percentage})>,
          FutureOr<List<({String id, String name, double percentage})>>
        >
    with
        $FutureModifier<List<({String id, String name, double percentage})>>,
        $FutureProvider<List<({String id, String name, double percentage})>> {
  MedicationBreakdownProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicationBreakdownProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medicationBreakdownHash();

  @$internal
  @override
  $FutureProviderElement<List<({String id, String name, double percentage})>>
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<({String id, String name, double percentage})>> create(
    Ref ref,
  ) {
    return medicationBreakdown(ref);
  }
}

String _$medicationBreakdownHash() =>
    r'255eede48769b968da22bce3559f7ef6534f43e9';

@ProviderFor(adherenceRating)
final adherenceRatingProvider = AdherenceRatingFamily._();

final class AdherenceRatingProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  AdherenceRatingProvider._({
    required AdherenceRatingFamily super.from,
    required double super.argument,
  }) : super(
         retry: null,
         name: r'adherenceRatingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adherenceRatingHash();

  @override
  String toString() {
    return r'adherenceRatingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as double;
    return adherenceRating(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AdherenceRatingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adherenceRatingHash() => r'bc33c57edf2c2b293968073cbafa845c19eb23a8';

final class AdherenceRatingFamily extends $Family
    with $FunctionalFamilyOverride<String, double> {
  AdherenceRatingFamily._()
    : super(
        retry: null,
        name: r'adherenceRatingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AdherenceRatingProvider call(double percentage) =>
      AdherenceRatingProvider._(argument: percentage, from: this);

  @override
  String toString() => r'adherenceRatingProvider';
}

@ProviderFor(medicationHistory)
final medicationHistoryProvider = MedicationHistoryFamily._();

final class MedicationHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AdherenceRecord>>,
          List<AdherenceRecord>,
          FutureOr<List<AdherenceRecord>>
        >
    with
        $FutureModifier<List<AdherenceRecord>>,
        $FutureProvider<List<AdherenceRecord>> {
  MedicationHistoryProvider._({
    required MedicationHistoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'medicationHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$medicationHistoryHash();

  @override
  String toString() {
    return r'medicationHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AdherenceRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AdherenceRecord>> create(Ref ref) {
    final argument = this.argument as String;
    return medicationHistory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MedicationHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$medicationHistoryHash() => r'189253ee9d922974045e74f2d500945ce34165e9';

final class MedicationHistoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AdherenceRecord>>, String> {
  MedicationHistoryFamily._()
    : super(
        retry: null,
        name: r'medicationHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MedicationHistoryProvider call(String medicationId) =>
      MedicationHistoryProvider._(argument: medicationId, from: this);

  @override
  String toString() => r'medicationHistoryProvider';
}
