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

String _$overallAdherenceHash() => r'cb83059e2e63509b196c2dc9b7ca43ebf083e3ba';

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
    r'7f9ba357f7b5f86a8536f42b51a0547541b11a07';

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

String _$weeklyAdherenceHash() => r'1bf5d000286381bd07d5f491a05be4e09e555946';

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
