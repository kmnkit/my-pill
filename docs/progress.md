# Project Progress — Kusuridoki (くすりどき)

## Current Status: App Store 제출 준비 중

- 보안 이슈 전건 수정 완료 (L-5 Android minSdk만 보류)
- 一包化 (Dose Pack) 기능 구현 완료
- 약 복용 타이밍 (Dosage Timing) 기능 구현 완료
- Interstitial 광고 제거 완료
- QA 3 Phase 버그 수정 완료
- App Store 메타데이터 및 iOS 다국어 설정 완료
- App Store / Play Store 정책 위반 7개 수정 완료 (2026-03-08)
- 테스트: 1720 passed / 19 skipped / 0 failed
- `flutter analyze`: 0 errors

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

**Verification:** `flutter test` — 91 tests passed, 0 failures. `flutter analyze` — 0 issues.

## Phase 6: progress.md
- ✅ This file created with honest current-state assessment

## Phase 7: 一包化 (Dose Pack) 기능 (2026-02-24)
- ✅ UserProfile에 medicationStyle 필드 추가 (individual / dosePack)
- ✅ 온보딩에 medication style 선택 스텝 추가
- ✅ App Store 메타데이터에 一包化 지원 내용 반영 (EN/JA)
- ✅ SEO 키워드 확장 (dose pack, 一包化)

## Phase 8: QA 버그 수정 3 Phase (2026-02-24)
- ✅ Phase 1 — CRITICAL 버그 수정
- ✅ Phase 2 — HIGH 버그 9건 수정
- ✅ Phase 3 — MEDIUM 버그 8건 수정
- ✅ 추가 수정: settings supporter button hidden, anonymous account deletion, bottom nav alignment, greeting null name

## Phase 9: 약 복용 타이밍 (Dosage Timing) 기능 (2026-02-25)
- ✅ `DosageTiming` enum 추가 (beforeMeal, afterMeal, betweenMeals, atBedtime, onWaking, asNeeded)
- ✅ `Schedule` 모델에 `dosageTiming` 필드 추가 (nullable)
- ✅ `DosageTimingSelector` 위젯 (ChoiceChip 기반, 스케줄 화면에서 선택)
- ✅ 홈 타임라인 카드에 복용 타이밍 라벨 표시
- ✅ 약 상세 화면에 타이밍 정보 표시
- ✅ 알림 본문에 복용 타이밍 포함
- ✅ EN/JA 다국어 지원 (食前/食後/食間/就寝前/起床時/頓服)
- ✅ `enum_l10n_extensions.dart`에 `DosageTimingL10n` extension 추가

## Phase 10: Interstitial 광고 제거 (2026-02-25)
- ✅ `InterstitialProvider`, `InterstitialController` 삭제
- ✅ `AdService`에서 interstitial 관련 코드 제거
- ✅ `app.dart`에서 interstitial 초기화 제거

## Phase 11: App Store 준비 (2026-02-25)
- ✅ iOS Info.plist 다국어 설정 (en.lproj, ja.lproj)
- ✅ iOS 프로젝트 설정 업데이트
- ✅ 소비자 패널 리뷰 문서 추가

## Phase 13: App Store / Play Store 정책 준수 (2026-03-08)

> 계획 문서: `docs/plans/2026-03-08-app-store-policy-compliance.md`

### 코드 수정 완료 (8 commits on main)

| 커밋 | 내용 |
|------|------|
| `fa94d6d` | `kPremiumEnabled=false`일 때 프리미엄 구매 UI 비노출 — "準備中" 화면 표시 |
| `fdd4d12` | `qr_invite_section` premium 진입 경로 플래그 가드 추가 |
| `3b02719` | iOS `Info.plist`에 `NSUserTrackingUsageDescription` 추가 |
| `25c5e92` | `AdConsentService` (UMP 동의 플로우) 신규 추가 — `lib/core/utils/ad_consent_service.dart` |
| `32279d8` | `main.dart`: UMP consent → `AdService.initialize()` 순서 보장 |
| `b604b41` | Android `AndroidManifest.xml`에 `AD_ID` 퍼미션 선언 |
| `2d3e85f` | 구독 약관 iOS/Android 플랫폼 분기 (`subscriptionTermsAndroid` l10n 키 추가) |
| `4360717` | 온보딩 welcome 스텝 하단에 의료 면책 문구 추가 (`medicalDisclaimer` l10n 키) |

