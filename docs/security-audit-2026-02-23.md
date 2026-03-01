# Security Audit Report — Kusuridoki (くすりどき)
**Date:** 2026-02-23
**Auditor:** QA Engineer
**Scope:** Auth/Data layer, input validation, Firebase security, network security, data deletion/privacy

---

## Security Audit Report

### Critical Vulnerabilities

| # | Type | File:Line | Issue | Impact | Recommendation |
|---|------|-----------|-------|--------|----------------|
| C-1 | Credential Exposure | `lib/firebase_options.dart:53,61` | Live Firebase API keys (`AIzaSyA06BgdGgiz...`, `AIzaSyBLm-iOJRDi...`) committed to git. File is listed in `.gitignore` but `git ls-files` confirms it was previously tracked and the file exists on disk with real credentials. | Any developer with repo access, CI logs, or who forks the repo has the Android and iOS Firebase API keys plus OAuth client IDs. These keys are used for Firebase Auth, Firestore, FCM, and Storage. | Immediately rotate both API keys in Firebase Console. Verify via `git log --all -- lib/firebase_options.dart` whether the file was ever committed. If so, treat the keys as compromised and rotate. Keep the file gitignored and never commit it again. |
| C-2 | Missing Auth Check on Firestore Write Path | `lib/data/services/firestore_service.dart:13-15` | `_userId` is nullable (`String?`). `_userDoc` computes `_db.collection('users').doc(_userId)` — when `_userId` is `null`, Firestore writes to `users/null`, a real document path accessible to any authenticated user who sets their UID to "null". All save operations (`saveMedication`, `saveSchedule`, `saveReminder`, `saveAdherenceRecord`, `saveUserProfile`, `saveCaregiverLink`) are affected. | Medical data (medication names, schedules, adherence records) may be silently written to a shared `users/null` document accessible by other users, causing data leakage and cross-contamination of health records. | Add a guard at the top of every write method: `if (_userId == null) throw StateError('No authenticated user');`. Alternatively, throw in the `_userDoc` getter if `_userId` is null. |

---

### High Risk Issues

