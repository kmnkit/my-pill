import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  final StreamController<String> _inviteCodeController = StreamController<String>.broadcast();

  Stream<String> get inviteCodes => _inviteCodeController.stream;

  // Initialize - call from main.dart
  Future<void> initialize() async {
    // Handle cold start (app opened via link)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }
    } catch (e) {
      debugPrint('No initial deep link: $e');
    }

    // Handle warm start (app already running)
    _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (e) => debugPrint('Deep link error: $e'),
    );
  }

  void _handleUri(Uri uri) {
    // Expected format: https://mypill.app/invite/{code}
    if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == 'invite') {
      final code = uri.pathSegments[1];
      _inviteCodeController.add(code);
    }
  }

  void dispose() {
    _inviteCodeController.close();
  }
}
