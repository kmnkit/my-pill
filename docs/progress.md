# Project Progress — Kusuridoki (くすりどき)

## Current Status: Post-Remediation (PO Re-evaluation Pending)

PO initial evaluation: **4.5/10 (NO-GO)**. This document reflects the state after the 6-phase remediation plan was executed to address Critical/High issues.

---

## Phase 1: Name/Bundle ID Consistency
- ✅ Task 1.1: Docs "MyPill" → "Kusuridoki" (7 files, 39+ replacements)
- ✅ Task 1.2: l10n ARB files "MyPill" → "Kusuridoki" (app_en.arb, app_ja.arb — onboardingWelcomeTitle, onboardingRoleTitle)
- ✅ Task 1.3: Info.plist permission descriptions "MyPill" → "Kusuridoki" (4 keys)
- ✅ Task 1.4: Bundle ID docs fix — `com.gingers.mypill` → `com.ginger.mypill` (14 occurrences across 3 deployment docs)
- ✅ Task 1.5: APP_STORE_METADATA.md Korean → Japanese
- ✅ Task 1.6: iOS deployment guide path/date corrections

**Verification:** `grep -r "MyPill" docs/ lib/l10n/ ios/Runner/Info.plist` — 0 hits. `grep -r "com\.gingers" docs/` — 0 hits.

## Phase 2: pubspec.yaml Version Pinning
- ✅ Task 2.1: Resolved versions extracted from pubspec.lock
- ✅ Task 2.2: 39 `any` dependencies → `^x.y.z` (Riverpod family, Freezed family compatibility maintained)
- ✅ Task 2.3: `flutter pub get` + `build_runner build` + `flutter analyze` — all pass

**Verification:** `grep "any$" pubspec.yaml` returns only Flutter SDK entries.

## Phase 3: Privacy Policy Links
- ✅ Task 3.1: l10n strings added (privacyPolicy, termsOfService in EN/JA ARBs)
- ✅ Task 3.2: Settings screen — Privacy Policy + Terms of Service ListTile items with url_launcher
- ✅ URL constants in `lib/core/constants/` for single-source management

**Note:** URLs are placeholders. Actual hosting is out of scope (requires user action).

## Phase 4: ReminderService Interval Bug Fix
- ✅ Task 4.1: `_shouldGenerateForDate()` ScheduleType.interval — was `return true;` (generating every day)
- ✅ Fixed: epoch-based modulo calculation using `intervalHours` → `intervalDays`
- ✅ Edge cases handled: null/0 intervalHours fall back to daily generation
- ✅ Timezone-safe: uses local DateTime consistently to avoid day boundary shifts

## Phase 5: Tests
- ✅ Task 5.1: ReminderService tests — 18 tests covering:
  - `_shouldGenerateForDate()`: daily, specificDays, interval (including Phase 4 bug fix verification)
  - `generateRemindersForDate()`: inactive skip, duplicate prevention, multi-time, combining existing+new
  - `markAsTaken()`: status change, actionTime, save, adherence record, not-found error
  - `markAsSkipped()`: status change, adherence record, not-found error
- ✅ Task 5.2: SubscriptionService tests — 16 tests covering:
  - Initial state: isPremium, maxCaregivers, products null
  - maxCaregivers logic: free=1, premium=999 contract
  - statusStream: broadcast, no premature emission
  - onStatusChanged callback
  - Product ID constants
  - SubscriptionStatus model: defaults, copyWith, platform enum
- ✅ Task 5.3: StorageService tests — 2 tests (instantiation, independence)
  - CRUD methods require Hive platform init — documented as integration-test-only

**Additional fixes during Phase 5:**
- Added missing `flutter_secure_storage: ^9.2.4` to pubspec.yaml dependencies
- Added missing `integration_test: sdk: flutter` to dev_dependencies
- Made `SubscriptionService._iap` lazy to enable unit testing without platform channels
- Fixed timezone bug in interval epoch calculation (local vs UTC consistency)

**Verification:** `flutter test` — 75 tests passed, 0 failures. `flutter analyze` — 0 issues.

## Phase 6: progress.md
- ✅ This file created with honest current-state assessment

---

## Overall Test Results

