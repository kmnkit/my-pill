// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ScheduleList)
final scheduleListProvider = ScheduleListProvider._();

final class ScheduleListProvider
    extends $AsyncNotifierProvider<ScheduleList, List<Schedule>> {
  ScheduleListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleListHash();

  @$internal
  @override
  ScheduleList create() => ScheduleList();
}

String _$scheduleListHash() => r'e03d90979e05cdbeca799afbabbb6761a481fd04';

abstract class _$ScheduleList extends $AsyncNotifier<List<Schedule>> {
  FutureOr<List<Schedule>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Schedule>>, List<Schedule>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Schedule>>, List<Schedule>>,
              AsyncValue<List<Schedule>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(medicationSchedules)
final medicationSchedulesProvider = MedicationSchedulesFamily._();

final class MedicationSchedulesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Schedule>>,
          List<Schedule>,
          FutureOr<List<Schedule>>
        >
    with $FutureModifier<List<Schedule>>, $FutureProvider<List<Schedule>> {
  MedicationSchedulesProvider._({
    required MedicationSchedulesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'medicationSchedulesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$medicationSchedulesHash();

  @override
  String toString() {
    return r'medicationSchedulesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Schedule>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Schedule>> create(Ref ref) {
    final argument = this.argument as String;
    return medicationSchedules(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MedicationSchedulesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$medicationSchedulesHash() =>
    r'1a8fd0e134da40bf694cd1e4858b9ab4de4b31a2';

final class MedicationSchedulesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Schedule>>, String> {
  MedicationSchedulesFamily._()
    : super(
        retry: null,
        name: r'medicationSchedulesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MedicationSchedulesProvider call(String medicationId) =>
      MedicationSchedulesProvider._(argument: medicationId, from: this);

  @override
  String toString() => r'medicationSchedulesProvider';
}