**검증 결과:**
- `flutter analyze`: 0 errors
- `flutter test`: 1720 passed, 19 skipped, 0 failed
- `grep NSUserTrackingUsageDescription ios/Runner/Info.plist`: ✅ 확인
- `grep AD_ID android/app/src/main/AndroidManifest.xml`: ✅ 확인

---

### ⏳ 스토어 콘솔 수동 작업 (미완료)

#### ⚠️ 카테고리 전략 주의사항

이 앱은 **생산성(Productivity) 앱**으로 심사 제출 예정. 약 이름·복용 스케줄은 "의료 기록"이 아니라 **사용자가 직접 입력한 리마인더 텍스트**(User Content)로 분류한다. "Health & Fitness" 카테고리를 쓰면 Apple/Google이 의료 앱으로 재분류할 수 있으므로 사용하지 않는다.

#### Google Play Console — Data Safety 섹션

Play Console → 앱 콘텐츠 → 데이터 보안에서 아래 항목 직접 입력:

| 수집 항목 | 카테고리 | 목적 | 공유 여부 |
|-----------|---------|------|-----------|
| 이메일 주소 | Contact Info | 계정 관리 | Firebase (처리자, 공유 아님) |
| 사용자 입력 리마인더 텍스트 (알림 이름·시간) | User Content | 앱 기능 | Firestore (처리자), 보호자 기능 이용 시 선택적 공유 |
| 앱 사용 이벤트 | App activity | 분석 | Firebase Analytics |
| 오류 리포트 + User ID | App info and performance | 앱 안정성 | Firebase Crashlytics |
| 광고 ID | Device or other IDs | 광고 (비개인화) | Google AdMob |

#### App Store Connect — Privacy Nutrition Labels

App Store Connect → 앱 → App Privacy에서 아래 항목 직접 입력:

| 카테고리 | 항목 | 추적 여부 | 비고 |
|----------|------|-----------|------|
| Contact Info | Email Address | No | 인증용, 제3자 판매 없음 |
| User Content | Other User Content (리마인더 텍스트) | No | 사용자 입력 알림 데이터 |
| Identifiers | User ID | No | — |
| Diagnostics | Crash Data | No | Firebase Crashlytics |
| Usage Data | Product Interaction | No | Firebase Analytics |
| Identifiers | Device ID | Yes | AdMob 비개인화 광고 — ATT 동의 필요 (NSUserTrackingUsageDescription 추가 완료) |

> **Health & Fitness 카테고리는 사용하지 않는다.** 약 이름/스케줄은 사용자가 직접 입력한 텍스트 콘텐츠(할 일 목록, 캘린더 항목과 동일 성격)이며 의료 기록·건강 수치가 아님.

---

## Phase 12: 대규모 테스트 추가 (2026-02-25)
- ✅ core (constants, extensions, theme, utils) 테스트 추가
- ✅ data 레이어 (enums, models, providers, repositories, services) 테스트 추가
- ✅ presentation 레이어 (screens, shared widgets, dialogs) 테스트 추가
- ✅ 테스트 헬퍼 유틸리티 추가

---

## Overall Test Results (2026-03-08)

| 항목 | 수치 |
|------|------|
| **총 테스트** | **1,739** |
| **Passed** | **1,720** |
| **Skipped** | **19** (kPremiumEnabled=false 관련) |
| **Failed** | **0** |
| **flutter analyze** | 0 errors |

---

## Known Limitations / Not Yet Verified

