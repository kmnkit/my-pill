// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MedicationList)
final medicationListProvider = MedicationListProvider._();

final class MedicationListProvider
    extends $AsyncNotifierProvider<MedicationList, List<Medication>> {
  MedicationListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicationListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medicationListHash();

  @$internal
  @override
  MedicationList create() => MedicationList();
}

String _$medicationListHash() => r'c4438e0d52734f4aedf2d0eb138644719338bf38';

abstract class _$MedicationList extends $AsyncNotifier<List<Medication>> {
  FutureOr<List<Medication>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Medication>>, List<Medication>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Medication>>, List<Medication>>,
              AsyncValue<List<Medication>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(medication)
final medicationProvider = MedicationFamily._();

final class MedicationProvider
    extends
        $FunctionalProvider<
          AsyncValue<Medication?>,
          Medication?,
          FutureOr<Medication?>
        >
    with $FutureModifier<Medication?>, $FutureProvider<Medication?> {
  MedicationProvider._({
    required MedicationFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'medicationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$medicationHash();

  @override
  String toString() {
    return r'medicationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Medication?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Medication?> create(Ref ref) {
    final argument = this.argument as String;
    return medication(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MedicationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$medicationHash() => r'4693a260a12dc71732b31f7204bbb24c5db10baf';

final class MedicationFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Medication?>, String> {
  MedicationFamily._()
    : super(
        retry: null,
        name: r'medicationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MedicationProvider call(String id) =>
      MedicationProvider._(argument: id, from: this);

  @override
  String toString() => r'medicationProvider';
}