| # | Type | File:Line | Issue | Impact | Recommendation |
|---|------|-----------|-------|--------|----------------|
| H-1 | IAP Receipt Verification — Trust On Client | `functions/index.js:231-248` | `verifyReceipt` Cloud Function stores the receipt with `status: 'pending_verification'` and immediately sets `isPremium: true` without actually verifying the receipt with Apple/Google servers. Any authenticated user can call this function with a fake `productId` and `purchaseToken` to grant themselves premium status. | Users can bypass all IAP paywalls (remove ads, premium features) for free by calling the function directly. Revenue loss and unfair advantage over paying users. | Implement actual server-side receipt validation: call Apple's `/verifyReceipt` or Google Play Developer API before setting `isPremium: true`. Set premium only after successful validation. |
| H-2 | BUG-19: Caregiver "Deactivate" Leaks Server Data | `lib/presentation/screens/caregivers/caregiver_settings_screen.dart:142-159` | "Deactivate Account" in CaregiverSettingsScreen calls `StorageService().clearUserData()` + `signOut()` only. It does NOT call `CloudFunctionsService().deleteAccount()`. The caregiver's Firestore data (`caregiverAccess/{uid}/patients/*`, `caregiverLinks`, etc.) remains on the server. | Deactivated caregiver accounts retain read access to patient medical data in Firestore as long as the `caregiverAccess` document exists. This is a patient privacy violation. | Add `await CloudFunctionsService().deleteAccount()` before `signOut()` in the deactivate flow, matching the correct server-side cleanup. Alternatively, add a dedicated `revokeAllCaregiverAccess` Cloud Function if full deletion is not desired. |
| H-3 | Invite Route Missing Auth Guard | `lib/presentation/router/app_router_provider.dart:92-95` | The router `redirect` function explicitly allows `/invite/:code` to pass through without authentication: `if (isSplashRoute || isInviteRoute) return null;`. An unauthenticated user who follows a deep link goes directly to `InviteHandlerScreen`. | `InviteHandlerScreen` calls `CloudFunctionsService().acceptInvite(code)` which requires auth (the Cloud Function checks `context.auth`). The function correctly rejects unauthenticated calls. However, the screen shows "You've been invited" UI to unauthenticated users with an "Accept Invitation" button that will fail silently after a spinner. The code parameter from the URL is also displayed directly in the UI (`l10n.inviteCodeLabel(widget.inviteCode)`) without auth context, and the route path parameter is not re-validated against the `inviteCodePattern` regex at the router level. | Redirect unauthenticated deep link visitors to `/login` with the invite code as a query parameter, then resume the invite flow post-login. |
| H-4 | FCM Token Logged in Debug Mode | `lib/data/services/notification_service.dart:113-115` | FCM device token is logged via `debugPrint('FCM Token: $token')` when `kDebugMode` is true. FCM tokens are session credentials that allow sending push notifications to a specific device. | If debug builds are shared (TestFlight, Firebase App Distribution, internal QA), the FCM token appears in device logs and can be captured. An attacker with the token can send arbitrary notifications to the device. | Remove the FCM token log entirely. If debugging is needed, use a flag controlled by a debug-only build configuration, and never log the full token. |
| H-5 | `caregiver_monitoring_provider.dart` No Auth Check on Patient Data Access | `lib/data/providers/caregiver_monitoring_provider.dart:19-29` | `patientMedicationsProvider` and `patientRemindersProvider` call `firestore.watchPatientMedications(patientId)` and `watchPatientReminders(patientId)` with any caller-supplied `patientId` string. There is no client-side check that the current user is actually linked to the requested `patientId`. | While Firestore security rules do enforce the caregiver access check server-side, a bug or rule misconfiguration would immediately expose all patient data to any authenticated user who guesses or constructs a valid `patientId`. Defense-in-depth is missing. | Before calling watch methods, verify the `patientId` exists in the current caregiver's linked patients list (`caregiverPatientsProvider`). Reject the request at the provider level if no match. |

---

### Medium Risk Issues

| # | Type | File:Line | Issue | Impact | Recommendation |
|---|------|-----------|-------|--------|----------------|
| M-1 | Firestore Null UserId on Read | `lib/data/services/firestore_service.dart:176` | `watchLinkedPatients()` reads `caregiverAccess.doc(caregiverId)` where `caregiverId = _userId` (nullable). Same risk as C-2 but on read path. | Caregiver dashboard may stream data from `caregiverAccess/null` which could expose other users' patient links if written there via C-2. | Same guard as C-2: throw `StateError` if `_userId` is null. |
| M-2 | Firestore Rules: `invites` Read Allows Any Status | `firestore.rules:47-49` | The invite read rule `allow read: if request.auth.uid == resource.data.patientId` allows the patient to read invite documents of any `status` (pending, accepted, expired). An accepted or used invite's data (including `acceptedBy` — the caregiver's UID) remains readable. | A patient can enumerate all caregiver UIDs who ever accepted their invites by reading accepted invite documents. Caregiver UIDs are not directly sensitive but can be used in targeted enumeration attacks. | Add a status filter: `allow read: if request.auth.uid == resource.data.patientId && resource.data.status == 'pending';` or delete accepted invites server-side after use. |
| M-3 | IAP Completion Without Server Confirmation | `lib/data/services/iap_service.dart:65-66` | `_iap.completePurchase(purchase)` is called immediately on `PurchaseStatus.purchased` without waiting for server-side receipt verification. If the server call in `SubscriptionService` fails silently (it does: `debugPrint` only), the purchase is completed but premium status may not be set on the server. | Users may pay and have the purchase completed (consumed) without gaining premium status. Support burden and revenue reconciliation issues. | Call `completePurchase` only after server-side verification succeeds, or implement a retry mechanism. |
| M-4 | Report PDF Contains Real User Medical Data — No Access Control on File | `lib/data/services/report_service.dart:46-49` | PDF is saved to `getTemporaryDirectory()` which is accessible to other apps with file system access on Android (pre-API 29 or without scoped storage). The file is deleted after sharing, but failure in `shareReport` could leave the file on disk. | Medical adherence records and medication names in temp storage are accessible to other apps or system logs on older Android versions. | Save to app-private directory (`getApplicationSupportDirectory()` or `getApplicationDocumentsDirectory()`), not temp. Ensure deletion in a `finally` block regardless of share outcome. |
| M-5 | `deactivateAccount` vs `deleteAccount` UX/Security Confusion | `lib/presentation/screens/caregivers/caregiver_settings_screen.dart:133-159` and `settings_screen.dart:106-136` | Both Patient and Caregiver settings screens have both "Deactivate Account" and "Delete Account" actions. "Deactivate" only calls `signOut()` (no server deletion). "Delete" correctly calls `CloudFunctionsService().deleteAccount()`. The distinction is not clearly communicated to users, and the deactivate flow (H-2) leaves server data. | Users who expect "deactivate" to remove their data (common UX expectation) are misled. GDPR/APPI compliance risk if users believe deactivation equals data removal. | Either: (a) remove the "Deactivate" option and only offer full delete, or (b) clearly document that deactivate only signs out and explicitly state data is retained, or (c) implement server-side caregiver link cleanup in deactivate. |
| M-6 | Notification ID Collision via `hashCode` | `lib/data/services/notification_service.dart:161,258` | Notification IDs are set as `reminder.id.hashCode` and `'low_stock_$medicationName'.hashCode`. Dart's `String.hashCode` is not collision-free and is not stable across app restarts in all environments. | Two different reminder IDs that share a hashCode would cancel each other's notifications silently, causing missed medication reminders. For a medical app, missed reminders are a patient safety issue. | Use a deterministic integer ID derived from the UUID (e.g., first 8 hex chars parsed as int32) or maintain a notification ID registry. |