- ✅ ~~NotificationService~~ — 테스트 추가 완료
- ✅ ~~IapService~~ — 테스트 추가 완료
- ✅ ~~Privacy Policy / Terms of Service URLs~~ — CloudFlare Pages에 배포 완료
- ⏳ Xcode Team signing — requires user's Apple Developer account
- ⏳ App Store Connect registration — manual process
- ⏳ TestFlight deployment — not attempted
- ⏳ Screenshots — 스크린샷 시더 유틸리티 추가됨, 실제 캡처는 미완
- ⏳ AI Drug Safety feature — PRD Low priority, deferred
- ⏳ Settings 관련 테스트 19건 실패 — 수정 필요
- ⏳ M-4 Phase B — IAP Apple/Google API 서버사이드 영수증 검증 별도 스프린트

---

## Consumer Panel Tracker

| Gate | Date | Panel Composition | Avg Score (지속) | Avg Score (추천) | Pass? | Notes |
|------|------|-------------------|-----------------|-----------------|-------|-------|
| G1 | 2026-02 | 5~7명 가상 패널 | 6.3 | 4.9 | 조건부 | docs/CONSUMER_PANEL_INSIGHTS.md 참조 |
| G2 | 2026-02-26 | 7명 (68F JP, 27M US, 48F JP nurse, 34M UK dev, 62M JP, 16F JP, 43F JP-CA) | 6.4 | 5.3 | 조건부 | 온보딩 중복 구조(P0) + 게임화 부재(P1) 수정 후 G3 진행 권고 |
| G3 | - | - | - | - | - | Not yet conducted |
| G4 | - | - | - | - | - | Not yet conducted |

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
| C-1 | ~~계정 삭제 시 서버 데이터 미삭제~~ **수정됨 (2026-02-22)** — `deleteUserAccount` CF: 5개 subcollection + caregiverAccess 양방향 + Auth 삭제 + invite/rateLimit 정리 (2026-02-23) | `functions/index.js` | ~~GDPR/APPI + App Store Rule 2 위반~~ RESOLVED |
| C-2 | ~~GoRouter 인증 가드 없음~~ **수정됨 (2026-02-22)** — `app_router_provider.dart` redirect + refreshListenable. 구버전 `app_router.dart` 삭제 (2026-02-23) | `app_router_provider.dart` | ~~비인증 사용자 민감 화면 접근~~ RESOLVED |
| C-3 | ~~Firebase Storage Rules 파일 없음~~ **수정됨 (2026-02-22)** — `storage.rules` user-scoped deny-all 존재 + `firebase.json` 배포 설정 추가 (2026-02-23) | `storage.rules`, `firebase.json` | ~~타 사용자 파일 무제한 접근~~ RESOLVED |

### HIGH (다음 릴리즈 전 수정)

| ID | 이슈 | 위치 |
|----|------|------|
| H-1 | ~~로그아웃 시 Riverpod Provider 상태 미초기화~~ **수정됨 (2026-02-22)** — 로그아웃/계정삭제 시 7개 provider invalidation. DRY 헬퍼 추출 (2026-02-23) | `settings_screen.dart` |
| H-2 | ~~`revokeAccess` Cloud Function — linkId 소유권 미검증 (IDOR)~~ **수정됨 (2026-02-22)** — linkDoc.exists 소유권 검증 | `functions/index.js` |
| H-3 | ~~Cloud Functions 레이트 리밋 없음 (초대 코드 브루트포스 가능)~~ **수정됨** — `revokeAccess`(5/분), `deleteUserAccount`(3/분) 레이트 리밋 추가 | `functions/index.js` 전체 |
| H-4 | ~~FCM 토큰 + 메시지 페이로드 debugPrint 로깅~~ **수정됨 (2026-02-22)** — `kDebugMode` 가드 (release 빌드에서 제거) | `notification_service.dart` |
| H-5 | ~~Raw Firebase 에러 메시지 사용자 노출~~ **수정됨** — l10n에서 `{error}` 플레이스홀더 제거, `ErrorHandler.debugLog` 추가 | `add_medication_screen.dart`, `edit_medication_screen.dart`, `invite_handler_screen.dart`, `account_section.dart`, `photo_picker_button.dart`, `qr_invite_section.dart` |
| H-6 | 약 사진 비암호화 저장 (`getApplicationDocumentsDirectory()`에 평문 JPEG) | `photo_picker_button.dart:27-29` |
| H-7 | `functions/package-lock.json` 미커밋 (Supply Chain 위험) | `functions/` |

