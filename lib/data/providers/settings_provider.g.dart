// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserSettings)
final userSettingsProvider = UserSettingsProvider._();

final class UserSettingsProvider
    extends $AsyncNotifierProvider<UserSettings, UserProfile> {
  UserSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSettingsHash();

  @$internal
  @override
  UserSettings create() => UserSettings();
}

String _$userSettingsHash() => r'21a685d7f2afd7c87bf0b5ebb42092ccb2757e52';

abstract class _$UserSettings extends $AsyncNotifier<UserProfile> {
  FutureOr<UserProfile> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserProfile>, UserProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserProfile>, UserProfile>,
              AsyncValue<UserProfile>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
