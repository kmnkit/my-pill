import 'package:cloud_functions/cloud_functions.dart';

/// Service for interacting with Firebase Cloud Functions
/// Handles caregiver invite generation, acceptance, and revocation
class CloudFunctionsService {
  static final CloudFunctionsService _instance = CloudFunctionsService._();
  factory CloudFunctionsService() => _instance;
  CloudFunctionsService._();

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Generate an invite link for the current patient
  /// Returns a record with the shareable URL and the invite code
  /// Throws [FirebaseFunctionsException] on failure
  Future<({String url, String code})> generateInviteLink() async {
    final result = await _functions.httpsCallable('generateInviteLink').call();
    final data = result.data as Map<String, dynamic>;
    return (
      url: data['url'] as String,
      code: data['code'] as String,
    );
  }

  /// Accept an invite using an invite code (called by caregiver)
  /// Returns the patientId that was linked
  /// Throws [FirebaseFunctionsException] if code is invalid or expired
  Future<String> acceptInvite(String code) async {
    final result = await _functions.httpsCallable('acceptInvite').call({
      'code': code,
    });
    final data = result.data as Map<String, dynamic>;
    if (data['success'] != true) {
      throw Exception('Failed to accept invite');
    }
    return data['patientId'] as String;
  }

  /// Revoke caregiver access (called by patient)
  /// Removes bidirectional link between patient and caregiver
  /// Throws [FirebaseFunctionsException] on failure
  Future<void> revokeAccess({
    required String caregiverId,
    required String linkId,
  }) async {
    final result = await _functions.httpsCallable('revokeAccess').call({
      'caregiverId': caregiverId,
      'linkId': linkId,
    });
    final data = result.data as Map<String, dynamic>;
    if (data['success'] != true) {
      throw Exception('Failed to revoke access');
    }
  }

  /// Submit IAP receipt for server-side storage and premium status update.
  /// Fire-and-forget safe: callers should catch and log errors.
  Future<void> verifyReceipt({
    required String productId,
    required String purchaseToken,
    required String source,
  }) async {
    final result = await _functions.httpsCallable('verifyReceipt').call({
      'productId': productId,
      'purchaseToken': purchaseToken,
      'source': source,
    });
    final data = result.data as Map<String, dynamic>;
    if (data['success'] != true) {
      throw Exception('Failed to verify receipt');
    }
  }

  /// Delete the current user's account and all associated data (server-side)
  /// Throws [FirebaseFunctionsException] on failure
  Future<void> deleteAccount() async {
    final result = await _functions.httpsCallable('deleteUserAccount').call();
    final data = result.data as Map<String, dynamic>;
    if (data['success'] != true) {
      throw Exception('Failed to delete account');
    }
  }
}
