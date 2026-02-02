// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timezone_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TimezoneSettings)
final timezoneSettingsProvider = TimezoneSettingsProvider._();

final class TimezoneSettingsProvider
    extends $NotifierProvider<TimezoneSettings, TimezoneState> {
  TimezoneSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timezoneSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timezoneSettingsHash();

  @$internal
  @override
  TimezoneSettings create() => TimezoneSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimezoneState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimezoneState>(value),
    );
  }
}

String _$timezoneSettingsHash() => r'12a0b81b08b7c9457b388e5d528dcef437c64c37';

abstract class _$TimezoneSettings extends $Notifier<TimezoneState> {
  TimezoneState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TimezoneState, TimezoneState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TimezoneState, TimezoneState>,
              TimezoneState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
