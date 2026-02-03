// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reportService)
final reportServiceProvider = ReportServiceProvider._();

final class ReportServiceProvider
    extends $FunctionalProvider<ReportService, ReportService, ReportService>
    with $Provider<ReportService> {
  ReportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportServiceHash();

  @$internal
  @override
  $ProviderElement<ReportService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReportService create(Ref ref) {
    return reportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportService>(value),
    );
  }
}

String _$reportServiceHash() => r'83c9418d968c3251db13e2081254858e32b04f82';
