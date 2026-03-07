import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_functions_platform_interface/cloud_functions_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/services/cloud_functions_service.dart';

import '../../mock_firebase.dart';

// ---------------------------------------------------------------------------
// Fake platform infrastructure
// ---------------------------------------------------------------------------

/// A fake [HttpsCallablePlatform] that delegates to a user-supplied callback.
class _FakeHttpsCallablePlatform extends HttpsCallablePlatform {
  _FakeHttpsCallablePlatform(
    super.functions,
    super.origin,
    super.name,
    super.options,
    super.uri,
    this._onCall,
  );

  final Future<dynamic> Function(dynamic parameters) _onCall;

  @override
  Future<dynamic> call([dynamic parameters]) => _onCall(parameters);
}

/// A fake [FirebaseFunctionsPlatform] that dispatches calls to per-test handlers.
///
/// A single instance is used for all tests (registered in setUpAll) so that
/// the [FirebaseFunctions._cachedInstances] cache (private, not clearable from
/// tests) always resolves to this platform. Per-test handlers are set via
/// [setHandler] before each test.
class _FakeFirebaseFunctionsPlatform extends FirebaseFunctionsPlatform {
  _FakeFirebaseFunctionsPlatform() : super(null, 'us-central1');

  final Map<String, Future<dynamic> Function(dynamic)> _handlers = {};

  /// Register a handler for a specific Cloud Function name.
  void setHandler(String name, Future<dynamic> Function(dynamic) handler) {
    _handlers[name] = handler;
  }

  @override
  FirebaseFunctionsPlatform delegateFor(
          {dynamic app, required String region}) =>
      this;

  @override
  HttpsCallablePlatform httpsCallable(
    String? origin,
    String name,
    HttpsCallableOptions options,
  ) {
    final handler = _handlers[name] ??
        (_) async =>
            throw Exception('No fake handler registered for function: $name');
    return _FakeHttpsCallablePlatform(this, origin, name, options, null, handler);
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // Single fake platform instance; registered once so that FirebaseFunctions
  // caches pick it up on first access and continue using it across tests.
  final fakePlatform = _FakeFirebaseFunctionsPlatform();

  setUpAll(() {
    setupFirebaseAuthMocks();
    FirebaseFunctionsPlatform.instance = fakePlatform;
  });

  group('CloudFunctionsService', () {
    // CFSVC-HAPPY-001
    test('generateInviteLink() maps url and code fields to typed record',
        () async {
      fakePlatform.setHandler('generateInviteLink', (_) async => {
            'url': 'https://kusuridoki.app/invite/ABCDefgh',
            'code': 'ABCDefgh',
          });

      final result = await CloudFunctionsService().generateInviteLink();

      expect(result.url, 'https://kusuridoki.app/invite/ABCDefgh');
      expect(result.code, 'ABCDefgh');
    });

    // CFSVC-HAPPY-002
    test('acceptInvite() returns patientId when success is true', () async {
      fakePlatform.setHandler('acceptInvite', (_) async => {
            'success': true,
            'patientId': 'patient-123',
          });

      final patientId = await CloudFunctionsService().acceptInvite('ABCDefgh');

      expect(patientId, 'patient-123');
    });

    // CFSVC-ERROR-001
    test(
        'acceptInvite() throws Exception containing "Failed to accept invite" '
        'when success is false', () async {
      fakePlatform.setHandler('acceptInvite',
          (_) async => {'success': false});

      await expectLater(
        CloudFunctionsService().acceptInvite('EXPIRED1'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to accept invite'),
          ),
        ),
      );
    });

    // CFSVC-HAPPY-003
    test('revokeAccess() completes without error when success is true',
        () async {
      fakePlatform.setHandler('revokeAccess',
          (_) async => {'success': true});

      await expectLater(
        CloudFunctionsService().revokeAccess(caregiverId: 'cg-1', linkId: 'link-1'),
        completes,
      );
    });

    // CFSVC-ERROR-002
    test(
        'revokeAccess() throws Exception containing "Failed to revoke access" '
        'when success is false', () async {
      fakePlatform.setHandler('revokeAccess',
          (_) async => {'success': false});

      await expectLater(
        CloudFunctionsService().revokeAccess(caregiverId: 'cg-1', linkId: 'link-1'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to revoke access'),
          ),
        ),
      );
    });

    // CFSVC-HAPPY-004
    test('verifyReceipt() completes without error when success is true',
        () async {
      fakePlatform.setHandler('verifyReceipt',
          (_) async => {'success': true});

      await expectLater(
        CloudFunctionsService().verifyReceipt(
          productId: 'premium_monthly',
          purchaseToken: 'token123',
          source: 'apple',
        ),
        completes,
      );
    });

    // CFSVC-HAPPY-005
    test('deleteAccount() completes without error when success is true',
        () async {
      fakePlatform.setHandler('deleteUserAccount',
          (_) async => {'success': true});

      await expectLater(CloudFunctionsService().deleteAccount(), completes);
    });

    // CFSVC-ERROR-003
    test(
        'deleteAccount() throws Exception containing "Failed to delete account" '
        'when success is false', () async {
      fakePlatform.setHandler('deleteUserAccount',
          (_) async => {'success': false});

      await expectLater(
        CloudFunctionsService().deleteAccount(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to delete account'),
          ),
        ),
      );
    });
  });
}