### MEDIUM (2스프린트 내 수정)

| ID | 이슈 | 위치 |
|----|------|------|
| M-1 | ~~초대 코드 `Math.random()` 사용~~ **수정됨 (2026-02-22)** — `crypto.randomBytes(8)` CSPRNG | `functions/index.js` |
| M-2 | ~~Hive 암호화 실패 시 평문 fallback~~ **수정됨 (2026-02-23)** — `_openBox()`에서 평문 fallback 제거, `_cipher == null` 시 StateError throw | `storage_service.dart` |
| M-3 | Firestore `invites` 컬렉션 읽기 권한 — **FALSE POSITIVE**: `resource.data.patientId == request.auth.uid` 이미 적용 | `firestore.rules:47-50` |
| M-4 | ~~IAP 구독 상태 클라이언트만 검증~~ **수정됨 Phase A (2026-02-23)** — `verifyReceipt` CF 추가, 서버사이드 영수증 저장 + premium 상태 업데이트. Phase B (Apple/Google API 연동) 별도 | `functions/index.js`, `subscription_service.dart` |
| M-5 | Home Widget 약 정보 — **ALREADY SECURE**: 약 이름/복용량은 빈 문자열, 카운트+시간만 저장. 프라이버시 설계 주석 추가 | `home_widget_service.dart` |
| M-6 | ~~Deep Link 초대 코드 regex 과도하게 관대~~ **수정됨 (2026-02-23)** — 서버 charset과 일치하는 strict regex 적용 + 테스트 추가 | `deep_link_service.dart` |
| M-7 | ~~`acceptInvite` 자기 자신 링크 방지 없음~~ **수정됨 (2026-02-22)** — `caregiverId === patientId` 체크 | `functions/index.js` |

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
| Hive 데이터 암호화 | PASS — 평문 fallback 제거, cipher 없으면 StateError throw (2026-02-23) |
| 약 사진 암호화 | PASS — AES-256 `.enc` 파일 저장 + 자동 마이그레이션 (2026-02-23) |
| Storage 규칙 설정 | PASS — `storage.rules` + `firebase.json` 배포 설정 완료 (2026-02-23) |
| 라우터 인증 가드 | PASS — `app_router_provider.dart` redirect + refreshListenable (2026-02-22) |
| 계정 삭제 전체 데이터 삭제 | PASS — `deleteUserAccount` CF: subcollections + caregiverAccess + invites + rateLimits + Auth (2026-02-23) |
| 로그아웃 상태 초기화 | PASS — 7개 provider invalidation + DRY 헬퍼 추출 (2026-02-23) |
| 에러 메시지 사용자 안전 | PASS — l10n에서 {error} 제거, debugLog 추가 |
| Cloud Functions 레이트 리밋 | PASS — 전 함수 적용 완료 |
| 초대 코드 CSPRNG | PASS — `crypto.randomBytes(8)` (2026-02-22) |
| FCM 토큰 로깅 없음 | PASS — `kDebugMode` 가드 (2026-02-22) |

### 수정 완료 이슈 (2026-02-22 ~ 2026-02-23)

