// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TodayReminders)
final todayRemindersProvider = TodayRemindersProvider._();

final class TodayRemindersProvider
    extends $AsyncNotifierProvider<TodayReminders, List<Reminder>> {
  TodayRemindersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayRemindersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayRemindersHash();

  @$internal
  @override
  TodayReminders create() => TodayReminders();
}

String _$todayRemindersHash() => r'a34b8a965f055369d087fb8d49ff1b1ab6d36011';

abstract class _$TodayReminders extends $AsyncNotifier<List<Reminder>> {
  FutureOr<List<Reminder>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Reminder>>, List<Reminder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Reminder>>, List<Reminder>>,
              AsyncValue<List<Reminder>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
