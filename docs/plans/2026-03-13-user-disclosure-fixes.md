# 사용자 고지사항 수정 계획

> **For agentic workers:** REQUIRED: Use superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 프라이버시 정책·이용약관·앱 내 고지가 실제 데이터 수집/처리와 일치하도록 수정하여 App Store/Play Store 심사 통과 및 법적 리스크 제거

**Architecture:** 코드 변경 최소화 (iOS ATT 1건 + l10n 키 2건). 나머지는 정적 HTML/설정 파일 수정. 기존 UMP 동의 플로우(`AdConsentService`) 유지, iOS ATT는 UMP SDK 내장 ATT 처리에 의존 (별도 패키지 불필요, `NSUserTrackingUsageDescription` 추가만 필요).

**Tech Stack:** Flutter 3.41+, google_mobile_ads v7 (UMP 내장 ATT), Info.plist, InfoPlist.strings, site/ HTML

---

## 파일 변경 맵

| 파일 | 작업 | 이유 |
|------|------|------|
| `ios/Runner/Info.plist` | 수정 | ATT 용도 설명 키 추가 |
| `ios/Runner/ja.lproj/InfoPlist.strings` | 생성 | iOS 권한 설명 일본어 |
| `site/privacy-policy/index.html` | 수정 | Sentry Replay 범위 + UID 전송 고지 |
| `site/terms/index.html` | 수정 | 푸터 면책 일본어 |
| `lib/l10n/app_en.arb` | 수정 | 다이얼로그 레이블 |
| `lib/l10n/app_ja.arb` | 수정 | 동일 |

---

## Phase 1: CRITICAL — App Store 심사 블로커 (P0)

### Task 1: iOS ATT 용도 설명 추가

**파일:** `ios/Runner/Info.plist` 수정

**목적:** `NSUserTrackingUsageDescription` 키 추가. 없으면 Apple 심사 자동 거부.

**설계 결정:** 별도 `app_tracking_transparency` 패키지 불필요 — `google_mobile_ads v7` UMP SDK가 ATT를 내부 처리하므로 Info.plist 키만 추가하면 충분

**검증:**
- [ ] `grep NSUserTrackingUsageDescription ios/Runner/Info.plist` → 존재
- [ ] `flutter build ios --no-codesign` → 성공

**커밋:** `설정: iOS NSUserTrackingUsageDescription 추가`

---

### Task 2: Sentry Session Replay 고지 범위 정정

**파일:** `site/privacy-policy/index.html` (EN Section 6 + JA Section 6)

**현재 (부정확):**
- "captured on 10% of error sessions"
- "エラーセッションの10%で取得"

**실제 코드 (`main.dart:43-45`):**
- `sessionSampleRate = 0.1` → 전체 세션의 10%
- `onErrorSampleRate = 1.0` → 에러 세션의 100%

**수정:** "10% of all sessions and 100% of error sessions" / "全セッションの10%およびエラーセッションの100%"

**검증:**
- [ ] EN Section 6 문구 정정 확인
- [ ] JA Section 6 문구 정정 확인

**커밋:** `문서: Sentry Session Replay 고지 범위 정정`

---

## Phase 2: HIGH — 고지 정확성 (P1)

### Task 3: 제3자 서비스 UID 전송 명시

**파일:** `site/privacy-policy/index.html` (EN/JA Section 4)

**목적:** RevenueCat과 Firebase Analytics에 Firebase UID가 전송되는 사실을 명시

**근거:**
- `AnalyticsService.setUserId(uid)` → Firebase Analytics에 UID 연결
- `SubscriptionService.setUserId(userId)` → `Purchases.logIn(userId)` 호출

**수정:** Section 4 기존 항목의 설명 보완
- Firebase Analytics: "anonymized" → UID 연결 사실 추가
- RevenueCat: UID 전송 추가

**검증:**
- [ ] EN Section 4 — Firebase Analytics/RevenueCat UID 언급 확인
- [ ] JA Section 4 — 동일

**커밋:** `문서: Firebase Analytics/RevenueCat UID 전송 고지 추가`

---

### Task 4: 데이터 공유 다이얼로그 레이블 명확화

**파일:** `lib/l10n/app_en.arb`, `lib/l10n/app_ja.arb`

**목적:** "Data Sharing Preferences"가 보호자 공유만 제어한다는 사실을 레이블에서 명확히

**수정 키:** `dataSharingPreferences` → 보호자 공유임을 명시하는 레이블로 변경

**실행:** `flutter gen-l10n`

**검증:**
- [ ] `flutter analyze` 0 errors
- [ ] `flutter gen-l10n` 성공

**커밋:** `수정: 데이터 공유 다이얼로그 레이블을 보호자 공유로 명확화`

---

## Phase 3: MEDIUM — 로컬라이징 완성도 (P2)

### Task 5: 사이트 푸터 면책 문구 일본어 추가

**파일:** `site/privacy-policy/index.html`, `site/terms/index.html` (각 footer)

**목적:** "※ This app is not a medical device..." 영어 단일 → JA 병기

**검증:**
- [ ] privacy-policy 푸터 EN+JA 확인
- [ ] terms 푸터 EN+JA 확인

**커밋:** `문서: 사이트 푸터 면책 문구 일본어 추가`

---

### Task 6: iOS 권한 설명 일본어 로컬라이징

**파일:** `ios/Runner/ja.lproj/InfoPlist.strings` 생성

**목적:** iOS 일본어 설정 시 카메라/사진/알림/ATT 권한 다이얼로그가 일본어로 표시

**대상 키 (4개):**
- `NSCameraUsageDescription`
- `NSPhotoLibraryUsageDescription`
- `NSNotificationUsageDescription`
- `NSUserTrackingUsageDescription` (Task 1 의존)

**검증:**
- [ ] `ls ios/Runner/ja.lproj/InfoPlist.strings` 존재
- [ ] `flutter build ios --no-codesign` 성공

**커밋:** `설정: iOS 권한 설명 일본어 로컬라이징 추가`

---

## 최종 검증

- [ ] `flutter analyze` 0 errors
- [ ] `flutter test` 기존 테스트 전체 통과
- [ ] `flutter gen-l10n` 성공
- [ ] `flutter build ios --no-codesign` 성공

## 의존 관계

- Task 6 → Task 1 (ATT 키의 JA 번역 포함)
- 나머지 Task 간 의존 없음

## Devil's Advocate Review

- **도전한 가정:** "UMP SDK가 ATT 자체 처리" — `google_mobile_ads v7` 문서 기준 맞음. 단, `NSUserTrackingUsageDescription` 없으면 UMP도 ATT 요청 건너뜀. 키 추가만으로 충분.
- **검토한 대안:** `app_tracking_transparency` 패키지 추가 → 기각. 불필요한 의존성.
- **식별된 리스크:** HTML 수동 편집 시 EN/JA 불일치 가능. 완화: 각 Task에서 양쪽 동시 수정.
- **결론:** 6 Task, 6 커밋. 최소 변경으로 모든 고지 누락 해소.