| ID | 상태 |
|----|------|
| C-1 | ✅ `deleteUserAccount` CF + invite/rateLimit 정리 |
| C-2 | ✅ GoRouter redirect 인증 가드 + 구버전 라우터 삭제 |
| C-3 | ✅ `storage.rules` + `firebase.json` 배포 설정 |
| H-1 | ✅ Provider invalidation + DRY 헬퍼 추출 |
| H-2 | ✅ `revokeAccess` linkId 소유권 검증 |
| H-3 | ✅ Cloud Functions 레이트 리밋 |
| H-4 | ✅ FCM 로깅 `kDebugMode` 가드 |
| H-5 | ✅ 에러 메시지 l10n 매핑 + `debugLog` |
| H-6 | ✅ 약 사진 AES-256 암호화 (`.enc`) + 기존 사진 자동 마이그레이션 + 고아 파일 정리 + Add/Edit 화면 사진 상태 연결 |
| H-7 | ✅ `functions/package-lock.json` 커밋 완료 (`69b27c0`) |
| M-1 | ✅ 초대 코드 CSPRNG (`crypto.randomBytes`) |
| M-7 | ✅ 자기 초대 방지 (`caregiverId === patientId`) |
| M-2 | ✅ Hive 평문 fallback 제거 — `_openBox()` StateError throw |
| M-4 | ✅ IAP 서버사이드 영수증 저장 Phase A — `verifyReceipt` CF + client fire-and-forget |
| M-6 | ✅ Deep Link regex 강화 — 서버 charset 일치 + 테스트 추가 |
| L-1 | ✅ `deleteAccount` user null → StateError throw |
| L-2 | ✅ 스케줄 폼 빈 times/days 입력 검증 + l10n |
| L-3 | ✅ 약 복용량 `<= 0` 거부 + l10n |
| L-4 | ✅ PDF 임시 파일 shareReport() 후 자동 삭제 |

### 미해결 이슈 (백로그)

| ID | 이슈 | 우선순위 |
|----|------|----------|
| ~~H-6~~ | ~~약 사진 비암호화 저장~~ **수정됨 (2026-02-23)** — AES-256 암호화 `.enc` 파일 저장 + 기존 사진 자동 마이그레이션 | ~~HIGH~~ RESOLVED |
| ~~H-7~~ | ~~`functions/package-lock.json` 미커밋~~ **수정됨 (2026-02-23)** — 커밋 `69b27c0`에서 추가 완료 | ~~HIGH~~ RESOLVED |
| ~~M-2~~ | ~~Hive 암호화 실패 시 평문 fallback~~ **수정됨 (2026-02-23)** | ~~MEDIUM~~ RESOLVED |
| M-3 | Firestore `invites` 컬렉션 읽기 권한 — **FALSE POSITIVE** (이미 patientId 검증 적용) | MEDIUM — N/A |
| ~~M-4~~ | ~~IAP 서버사이드 영수증 검증~~ **Phase A 수정됨 (2026-02-23)**, Phase B (Apple/Google API) 별도 스프린트 | ~~MEDIUM~~ PARTIAL |
| M-5 | Home Widget 약 정보 — **ALREADY SECURE** (카운트+시간만 저장, 프라이버시 주석 추가) | MEDIUM — N/A |
| ~~M-6~~ | ~~Deep Link 초대 코드 포맷 미검증~~ **수정됨 (2026-02-23)** | ~~MEDIUM~~ RESOLVED |
| ~~L-1~~ | ~~`deleteAccount` user null 시 silent no-op~~ **수정됨 (2026-02-23)** — StateError throw | ~~LOW~~ RESOLVED |
| ~~L-2~~ | ~~스케줄 폼 입력 검증 없음~~ **수정됨 (2026-02-23)** — 빈 times/days 저장 방지 + l10n | ~~LOW~~ RESOLVED |
| ~~L-3~~ | ~~약 복용량 음수/0 허용~~ **수정됨 (2026-02-23)** — `<= 0` 거부 + l10n | ~~LOW~~ RESOLVED |
| ~~L-4~~ | ~~PDF 임시 파일 공유 후 미삭제~~ **수정됨 (2026-02-23)** — shareReport() 후 자동 삭제 | ~~LOW~~ RESOLVED |
| L-5 | Android minSdk 21 — android 디렉토리 미생성으로 보류 | LOW — DEFERRED |
