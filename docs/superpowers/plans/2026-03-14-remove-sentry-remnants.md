# Sentry 잔존 코드 제거 Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Sentry→Crashlytics 전환 후 남아있는 Sentry 참조를 모든 빌드/CI/문서 파일에서 제거하여 실제 앱 동작과 일치시킨다.

**Architecture:** 런타임 코드(`lib/`, `pubspec.yaml`)는 이미 정리 완료. Fastfile 2개의 빌드 명령, `.env.example`, 문서 3개, 테스트 주석/AGENTS.md만 수정. `ios/Pods/`는 `pod install`로 자동 정리.

**Tech Stack:** Ruby (Fastlane), Markdown, CocoaPods

**긴급도:** 현재 Fastfile의 `dart run sentry_dart_plugin` 호출은 이미 broken 상태 (pubspec.yaml에서 패키지 제거됨). `fastlane build`/`fastlane internal` 실행 시 즉시 실패. Task 1~2는 긴급 수정.

---

## 사전 확인 완료 사항

- [x] `lib/` — Sentry 참조 0건
- [x] `pubspec.yaml` / `pubspec.lock` — Sentry 참조 0건
- [x] `.github/workflows/` — `SENTRY_DSN` 참조 0건
- [x] `sentry.properties` 등 Sentry 전용 설정 파일 — 없음
- [x] `sentry_dart_plugin` — `dev_dependencies`에서 이미 제거됨

---

## File Structure

| 파일 | 변경 | 책임 |
|------|------|------|
| `ios/Podfile.lock` | 재생성 | `pod install`로 Sentry pod 자동 제거 |
| `android/fastlane/Fastfile` | 수정 | `SENTRY_DSN` dart-define, `sentry_dart_plugin` 호출 제거 |
| `ios/fastlane/Fastfile` | 수정 | `SENTRY_DSN` dart-define, `sentry_dart_plugin` 호출 제거 |
| `ios/fastlane/.env.example` | 수정 | `SENTRY_DSN` 환경변수 제거 |
| `GOOGLE_PLAY_DATA_SAFETY.md` | 수정 | Sentry → Firebase Crashlytics 교체 |
| `docs/progress.md` | 수정 | Sentry → Firebase Crashlytics 교체 |
| `test/core/utils/AGENTS.md` | 수정 | 삭제된 `sentry_scrubber_test.dart` 참조 제거 |
| `test/core/utils/analytics_service_test.dart` | 수정 | 주석의 Sentry 참조 수정 |

변경하지 않는 파일:
- `docs/plans/` — 과거 계획 히스토리 문서 (기록 보존)
- `docs/code-review-report-2026-03-13.md` — 과거 리뷰 보고서 (기록 보존)
- `ios/Pods/Sentry/` — gitignore 대상, `pod install`로 자동 제거

참고: `ios/fastlane/Fastfile`의 `release_local` lane(183줄)도 `build_dart_defines` 함수를 호출한다. Task 2에서 함수 자체를 수정하므로 `release_local`에도 자동 적용된다.

---

## Chunk 1: Podfile.lock + Build/CI 정리

Podfile.lock을 먼저 정리하여 중간 커밋이 CI를 불안정하게 만드는 것을 방지한다.

### Task 1: Pod install로 Sentry SDK 제거

- [ ] **Step 1: Pod install 재실행**

  Run: `cd ios && pod install && cd ..`
  Expected: Sentry/sentry_flutter가 설치 목록에 나타나지 않음

- [ ] **Step 2: Podfile.lock 검증**

  Run: `grep -i sentry ios/Podfile.lock`
  Expected: 0건

  만약 여전히 남아있다면 `cd ios && rm -rf Pods Podfile.lock && pod install && cd ..` 실행.

---

### Task 2: Android Fastfile에서 Sentry 제거

**Files:**
- Modify: `android/fastlane/Fastfile:10-11`

