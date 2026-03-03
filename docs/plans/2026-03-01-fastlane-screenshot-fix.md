# Fastlane Screenshot Fix Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** App Store 스크린샷 integration test가 Firebase 초기화 없이도 실기기/시뮬레이터에서 정상 실행되도록 한다.

**Architecture:** 실제 `appRouterProvider`는 `FirebaseAuth.instance.currentUser`를 Riverpod 외부에서 직접 호출하므로 테스트에서 override 불가. `buildCaregiverTestApp`이 이미 해결한 방식(isolated test router + `redirect: null`)을 환자 쉘에도 동일하게 적용한다.

**Tech Stack:** Flutter integration_test, GoRouter, Riverpod, Fastlane flutter drive

---

## 원인 요약

| 문제 | 원인 |
|------|------|
| `No Firebase App '[DEFAULT]'` | integration test는 앱 `main()`을 거치지 않아 `Firebase.initializeApp()` 미호출 |
| `Home tab not found` | 실제 router의 redirect가 `FirebaseAuth.instance.currentUser == null` 판단 → `/onboarding`으로 튕김 |
| 두 문제의 공통 해법 | `appRouterProvider`를 auth check 없는 isolated test router로 override |

---

## Task 1: `buildPatientShellTestApp` 추가

**파일:**
- 수정: `integration_test/utils/test_app.dart`

**목적:**
`buildCaregiverTestApp`과 동일한 패턴으로 환자 쉘용 isolated router를 만드는 helper 함수 쌍 추가.

**설계 결정:**
- `buildPatientShellTestApp(config, {initialRoute})` — `buildCaregiverTestApp`과 동일 구조
- `_buildPatientShellTestRouter(initialRoute)` — `_buildCaregiverTestRouter`와 동일 패턴
  - `redirect: (_, _) => null` — Firebase auth 체크 없음
  - `initialLocation: initialRoute` (기본값 `/home`)
  - 4개 탭: `/home`, `/adherence`, `/medications`, `/settings`
  - 탭 내 sub-routes: `settings/travel`, `settings/family`
  - 독립 routes: `/medications/add`, `/medications/:id`, `/medications/:id/edit`
  - Shell builder: `_TestPatientShell` — `_TestCaregiverShell`과 동일 구조, `KdNavMode.patient` 사용
- provider overrides: `storageServiceProvider`, `authServiceProvider`, `appRouterProvider`

**검증:** `flutter analyze integration_test/utils/test_app.dart` — 0 errors

---

## Task 2: `home_screenshot_test.dart` 수정

**파일:**
- 수정: `integration_test/screenshots/home_screenshot_test.dart`

**목적:**
`buildTestApp(config)` → `buildPatientShellTestApp(config)` 로 교체.

**설계 결정:**
- `TestAppConfig` 내용(medications, schedules, reminders, isAuthenticated 등)은 그대로 유지
- 함수만 교체

**검증:** `flutter analyze integration_test/screenshots/home_screenshot_test.dart` — 0 errors

---

## Task 3: 로컬 시뮬레이터에서 스크린샷 테스트 실행

**목적:** 실제로 홈 탭이 렌더링되고 스크린샷이 찍히는지 확인.

**실행 커맨드:**
```bash
cd ios && bundle exec fastlane screenshots
```

또는 직접:
```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/screenshots/home_screenshot_test.dart \
  -d "iPhone 15 Plus"
```

**성공 기준:**
- Firebase 에러 없음
- `Home tab not found` 에러 없음
- `build/ios_integration/` 에 스크린샷 저장 확인

---

## Devil's Advocate Review

- **도전한 가정**: Firebase.initializeApp()을 호출하는 방법도 있지 않나?
  → integration test에서 Firebase를 초기화하면 실제 Firebase 프로젝트에 연결 시도 → CI/시뮬레이터 환경에서 불안정. Mock router 방식이 더 안전하고 기존 패턴과 일관성 있음.
- **검토한 대안**: `buildTestApp`에 Firebase 초기화 추가 → 기각 (CI 환경 의존성 증가, 불필요한 네트워크 호출)
- **식별된 리스크**: `_TestPatientShell`이 `KdBottomNavBar`를 올바르게 렌더링하지 않으면 홈 탭을 여전히 못 찾을 수 있음 → Task 3에서 반드시 실행 검증
- **결론**: 기존 `buildCaregiverTestApp` 패턴을 그대로 복제하는 것이 가장 안전하고 일관성 있는 방법
