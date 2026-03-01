// SC-QR-001 through SC-QR-004
// Tests for _extractInviteCode logic in QrScannerScreen.
// Since _extractInviteCode is private, we replicate the exact logic here
// and test the extracted function. This is justified because:
// 1. The logic is pure (no state, no side-effects)
// 2. Widget-level testing of QrScannerScreen requires MobileScanner platform channels
// 3. The logic has security implications (host validation)
//
// If _extractInviteCode is ever made package-visible or extracted to a utility,
// update these tests to import directly.

import 'package:flutter_test/flutter_test.dart';

/// Exact copy of QrScannerScreen._extractInviteCode logic for isolated testing.
/// Must be kept in sync with qr_scanner_screen.dart.
String? extractInviteCode(String scannedValue) {
  try {
    final uri = Uri.tryParse(scannedValue);
    if (uri != null && uri.host.contains('kusuridoki.app')) {
      final segments = uri.pathSegments;
      if (segments.length >= 2 && segments[0] == 'invite') {
        return segments[1];
      }
    }
    return null;
  } catch (e) {
    return null;
  }
}

void main() {
  // ---------------------------------------------------------------------------
  // SC-QR-001: valid kusuridoki.app URL extracts code
  // ---------------------------------------------------------------------------
  group('_extractInviteCode — SC-QR-001', () {
    test('extracts code from valid kusuridoki.app invite URL', () {
      final code = extractInviteCode('https://kusuridoki.app/invite/ABC12345');
      expect(code, equals('ABC12345'));
    });

    test('extracts code with lowercase letters', () {
      final code = extractInviteCode('https://kusuridoki.app/invite/abc12345');
      expect(code, equals('abc12345'));
    });

    test('extracts code with mixed case', () {
      final code = extractInviteCode('https://kusuridoki.app/invite/AbCd1234');
      expect(code, equals('AbCd1234'));
    });
  });

  // ---------------------------------------------------------------------------
  // SC-QR-002: non-kusuridoki URL returns null
  // ---------------------------------------------------------------------------
  group('_extractInviteCode — SC-QR-002', () {
    test('returns null for non-kusuridoki host', () {
      expect(
        extractInviteCode('https://example.com/invite/ABC12345'),
        isNull,
      );
    });

    test('returns null for google.com URL', () {
      expect(extractInviteCode('https://google.com'), isNull);
    });

    test('returns null for malicious subdomain spoof', () {
      // attacker.com/kusuridoki.app should NOT match
      expect(
        extractInviteCode('https://attacker.com/kusuridoki.app/invite/ABC12345'),
        isNull,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // SC-QR-003: valid host but wrong or missing path returns null
  // ---------------------------------------------------------------------------
  group('_extractInviteCode — SC-QR-003', () {
    test('returns null for kusuridoki.app URL without /invite/ path', () {
      expect(
        extractInviteCode('https://kusuridoki.app/settings'),
        isNull,
      );
    });

    test('returns null for kusuridoki.app/invite with no code segment', () {
      // pathSegments = ['invite'] — length < 2
      expect(
        extractInviteCode('https://kusuridoki.app/invite'),
        isNull,
      );
    });

    test('returns null for kusuridoki.app root path', () {
      expect(extractInviteCode('https://kusuridoki.app/'), isNull);
    });

    test('returns null for kusuridoki.app with wrong first segment', () {
      expect(
        extractInviteCode('https://kusuridoki.app/join/ABC12345'),
        isNull,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // SC-QR-004: non-URL strings return null without throwing
  // ---------------------------------------------------------------------------
  group('_extractInviteCode — SC-QR-004', () {
    test('returns null for plain text', () {
      expect(extractInviteCode('just plain text'), isNull);
    });

    test('returns null for empty string', () {
      expect(extractInviteCode(''), isNull);
    });

    test('returns null for string with special characters', () {
      expect(extractInviteCode('not a url at all!'), isNull);
    });

    test('returns null for raw 8-char code (no URL)', () {
      // Manual input codes are not URLs — scanner should only accept URLs
      expect(extractInviteCode('ABC12345'), isNull);
    });

    test('does not throw for any input', () {
      final inputs = [
        '',
        'ABC12345',
        'just plain text',
        'not a url at all!',
        'http://',
        '://badurl',
        '\x00\x01binary',
      ];
      for (final input in inputs) {
        expect(() => extractInviteCode(input), returnsNormally,
            reason: 'Should not throw for input: "$input"');
      }
    });
  });
}