- [ ] **Step 1: `SENTRY_DSN` dart-define 제거**

  10번째 줄에서 `--dart-define=SENTRY_DSN=#{ENV['SENTRY_DSN'] || ''} ` 부분을 제거한다.

  변경 전: `sh("cd .. && flutter build appbundle --release --dart-define=SENTRY_DSN=#{ENV['SENTRY_DSN'] || ''} --dart-define=REVENUECAT_API_KEY=#{ENV['REVENUECAT_API_KEY'] || ''} --obfuscate --split-debug-info=build/debug-info")`

  변경 후: `sh("cd .. && flutter build appbundle --release --dart-define=REVENUECAT_API_KEY=#{ENV['REVENUECAT_API_KEY'] || ''} --obfuscate --split-debug-info=build/debug-info")`

- [ ] **Step 2: `sentry_dart_plugin` 호출 삭제**

  11번째 줄 `sh("cd .. && dart run sentry_dart_plugin")` 전체 삭제.

- [ ] **Step 3: 검증**

  Run: `ruby -c android/fastlane/Fastfile`
  Expected: `Syntax OK`

---

### Task 3: iOS Fastfile에서 Sentry 제거

**Files:**
- Modify: `ios/fastlane/Fastfile:7-12, 69-70`

- [ ] **Step 1: `build_dart_defines` 함수에서 SENTRY_DSN 제거**

  7~12줄의 `build_dart_defines` 함수에서 SENTRY_DSN 줄을 제거한다. 이 함수는 `build` lane(66줄)과 `release_local` lane(183줄) 양쪽에서 호출된다.

  변경 전:
  ```ruby
  def build_dart_defines
    [
      Base64.strict_encode64("SENTRY_DSN=#{ENV['SENTRY_DSN'] || ''}"),
      Base64.strict_encode64("REVENUECAT_API_KEY=#{ENV['REVENUECAT_API_KEY'] || ''}"),
    ].join(",")
  end
  ```

  변경 후:
  ```ruby
  def build_dart_defines
    [
      Base64.strict_encode64("REVENUECAT_API_KEY=#{ENV['REVENUECAT_API_KEY'] || ''}"),
    ].join(",")
  end
  ```

- [ ] **Step 2: `sentry_dart_plugin` 호출 및 주석 삭제**

  69~70줄의 주석 `# Upload dSYMs and source maps to Sentry`와 `sh("cd ../.. && dart run sentry_dart_plugin")` 삭제.

- [ ] **Step 3: 검증**

  Run: `ruby -c ios/fastlane/Fastfile`
  Expected: `Syntax OK`

---

### Task 4: `.env.example`에서 Sentry 제거

**Files:**
- Modify: `ios/fastlane/.env.example:1-2`

- [ ] **Step 1: SENTRY_DSN 환경변수 제거**

  1~2줄 삭제:
  ```
  # Get from: Sentry project → Settings → Client Keys (DSN)
  SENTRY_DSN=
  ```

- [ ] **Step 2: 커밋**

  ```bash
  git add ios/Podfile.lock android/fastlane/Fastfile ios/fastlane/Fastfile ios/fastlane/.env.example
  git commit -m "설정: Fastfile/Podfile.lock/env에서 Sentry 잔존 참조 제거"
  ```

---

## Chunk 2: 문서 + 테스트 정리

### Task 5: GOOGLE_PLAY_DATA_SAFETY.md 수정

**Files:**
- Modify: `GOOGLE_PLAY_DATA_SAFETY.md:16,17,35,41,42`

- [ ] **Step 1: Data Collection 테이블 수정**

  16줄: `Yes (Sentry)` → `Yes (Firebase Crashlytics)`
  17줄: `Yes (Sentry)` → `Yes (Firebase Crashlytics)`

- [ ] **Step 2: Data Sharing Recipients 테이블 수정**

  35줄: `| Sentry | Crash logs, device info, anonymous user ID | Error monitoring |`
  → `| Firebase Crashlytics | Crash logs, device info, anonymous user ID | Error monitoring |`

- [ ] **Step 3: Notes 수정**

  41줄: `AdMob, Sentry, or analytics` → `AdMob, Crashlytics, or analytics`
  42줄: `Sentry automatically strips health-related data before transmission (see SentryConfig)` → `Firebase Crashlytics does not collect health-related data (medication names, dosages, pill shapes, photos are not included in crash reports)`