| Test File | Tests | Status |
|-----------|-------|--------|
| app_theme_test.dart | 4 | ✅ All pass |
| widget_test.dart | 3 | ✅ All pass |
| medication_repository_test.dart | 14 | ✅ All pass |
| adherence_service_test.dart | 10 | ✅ All pass |
| timezone_service_test.dart | 8 | ✅ All pass |
| reminder_service_test.dart | 18 | ✅ All pass |
| subscription_service_test.dart | 16 | ✅ All pass |
| storage_service_test.dart | 2 | ✅ All pass |
| **Total** | **75** | **✅ All pass** |

---

## Known Limitations / Not Yet Verified

- ⏳ NotificationService — singleton + platform binding, requires mock infrastructure refactoring for unit tests
- ⏳ IapService — singleton + InAppPurchase platform, same limitation as above
- ⏳ Privacy Policy / Terms of Service URLs — placeholders only, actual pages not hosted
- ⏳ Xcode Team signing — requires user's Apple Developer account
- ⏳ App Store Connect registration — manual process
- ⏳ TestFlight deployment — not attempted
- ⏳ Screenshots — not captured
- ⏳ AI Drug Safety feature — PRD Low priority, deferred

---

## Consumer Panel Tracker

| Gate | Date | Panel Composition | Avg Score | Pass? | Notes |
|------|------|-------------------|-----------|-------|-------|
| G1 | - | - | - | - | Not yet conducted |
| G2 | - | - | - | - | Not yet conducted |
| G3 | - | - | - | - | Not yet conducted |
| G4 | - | - | - | - | Not yet conducted |

---

## Refinement Log

### Refinement: PO Evaluation — 4.5/10 NO-GO
- **Severity**: Major
- **Trigger**: PO evaluation identified Critical/High issues across naming, versioning, privacy, testing
- **Decision by**: Plan approved after DA review
- **Selected plan**: 6-phase remediation (name consistency, version pinning, privacy links, interval bug fix, tests, progress tracking)
- **Result**: All 6 phases completed. 75 tests passing, 0 analyze issues.
- **Re-verification**: PO re-evaluation pending
- **Cycle**: 1st

### Refinement: DA Review — Additional Issues Found
- **Severity**: Major (expanded scope of Phase 1 + added Phase 4)
- **Trigger**: Devils Advocate identified Bundle ID mismatch, l10n/Info.plist "MyPill" remnants, interval bug, platform service test limitations
- **Decision by**: Main agent + DA joint review
- **Selected plan**: Added Tasks 1.2-1.4 to Phase 1, added Phase 4 (interval bug), scoped Phase 5 to pure-Dart services only
- **Result**: All DA findings addressed
- **Cycle**: 1st

---

## Security Review (2026-02-22)

5개 병렬 보안 에이전트로 전체 코드베이스 리뷰 수행: Secrets, Firestore/Storage Rules, Auth/Input Validation, Data Exposure/Logging, Dependency Audit.

### 요약

| 심각도 | 건수 |
|--------|------|
| CRITICAL | 3 |
| HIGH | 7 |
| MEDIUM | 7 |
| LOW | 5 |
| **총 위험 수준** | **HIGH** |

### CRITICAL (즉시 수정)

| ID | 이슈 | 위치 | 영향 |
|----|------|------|------|
| C-1 | 계정 삭제 시 서버 데이터 미삭제 (Auth만 삭제, Firestore 고아 데이터 잔존) | `auth_service.dart:112-114`, `settings_screen.dart:154-158` | GDPR/APPI + App Store Rule 2 위반 |
| C-2 | GoRouter 인증 가드 없음 (redirect 콜백 부재, Deep link로 비인증 접근 가능) | `app_router.dart:24-199` | 비인증 사용자 민감 화면 접근 |
| C-3 | Firebase Storage Rules 파일 없음 (약 사진 등 Storage 사용하나 규칙 부재) | 프로젝트 루트 | 타 사용자 파일 무제한 접근 |

### HIGH (다음 릴리즈 전 수정)

