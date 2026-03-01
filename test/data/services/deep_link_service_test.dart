import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/services/deep_link_service.dart';

void main() {
  group('DeepLinkService.inviteCodePattern', () {
    final pattern = DeepLinkService.inviteCodePattern;

    test('accepts valid 8-char codes from server charset', () {
      expect(pattern.hasMatch('ABCDeFgH'), isTrue);
      expect(pattern.hasMatch('23456789'), isTrue);
      expect(pattern.hasMatch('HJKLMNPQ'), isTrue);
      expect(pattern.hasMatch('hjkmnpqr'), isTrue);
      expect(pattern.hasMatch('Ab2Cd3Ef'), isTrue);
    });

    test('rejects excluded ambiguous characters: 0, 1, I, O, i, o, l', () {
      expect(pattern.hasMatch('ABCDEFG0'), isFalse, reason: '0 excluded');
      expect(pattern.hasMatch('ABCDEFG1'), isFalse, reason: '1 excluded');
      expect(pattern.hasMatch('ABCDEFGI'), isFalse, reason: 'I excluded');
      expect(pattern.hasMatch('ABCDEFGO'), isFalse, reason: 'O excluded');
      expect(pattern.hasMatch('abcdefgi'), isFalse, reason: 'i excluded');
      expect(pattern.hasMatch('abcdefgo'), isFalse, reason: 'o excluded');
      expect(pattern.hasMatch('abcdefgl'), isFalse, reason: 'l excluded');
    });

    test('rejects wrong length', () {
      expect(pattern.hasMatch('ABCDeFg'), isFalse, reason: '7 chars');
      expect(pattern.hasMatch('ABCDeFgHJ'), isFalse, reason: '9 chars');
      expect(pattern.hasMatch(''), isFalse, reason: 'empty');
    });

    test('rejects special characters', () {
      expect(pattern.hasMatch('ABCDEF@H'), isFalse);
      expect(pattern.hasMatch('ABCDEF-H'), isFalse);
      expect(pattern.hasMatch('ABCDEF H'), isFalse);
      expect(pattern.hasMatch('ABCDEF!H'), isFalse);
    });
  });

  group('DeepLinkService instance', () {
    test('can be created', () {
      final service = DeepLinkService();
      expect(service, isNotNull);
      service.dispose();
    });

    test('inviteCodes stream is a broadcast stream', () {
      final service = DeepLinkService();
      expect(service.inviteCodes.isBroadcast, isTrue);
      service.dispose();
    });

    test('dispose does not throw', () {
      final service = DeepLinkService();
      expect(() => service.dispose(), returnsNormally);
    });
  });
}