- [ ] **Step 4: 검증**

  Run: `grep -i sentry GOOGLE_PLAY_DATA_SAFETY.md`
  Expected: 0건

---

### Task 6: docs/progress.md 수정

**Files:**
- Modify: `docs/progress.md:146,158`

- [ ] **Step 1: 두 곳의 Sentry 참조 수정**

  146줄: `Sentry` → `Firebase Crashlytics`
  158줄: `Sentry` → `Firebase Crashlytics`

- [ ] **Step 2: 검증**

  Run: `grep -i sentry docs/progress.md`
  Expected: 0건

---

### Task 7: test/core/utils/AGENTS.md 수정

**Files:**
- Modify: `test/core/utils/AGENTS.md:7,16`

- [ ] **Step 1: Purpose 줄에서 Sentry scrubber 제거**

  7줄: `Tests for lib/core/utils/ — error handler, Apple auth error messages, photo encryption, and Sentry scrubber.`
  → `Tests for lib/core/utils/ — error handler, Apple auth error messages, and photo encryption.`

- [ ] **Step 2: Key Files 테이블에서 sentry_scrubber_test.dart 행 삭제**

  16줄 삭제: `| sentry_scrubber_test.dart | PII scrubbing from Sentry event data |`

---

### Task 8: analytics_service_test.dart 주석 수정

**Files:**
- Modify: `test/core/utils/analytics_service_test.dart:68`

- [ ] **Step 1: 주석 수정**

  68줄: `// SEC-ANALYTICS-002: Sentry.configureScope is also called; both paths`
  → `// SEC-ANALYTICS-002: Crashlytics user ID is also set; both paths`

- [ ] **Step 2: 테스트 통과 확인**

  Run: `flutter test test/core/utils/analytics_service_test.dart`
  Expected: All tests pass

- [ ] **Step 3: 커밋**

  ```bash
  git add GOOGLE_PLAY_DATA_SAFETY.md docs/progress.md test/core/utils/AGENTS.md test/core/utils/analytics_service_test.dart
  git commit -m "문서: Sentry → Firebase Crashlytics 표기 수정 (데이터 안전, 테스트)"
  ```

---

## 최종 검증

- [ ] Run: `grep -ri sentry lib/` → 0건
- [ ] Run: `grep -ri sentry pubspec.yaml` → 0건
- [ ] Run: `grep -ri sentry android/fastlane/` → 0건
- [ ] Run: `grep -ri sentry ios/fastlane/` → 0건
- [ ] Run: `grep -ri sentry .github/` → 0건
- [ ] Run: `grep -ri sentry GOOGLE_PLAY_DATA_SAFETY.md` → 0건
- [ ] Run: `grep -ri sentry docs/progress.md` → 0건
- [ ] Run: `grep -ri sentry test/` → 0건
- [ ] Run: `grep -ri sentry ios/Podfile.lock` → 0건
- [ ] Run: `flutter analyze` → 에러 0건
- [ ] Run: `flutter test test/core/utils/` → All pass

잔존 허용:
- `docs/plans/` — 과거 계획 문서 (히스토리)
- `docs/code-review-report-2026-03-13.md` — 과거 리뷰 보고서 (히스토리)

### Devil's Advocate Review
- **도전한 가정**: (1) Podfile.lock은 pod install로 자동 정리됨 — pubspec.yaml에서 sentry_flutter 제거 확인 완료 (2) CI 파이프라인에 SENTRY_DSN 없음 — .github/workflows/ 직접 검색 확인 완료 (3) sentry_dart_plugin이 dev_dependencies에서 제거됨 — pubspec.yaml/lock 검색 확인 완료
- **검토한 대안**: 단일 커밋 vs 다중 커밋 — CI 안정성을 위해 Podfile.lock을 Fastfile과 동일 커밋에 포함하는 2-커밋 전략 채택
- **식별된 리스크**: (1) Fastfile이 현재 이미 broken 상태 — 긴급도 명시 (2) release_local lane도 build_dart_defines 호출 — 함수 수정으로 자동 적용됨을 명시
- **결론**: 2개 Chunk, 2개 커밋으로 정리. 모든 변경은 텍스트 수정이므로 되돌림 비용 극히 낮음.
