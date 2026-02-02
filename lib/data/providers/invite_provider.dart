import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/services/cloud_functions_service.dart';

part 'invite_provider.g.dart';

/// Provider for the CloudFunctionsService singleton
@riverpod
CloudFunctionsService cloudFunctionsService(Ref ref) {
  return CloudFunctionsService();
}

/// Provider for managing caregiver invite link state
/// Handles generation, acceptance, and state management of invite links
@riverpod
class InviteLink extends _$InviteLink {
  @override
  Future<({String url, String code})?> build() async {
    // No invite generated initially
    return null;
  }

  /// Generate a new invite link for the current patient
  /// Returns the generated URL and code
  /// Updates state with loading/data/error states
  Future<({String url, String code})> generateLink() async {
    state = const AsyncValue.loading();
    try {
      final cfService = ref.read(cloudFunctionsServiceProvider);
      final result = await cfService.generateInviteLink();
      state = AsyncValue.data(result);
      return result;
    } catch (e, st) {
      debugPrint('Failed to generate invite link: $e');
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Accept an invite using a code (caregiver accepting patient's invite)
  /// Returns the patientId that was linked
  /// Does not modify this provider's state (used by caregivers, not patients)
  Future<String> acceptInvite(String code) async {
    try {
      final cfService = ref.read(cloudFunctionsServiceProvider);
      return await cfService.acceptInvite(code);
    } catch (e) {
      debugPrint('Failed to accept invite: $e');
      rethrow;
    }
  }

  /// Clear the current invite link state
  void clearLink() {
    state = const AsyncValue.data(null);
  }
}