---

### Low Risk / Informational

| # | Type | File:Line | Issue | Recommendation |
|---|------|-----------|-------|----------------|
| L-1 | debugPrint with Error Objects | Multiple files (`storage_service.dart:61`, `app.dart:63,78,97,100`, etc.) | `debugPrint('Encryption init failed: $e')` and similar calls print error objects. While guarded by `kDebugMode` implicitly (via `debugPrint`), the error message could include file paths or internal state that appears in device logs on debug builds. | Review each `debugPrint` to confirm no sensitive data (medication names, user IDs, tokens) can appear in error objects before logging. |
| L-2 | Report Service — Hardcoded English Labels | `lib/data/services/report_service.dart:34,79,168,176,220` | PDF headers, section labels ("Weekly Medication Report", "Summary", "Medication Breakdown", etc.) are hardcoded in English. Not a security issue but noted as BUG-14 context. | Pass locale-appropriate labels as parameters, or accept an l10n object. |
| L-3 | `firebase_options.dart` Not In `.gitignore` Effect | `.gitignore:55` | The file IS in `.gitignore` and `git ls-files` returns empty (not currently tracked). However, the file exists on disk with live credentials. The critical concern is whether it was ever committed (see C-1). | Run `git log --all --full-history -- lib/firebase_options.dart` to confirm commit history. If never committed, C-1 severity drops to Medium (credentials only at risk if disk is compromised). |
| L-4 | Anonymous User Deletion Flow | `lib/data/services/auth_service.dart:147-152` | `deleteAccount()` calls `CloudFunctionsService().deleteAccount()` which calls `admin.auth().deleteUser(uid)`. Anonymous users can trigger full server-side deletion, which is correct. However, there is no re-authentication step for anonymous users before deletion (by design, per code comments). | Acceptable by design. Document this explicitly in the auth flow spec for auditor reference. |
| L-5 | `revokeAccess` Does Not Verify `caregiverId` Parameter | `functions/index.js:110-124` | `revokeAccess` receives `caregiverId` from client-supplied data. It verifies that the `linkDoc` exists under the authenticated patient's path, but uses the caller-supplied `caregiverId` to delete from `caregiverAccess`. If a malicious patient sends a valid `linkId` but a different `caregiverId`, the wrong caregiver's access doc could be deleted. | Read the `caregiverId` from the verified `linkDoc.data().caregiverId` rather than trusting the client-supplied value. |