| ID | 이슈 | 위치 |
|----|------|------|
| H-1 | 로그아웃 시 Riverpod Provider 상태 미초기화 (이전 사용자 데이터 메모리 잔존) | `auth_service.dart:107-109`, `settings_screen.dart:108-110` |
| H-2 | `revokeAccess` Cloud Function — linkId 소유권 미검증 (IDOR) | `functions/index.js:75-87` |
| H-3 | Cloud Functions 레이트 리밋 없음 (초대 코드 브루트포스 가능) | `functions/index.js` 전체 |
| H-4 | FCM 토큰 + 메시지 페이로드 debugPrint 로깅 | `notification_service.dart:113, 125` |
| H-5 | Raw Firebase 에러 메시지 사용자 노출 (`e.toString()`, `e.message` → SnackBar) | `add_medication_screen.dart:253`, `edit_medication_screen.dart:329`, `invite_handler_screen.dart:52`, `account_section.dart:198,232`, `photo_picker_button.dart:37` |
| H-6 | 약 사진 비암호화 저장 (`getApplicationDocumentsDirectory()`에 평문 JPEG) | `photo_picker_button.dart:27-29` |
| H-7 | `functions/package-lock.json` 미커밋 (Supply Chain 위험) | `functions/` |

### MEDIUM (2스프린트 내 수정)

| ID | 이슈 | 위치 |
|----|------|------|
| M-1 | 초대 코드 `Math.random()` 사용 (CSPRNG 아님) | `functions/index.js:104-111` |
| M-2 | Hive 암호화 실패 시 평문 fallback (건강 데이터 비암호화) | `storage_service.dart:45-49` |
| M-3 | Firestore `invites` 컬렉션 모든 인증 사용자 읽기 가능 | `firestore.rules:47-50` |
| M-4 | IAP 구독 상태 클라이언트만 검증 (서버사이드 영수증 검증 없음) | `subscription_service.dart:80-103` |
| M-5 | Home Widget에 약 이름/시간/복용량 평문 저장 | `home_widget_service.dart:55-62` |
| M-6 | Deep Link 초대 코드 포맷 미검증 | `deep_link_service.dart:31-35` |
| M-7 | `acceptInvite` 자기 자신 링크 방지 없음 | `functions/index.js:25-72` |

### LOW (백로그)

| ID | 이슈 | 위치 |
|----|------|------|
| L-1 | `deleteAccount` user null 시 silent no-op | `auth_service.dart:112-114` |
| L-2 | 스케줄 폼 입력 검증 없음 (빈 times/days 허용) | `schedule_screen.dart:147-165` |
| L-3 | 약 복용량 음수/0 허용 | `add_medication_screen.dart:215-220` |
| L-4 | PDF 임시 파일 공유 후 미삭제 | `report_service.dart:46,94` |
| L-5 | Android minSdk 21 (2014) — 보안 기능 부족 | `pubspec.yaml:79` |

### 보안 체크리스트

| 항목 | 상태 |
|------|------|
| 하드코딩된 시크릿 없음 | PASS |
| Firebase config 파일 gitignore | PASS |
| CI 시크릿 GitHub Secrets 사용 | PASS |
| Firestore 규칙 사용자 격리 | PASS |
| Cloud Functions 인증 확인 | PASS |
| HTTPS 전용 | PASS |
| Hive 데이터 암호화 | PARTIAL (fallback 문제) |
| Storage 규칙 설정 | FAIL — 규칙 파일 없음 |
| 라우터 인증 가드 | FAIL — redirect 없음 |
| 계정 삭제 전체 데이터 삭제 | FAIL — Auth만 삭제 |
| 로그아웃 상태 초기화 | FAIL — Provider 캐시 잔존 |
| 에러 메시지 사용자 안전 | FAIL — raw exception 노출 |
| Cloud Functions 레이트 리밋 | FAIL |
| 초대 코드 CSPRNG | FAIL |
| FCM 토큰 로깅 없음 | FAIL |

### 우선순위 수정 순서

1. C-1: `deleteUserAccount` Cloud Function 생성
2. C-2: GoRouter `redirect` 인증 가드 추가
3. C-3: `storage.rules` 생성 및 배포
4. H-1: 로그아웃 시 Provider 전체 초기화
5. H-2: `revokeAccess`에 linkId 소유권 검증
6. H-3: Firebase App Check + 레이트 리밋
7. H-4: FCM 토큰/메시지 로깅 제거
8. H-5: 에러 메시지 → l10n 매핑
9. H-6: 약 사진 암호화 또는 경로 변경
10. H-7: `package-lock.json` 커밋 + `npm ci`
11. M-1~7: 초대 코드 CSPRNG, 암호화 fallback 등
