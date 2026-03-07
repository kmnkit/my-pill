import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:kusuridoki/data/providers/invite_provider.dart';
import 'package:kusuridoki/data/services/cloud_functions_service.dart';

import '../../mock_firebase.dart';

class MockCloudFunctionsService extends Mock implements CloudFunctionsService {
  @override
  Future<({String url, String code})> generateInviteLink() =>
      super.noSuchMethod(
        Invocation.method(#generateInviteLink, []),
        returnValue: Future.value((url: '', code: '')),
      ) as Future<({String url, String code})>;

  @override
  Future<String> acceptInvite(String code) =>
      super.noSuchMethod(
        Invocation.method(#acceptInvite, [code]),
        returnValue: Future.value(''),
      ) as Future<String>;

  @override
  Future<void> revokeAccess({
    required String caregiverId,
    required String linkId,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #revokeAccess,
          [],
          {#caregiverId: caregiverId, #linkId: linkId},
        ),
        returnValue: Future<void>.value(),
      ) as Future<void>;
}

void main() {
  setUpAll(() {
    setupFirebaseAuthMocks();
  });

  late MockCloudFunctionsService mockCfService;
  late ProviderContainer container;

  setUp(() {
    mockCfService = MockCloudFunctionsService();
    container = ProviderContainer(
      overrides: [
        cloudFunctionsServiceProvider.overrideWithValue(mockCfService),
      ],
    );
    addTearDown(container.dispose);
  });

  group('InviteLink notifier', () {
    // PROV-HAPPY-004
    test('state is AsyncData(null) on construction', () async {
      final result = await container.read(inviteLinkProvider.future);
      expect(result, isNull);
      expect(container.read(inviteLinkProvider), isA<AsyncData>());
    });

    // PROV-HAPPY-005
    test(
        'generateLink() success — state transitions through loading to AsyncData '
        'with url/code record', () async {
      const fakeUrl = 'https://kusuridoki.app/invite/ABCDefgh';
      const fakeCode = 'ABCDefgh';
      when(mockCfService.generateInviteLink()).thenAnswer(
        (_) async => (url: fakeUrl, code: fakeCode),
      );

      // Ensure provider is initialised
      await container.read(inviteLinkProvider.future);

      final result =
          await container.read(inviteLinkProvider.notifier).generateLink();

      expect(result.url, fakeUrl);
      expect(result.code, fakeCode);

      final state = container.read(inviteLinkProvider);
      expect(state, isA<AsyncData>());
      expect(state.value?.url, fakeUrl);
      expect(state.value?.code, fakeCode);

      verify(mockCfService.generateInviteLink()).called(1);
    });

    // PROV-HAPPY-006
    test(
        'acceptInvite() success — returns patientId, provider state stays null',
        () async {
      when(mockCfService.acceptInvite('ABCDefgh'))
          .thenAnswer((_) async => 'patient-123');

      await container.read(inviteLinkProvider.future);

      final patientId =
          await container.read(inviteLinkProvider.notifier).acceptInvite('ABCDefgh');

      expect(patientId, 'patient-123');

      // Provider state should still be null (acceptInvite does not modify state)
      final state = container.read(inviteLinkProvider);
      expect(state.value, isNull);

      verify(mockCfService.acceptInvite('ABCDefgh')).called(1);
    });

    // PROV-HAPPY-007
    test('clearLink() resets state to AsyncData(null)', () async {
      const fakeUrl = 'https://kusuridoki.app/invite/ABCDefgh';
      const fakeCode = 'ABCDefgh';
      when(mockCfService.generateInviteLink()).thenAnswer(
        (_) async => (url: fakeUrl, code: fakeCode),
      );

      await container.read(inviteLinkProvider.future);
      await container.read(inviteLinkProvider.notifier).generateLink();

      // Verify link is set
      expect(container.read(inviteLinkProvider).value, isNotNull);

      container.read(inviteLinkProvider.notifier).clearLink();

      final state = container.read(inviteLinkProvider);
      expect(state, isA<AsyncData>());
      expect(state.value, isNull);
    });

    // PROV-ERROR-001
    test('generateLink() failure — provider state becomes AsyncError', () async {
      when(mockCfService.generateInviteLink())
          .thenThrow(Exception('Network error'));

      await container.read(inviteLinkProvider.future);

      await expectLater(
        container.read(inviteLinkProvider.notifier).generateLink(),
        throwsA(isA<Exception>()),
      );

      final state = container.read(inviteLinkProvider);
      expect(state, isA<AsyncError>());
    });

    // PROV-ERROR-002
    test('acceptInvite() failure — exception propagates to caller', () async {
      when(mockCfService.acceptInvite('EXPIRED'))
          .thenThrow(Exception('Invite expired'));

      await container.read(inviteLinkProvider.future);

      await expectLater(
        container.read(inviteLinkProvider.notifier).acceptInvite('EXPIRED'),
        throwsA(isA<Exception>()),
      );

      verify(mockCfService.acceptInvite('EXPIRED')).called(1);
    });
  });
}