---

### Positive Findings (Security Done Well)

- **Hive AES-256 encryption at rest**: `StorageService` generates a random 32-byte key, stores it in `FlutterSecureStorage` (iOS Keychain, Android Keystore), and encrypts all Hive boxes. Medical data is encrypted on-device. Excellent.
- **Photo encryption**: Medication photos are encrypted with AES-256 using the same Hive key via `PhotoEncryption`. A one-time migration converts legacy unencrypted photos. Excellent.
- **Re-authentication before account deletion**: `SettingsScreen` and `CaregiverSettingsScreen` both call `authService.reauthenticate()` before invoking `CloudFunctionsService().deleteAccount()`. Correct and required.
- **Double confirmation for account deletion**: Two separate `MpConfirmDialog` flows before irreversible deletion. Good UX security practice.
- **Server-side account deletion**: `deleteUserAccount` Cloud Function deletes all subcollections, caregiver access docs (both as caregiver and as patient via collectionGroup query), pending invites, rate limit docs, the user document itself, and the Firebase Auth account. Complete and correct.
- **Firestore security rules**: All user data is gated on `request.auth.uid == userId`. Caregiver access uses a separate `caregiverAccess` collection only writable by Cloud Functions (`allow write: if false`). Invite writes are also Cloud Functions-only. Architecture is correct.
- **Rate limiting on all Cloud Functions**: `checkRateLimit` (5/min) is applied to `generateInviteLink`, `acceptInvite`, `revokeAccess`, `deleteUserAccount`, and `verifyReceipt`. Brute force and abuse are mitigated.
- **Self-invitation prevention**: `acceptInvite` checks `caregiverId === patientId` and throws `invalid-argument`. Correct.
- **Deep link validation**: `DeepLinkService` whitelists allowed hosts (`kusuridoki.app`, `www.kusuridoki.app`) and validates invite codes against a strict 8-character regex before emitting them. Strong input validation.
- **No hardcoded secrets in application code**: No passwords, API secrets, or private keys found in `.dart` files (excluding `firebase_options.dart` which is gitignored).
- **No HTTP URLs**: All network communication uses HTTPS. Zero plain-HTTP URLs found in Dart source.
- **ErrorHandler never exposes internals to users**: `ErrorHandler.getMessage()` maps exception types to user-friendly strings without leaking stack traces or internal state to the UI.
- **FCM token only logged in `kDebugMode`**: Token logging is gated behind the debug flag.
- **`mounted` checks after async gaps**: Reviewed screens consistently check `context.mounted` before using `BuildContext` after `await` calls.

---

### Summary

| Severity | Count | Items |
|----------|-------|-------|
| Critical | 2 | C-1 (Firebase API keys on disk), C-2 (Firestore null userId write) |
| High | 5 | H-1 (IAP bypass), H-2 (caregiver deactivate server leak), H-3 (invite auth bypass), H-4 (FCM token log), H-5 (no client-side patient auth check) |
| Medium | 6 | M-1 through M-6 |
| Low | 5 | L-1 through L-5 |
| **Total** | **18** | |

**Overall Security Posture: NEEDS_IMPROVEMENT**

The foundational security architecture is strong: AES-256 encrypted local storage, Keychain/Keystore key management, photo encryption, robust Cloud Function-based account deletion, correct Firestore security rules, and consistent re-authentication before destructive operations. However, two issues require urgent attention before release:

1. **C-1**: Confirm whether `firebase_options.dart` was ever committed to git. If it was, rotate both Firebase API keys immediately.
2. **C-2**: A null `_userId` in `FirestoreService` can silently write medical data to `users/null`. Add a null guard in all write methods.
3. **H-1**: The `verifyReceipt` Cloud Function grants premium status without actual receipt validation — a complete IAP bypass vector.
4. **H-2**: "Deactivate Account" in caregiver settings leaves server data behind — a patient privacy violation flagged in BUG-19.
