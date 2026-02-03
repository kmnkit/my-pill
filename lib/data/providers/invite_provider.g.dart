// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the CloudFunctionsService singleton

@ProviderFor(cloudFunctionsService)
final cloudFunctionsServiceProvider = CloudFunctionsServiceProvider._();

/// Provider for the CloudFunctionsService singleton

final class CloudFunctionsServiceProvider
    extends
        $FunctionalProvider<
          CloudFunctionsService,
          CloudFunctionsService,
          CloudFunctionsService
        >
    with $Provider<CloudFunctionsService> {
  /// Provider for the CloudFunctionsService singleton
  CloudFunctionsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cloudFunctionsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cloudFunctionsServiceHash();

  @$internal
  @override
  $ProviderElement<CloudFunctionsService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CloudFunctionsService create(Ref ref) {
    return cloudFunctionsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CloudFunctionsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CloudFunctionsService>(value),
    );
  }
}

String _$cloudFunctionsServiceHash() =>
    r'ffd40613017b6d6dd5036b14c924ef6f1e23c52b';

/// Provider for managing caregiver invite link state
/// Handles generation, acceptance, and state management of invite links

@ProviderFor(InviteLink)
final inviteLinkProvider = InviteLinkProvider._();

/// Provider for managing caregiver invite link state
/// Handles generation, acceptance, and state management of invite links
final class InviteLinkProvider
    extends $AsyncNotifierProvider<InviteLink, ({String code, String url})?> {
  /// Provider for managing caregiver invite link state
  /// Handles generation, acceptance, and state management of invite links
  InviteLinkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inviteLinkProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inviteLinkHash();

  @$internal
  @override
  InviteLink create() => InviteLink();
}

String _$inviteLinkHash() => r'9b20e55e8408d7442f7389da3bb08efc5a4c4205';

/// Provider for managing caregiver invite link state
/// Handles generation, acceptance, and state management of invite links

abstract class _$InviteLink
    extends $AsyncNotifier<({String code, String url})?> {
  FutureOr<({String code, String url})?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<({String code, String url})?>,
              ({String code, String url})?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<({String code, String url})?>,
                ({String code, String url})?
              >,
              AsyncValue<({String code, String url})?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
